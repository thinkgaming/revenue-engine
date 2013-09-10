//
//  ThinkGaming.m
//  ThinkGaming
//
//  Copyright (c) 2013 ThinkGaming. All rights reserved.
//

#import "ThinkGamingLogger.h"
#import "Reachability.h"
#import <AdSupport/ASIdentifierManager.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "EventQueue.h"
#import "ThinkGamingLoggingApiAdapter.h"
#import "VerificationController.h"


#define QUEUE_FLUSH_TIME 30 // In seconds
#define MAX_NUM_BYTES   (64 * 1024) // Max number of bytes to send per event

#define kThinkGamingViewStoreLogId @"viewed_store"
#define kThinkGamingTappedItemLogId @"tapped_purchase"


@interface ThinkGamingLogger ()
- (void) dispatchEvents;
- (BOOL) isConnected;

@property (nonatomic, retain) EventQueue *eventQueue;
@property (nonatomic, retain) NSTimer *dispatchTimer;
@property (nonatomic, retain) NSString *apiKey;
@property (nonatomic, retain) NSString *mediaSourceID;
@end

@implementation ThinkGamingLogger

static ThinkGamingLogger* sharedSingleton;

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

+ (ThinkGamingLogger*)shared {
	@synchronized(self)
	{
		if (!sharedSingleton)
        {
			sharedSingleton = [[ThinkGamingLogger alloc] init];
        }
	}
	return sharedSingleton;
}

+(id)alloc {
	@synchronized(self)
	{
		NSAssert(sharedSingleton == nil, @"Attempted to allocate a second instance of a singleton.");
		sharedSingleton = [super alloc];
	}
	return sharedSingleton;
}

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    [self initTimer];
    self.eventQueue = [[EventQueue alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
        
    return self;
}

- (void) initTimer {
    self.dispatchTimer = [NSTimer scheduledTimerWithTimeInterval:QUEUE_FLUSH_TIME target:self selector:@selector(dispatchEvents) userInfo:nil repeats:YES];
}

- (void) destroyTimer {
    [self.dispatchTimer invalidate];
    self.dispatchTimer = nil;
}

- (NSString *)cohortId {
    NSString *cohort = [[NSUserDefaults standardUserDefaults] valueForKey:@"cohortId"];
    if (cohort) return cohort;
    
    cohort = [[NSNumber numberWithInt:arc4random() %(100)-1] stringValue];
    [[NSUserDefaults standardUserDefaults] setValue:cohort forKey:@"cohortId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return cohort;
}

#pragma mark - Application Lifecycle
- (void) applicationDidEnterBackground:(NSNotification *)notification {
    [self destroyTimer];
    
    UIApplication *application = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier background_task;
    
    void (^completeBlock)(void) = ^{
        [application endBackgroundTask: background_task];
        background_task = UIBackgroundTaskInvalid;
    };
    
    
    background_task = [application beginBackgroundTaskWithExpirationHandler:completeBlock];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self dispatchEvents];
        completeBlock();
    });
}

- (void) applicationWillEnterForeground:(NSNotification *)notification {
    [self initTimer];
}



#pragma mark Private Methods

- (void)logEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters timed:(BOOL)timed stopTimer:(BOOL)stopTimer {
    
    NSNumber *curTimestamp = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.apiKey forKey:@"__TG__apiKey"];
    [dict setValue:curTimestamp forKey:@"__TG__timestamp"];
    [dict setValue:eventName forKey:@"__TG__eventName"];
    [dict setValue:[NSNumber numberWithBool:timed] forKey:@"__TG__timed"];
    [dict setValue:[NSNumber numberWithBool:stopTimer] forKey:@"__TG__stopTimer"];
    [dict setValue:[NSNumber numberWithInteger:[[self cohortId] integerValue]] forKey:@"__TG__cohortID"];
    
    NSString *ipAddress = [self getIPAddress];
    if(ipAddress)
    {
        [dict setValue:ipAddress forKey:@"__TG__IPAddress"];
    }
    
    NSString *locale = [self getUserLanguage];
    if(locale)
    {
        [dict setValue:locale forKey:@"__TG__locale"];
    }
    
    NSString *deviceID = [ThinkGamingLogger deviceId];
    if(deviceID)
    {
        [dict setValue:deviceID forKey:@"__TG__userID"];
    }
    
    if (self.mediaSourceID) {
        [dict setValue:self.mediaSourceID forKey:@"__TG__mediaSourceID"];
    }
    
    // Might want to do some size checking for user data or check validity (non-binary items)?
    if (parameters) [dict setValue:parameters forKey:@"__TG__userData"];
    
    NSData * data = [NSPropertyListSerialization dataFromPropertyList:dict
                                                               format:NSPropertyListBinaryFormat_v1_0 errorDescription:NULL];
    
    if([data length] < MAX_NUM_BYTES)
        [self.eventQueue addEvent:dict];
    else
    {
//        NSLog(@"ThinkGaming - Size of event data (%d) exceeded max (%d). Not sent.", [data length], MAX_NUM_BYTES);
    }
    
}

#pragma mark - Queue handlers


- (void) dispatchEvents {
    if (![self isConnected]) return;
    
    NSMutableArray *events = [self.eventQueue drainEvents];
    if (events && events.count > 0) {
        [ThinkGamingLoggingApiAdapter dispatchEvents:[NSDictionary dictionaryWithObject:events forKey:@"__TG__payload"] success:^(NSData *result) {
            
        } error:^(NSError *err) {
            
        }];
    }
}

- (BOOL) isConnected
{
    TG_Reachability *hostReach = [TG_Reachability reachabilityForInternetConnection];
    TG_NetworkStatus netStatus = [hostReach currentReachabilityStatus];
    return !(netStatus == NotReachable);
}

#pragma mark - Public Methods

+ (void) forceFlush {
    if (sharedSingleton == nil) return;
    [sharedSingleton dispatchEvents];
}

+ (NSString *) currentApiKey {
    if (sharedSingleton == nil) return nil;
    return sharedSingleton.apiKey;
}

+ (ThinkGamingLogger *)startSession:(NSString *)apiKey andMediaSourceId:(NSString *)mediaSourceId {
    //if (![sharedSingleton isConnected]) return;
    
    NSLog(@"ThinkGaming - starting session.");
    [ThinkGamingLogger shared]; // Init if not already started
    sharedSingleton.apiKey = apiKey;
    sharedSingleton.mediaSourceID = mediaSourceId;
    
    
    // Check to see if we have ever run with the lib
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"__TG__firstLaunchDate"]) // Check to see if we have ever launched
    {
        //NSLog(@"ThinkGaming - first time run");
        // First time we're run, so lets get some IDs and save 'em out
        NSString *identifierForVendor = @"";
        NSString *advertisingIdentifier = @"";
        if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)])
            identifierForVendor = [[UIDevice currentDevice] identifierForVendor].UUIDString;
        if (NSClassFromString(@"ASIdentifierManager")) {
            advertisingIdentifier = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        }
        
        NSNumber *curTimestamp = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
        [defaults setObject:curTimestamp forKey:@"__TG__firstLaunchDate"];
        [defaults setObject:identifierForVendor forKey:@"__TG__identifierForVendor"];
        [defaults setObject:advertisingIdentifier forKey:@"__TG__advertisingIdentifier"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // Now that we have some info, lets use a log call to send it!
        NSDictionary *firstRunDict = [NSMutableDictionary dictionaryWithCapacity:4];
        [firstRunDict setValue:curTimestamp forKey:@"__TG__firstLaunchDate"];
        [firstRunDict setValue:identifierForVendor forKey:@"__TG__identifierForVendor"];
        [firstRunDict setValue:advertisingIdentifier forKey:@"__TG__advertisingIdentifier"];
        
        [sharedSingleton logEvent:@"__TG__firstLaunch" withParameters:firstRunDict timed:NO stopTimer:NO];
    }
    else
    {
        [ThinkGamingLogger logEvent:@"__TG__sessionStart"];
    }
    
    return sharedSingleton;
}

+ (void) setReceiptValidationModeToSandbox {
    [TG_VerificationController sharedInstance].serverUrl = TG_ITMS_SANDBOX_VERIFY_RECEIPT_URL;
}

+ (void) setReceiptValidationModeToProduction {
    [TG_VerificationController sharedInstance].serverUrl = TG_ITMS_PROD_VERIFY_RECEIPT_URL;
}

+ (ThinkGamingLogger *)startSession:(NSString *)key {
    return [ThinkGamingLogger startSession:key andMediaSourceId:nil];
}

+ (void)logEvent:(NSString *)eventName {
    [sharedSingleton logEvent:eventName withParameters:nil timed:NO stopTimer:NO];
}

+ (void)logEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters {
    [sharedSingleton logEvent:eventName withParameters:parameters timed:NO stopTimer:NO];
}

+ (void)logEvent:(NSString *)eventName timed:(BOOL)timed {
    [sharedSingleton logEvent:eventName withParameters:nil timed:timed stopTimer:NO];
}

+ (void)logEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters timed:(BOOL)timed {
    [sharedSingleton logEvent:eventName withParameters:parameters timed:timed stopTimer:NO];
}

+ (ThinkGamingEvent *)endTimedEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters {
    [sharedSingleton logEvent:eventName withParameters:parameters timed:YES stopTimer:YES];
    return [[ThinkGamingEvent alloc] initWithEventName:eventName];
}

+ (ThinkGamingEvent *)startTimedEvent:(NSString *)eventName {
    return [self startTimedEvent:eventName withParameters:nil];
}

+ (ThinkGamingEvent *)startTimedEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters {
    [sharedSingleton logEvent:eventName withParameters:parameters timed:YES stopTimer:NO];
    return [[ThinkGamingEvent alloc] initWithEventName:eventName];
}

+ (ThinkGamingEvent *)endTimedEvent:(NSString *)eventName {
    return [self endTimedEvent:eventName withParameters:nil];
}

+ (ThinkGamingEvent *) startLoggingViewedStore:(NSString *)storeIdentifier {
    return [ThinkGamingLogger startTimedEvent:kThinkGamingViewStoreLogId withParameters:@{@"store_id":storeIdentifier}];
}

+ (ThinkGamingEvent *) startLoggingBuyingProduct:(NSString *)productIdentifier
                                     withPriceId:(NSNumber *)priceId
                                    andMessageId:(NSNumber *)messageId {
    return [ThinkGamingLogger startTimedEvent:kThinkGamingTappedItemLogId withParameters:@{@"itunes_id":productIdentifier, @"price_id":priceId, @"message_id":messageId}];
}

+ (ThinkGamingEvent *) endLoggingBuyingProduct:(NSString *)productIdentifier
                                     withPriceId:(NSNumber *)priceId
                                    andMessageId:(NSNumber *)messageId
                                     andResult:(NSString*) result {
    return [ThinkGamingLogger startTimedEvent:kThinkGamingTappedItemLogId withParameters:@{@"itunes_id":productIdentifier, @"price_id":priceId, @"message_id":messageId, @"result":result}];
}



#pragma mark - Device helpers

- (NSString *)getIPAddress
{
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    NSString *wifiAddress = nil;
    NSString *cellAddress = nil;
    
    // retrieve the current interfaces - returns 0 on success
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            sa_family_t sa_type = temp_addr->ifa_addr->sa_family;
            if(sa_type == AF_INET || sa_type == AF_INET6) {
                NSString *name = [NSString stringWithUTF8String:temp_addr->ifa_name];
                NSString *addr = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]; // pdp_ip0
                //NSLog(@"NAME: \"%@\" addr: %@", name, addr); // see for yourself
                
                if([name isEqualToString:@"en0"]) {
                    // Interface is the wifi connection on the iPhone
                    wifiAddress = addr;
                } else
                    if([name isEqualToString:@"pdp_ip0"]) {
                        // Interface is the cell connection on the iPhone
                        cellAddress = addr;
                    }
            }
            temp_addr = temp_addr->ifa_next;
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    NSString *addr = wifiAddress ? wifiAddress : cellAddress;
    return addr ? addr : @"0.0.0.0";
}

-(NSString*) getUserLanguage
{
    NSLocale *locale = [NSLocale currentLocale];
    
    NSString *language = [locale localeIdentifier]; //[locale displayNameForKey:NSLocaleIdentifier value:[locale localeIdentifier]];
    return language;
}


+(NSString*) deviceId {
    
    NSString *uniqueID;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id uuid = [defaults objectForKey:@"uniqueID"];
    if (uuid)
        uniqueID = (NSString *)uuid;
    else {
        CFUUIDRef cfUuid = CFUUIDCreate(NULL);
        CFStringRef cfUuidString = CFUUIDCreateString(NULL, cfUuid);
        CFRelease(cfUuid);
        uniqueID = (__bridge NSString *)cfUuidString;
        [defaults setObject:uniqueID forKey:@"uniqueID"];
        CFRelease(cfUuidString);
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
    
    return uniqueID;

}


@end

@implementation ThinkGamingEvent

- (id) initWithEventName:(NSString *)eventName {
    if (self = [super init]) {
        self.eventName = eventName;
    }
    return self;
}

- (ThinkGamingEvent *)endTimedEvent {
    return [self endTimedEventWithParameters:nil];
}

- (ThinkGamingEvent *)endTimedEventWithParameters:(NSDictionary *)parameters {
    [ThinkGamingLogger endTimedEvent:self.eventName withParameters:parameters];
    return self;
}

- (ThinkGamingEvent *)endViewProductWithPurchaseWithParameters:(NSDictionary *) parameters {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    dict[@"result"] = @"didPurchase";
    [ThinkGamingLogger endTimedEvent:self.eventName withParameters:dict];
    return self;
}

- (ThinkGamingEvent *)endViewProductWithOutPurchaseWithParameters:(NSDictionary *) parameters {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    dict[@"result"] = @"didNotPurchase";
    [ThinkGamingLogger endTimedEvent:self.eventName withParameters:dict];
    return self;
}

@end
