//
//  ThinkGaming.m
//  ThinkGaming
//
//  Copyright (c) 2013 ThinkGaming. All rights reserved.
//

#import "ThinkGaming.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPRequestOperation.h"
#import "Reachability.h"
#import <AdSupport/ASIdentifierManager.h>

#define QUEUE_FLUSH_TIME 30 // In seconds

@interface ThinkGaming ()
- (void)logEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters timed:(BOOL)timed stopTimer:(BOOL)stopTimer;
- (void) dispatchEvents;
- (BOOL) isConnected;

@property (nonatomic, retain) NSMutableArray *queue;
@property (nonatomic, retain) NSTimer *dispatchTimer;
@property (nonatomic, retain) NSString *apiKey;
@end

@implementation ThinkGaming

static NSString * const kThinkGamingAPIBaseURLString = @"https://api.thinkgaming.com";

static ThinkGaming* sharedSingleton;

@synthesize queue;
@synthesize dispatchTimer;
@synthesize apiKey;

-(void) dealloc
{
    // Kill the timer
    [dispatchTimer invalidate];
    dispatchTimer = nil;
    
    // Purge the queue
    [self dispatchEvents];
}

+ (ThinkGaming*)sharedSingleton {
	@synchronized(self)
	{
		if (!sharedSingleton)
        {
            NSLog(@"Creating singleton");
			sharedSingleton = [[ThinkGaming alloc] initWithBaseURL:[NSURL URLWithString:kThinkGamingAPIBaseURLString]];
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

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setParameterEncoding:AFJSONParameterEncoding];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    // By default, the example ships with SSL pinning enabled for the app.net API pinned against the public key of adn.cer file included with the example. In order to make it easier for developers who are new to AFNetworking, SSL pinning is automatically disabled if the base URL has been changed. This will allow developers to hack around with the example, without getting tripped up by SSL pinning.
    //if ([[url scheme] isEqualToString:@"https"] && [[url host] isEqualToString:@"alpha-api.app.net"]) {
    //    [self setDefaultSSLPinningMode:AFSSLPinningModePublicKey];
    //}
    
    dispatchTimer = [NSTimer scheduledTimerWithTimeInterval:QUEUE_FLUSH_TIME target:self selector:@selector(dispatchEvents) userInfo:nil repeats:YES];
    
    queue = [[NSMutableArray alloc] init];
        
    return self;
}

#pragma mark Private Methods

- (void)logEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters timed:(BOOL)timed stopTimer:(BOOL)stopTimer {
    
    NSNumber *curTimestamp = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:apiKey forKey:@"__TG__apiKey"];
    [dict setValue:curTimestamp forKey:@"__TG__timestamp"];
    [dict setValue:eventName forKey:@"__TG__eventName"];
    [dict setValue:[NSNumber numberWithBool:timed] forKey:@"__TG__timed"];
    [dict setValue:[NSNumber numberWithBool:stopTimer] forKey:@"__TG__stopTimer"];
    
    // Might want to do some size checking for user data or check validity (non-binary items)?
    if (parameters) [dict setValue:parameters forKey:@"__TG__userData"];
    
    
    [sharedSingleton.queue addObject:dict];
}

- (void) dispatchEvents {
    
    NSLog(@"ThinkGaming - dispatching events");
    if (![self isConnected]) return;
    
    if([queue count] == 0) return;
    
    NSMutableURLRequest *request = [sharedSingleton requestWithMethod:@"POST" path:@"/logEvent" parameters:[NSDictionary dictionaryWithObject:queue forKey:@"__TG__payload"]];
    
    NSLog(@"ThinkGaming - sending: %@", [NSDictionary dictionaryWithObject:queue forKey:@"__TG__payload"]);
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Request Successful");
        [queue removeAllObjects];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[ThinkGaming - Error]: (%@ %@) %@", operation.request.HTTPMethod, operation.request.URL.relativePath, error);
    }];

    /*[self enqueueBatchOfHTTPRequestOperations:queue progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
        NSLog(@"event logged");
    } completionBlock:^(NSArray *operations) {
        NSLog(@"all events logged");
    }];*/
    [operation start];
}

- (BOOL) isConnected
{
    Reachability *hostReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [hostReach currentReachabilityStatus];
    return !(netStatus == NotReachable);
}

#pragma mark Public Methods

+ (void)startSession:(NSString *)key {
    //if (![sharedSingleton isConnected]) return;
    
    NSLog(@"ThinkGaming - starting session.");
    [ThinkGaming sharedSingleton]; // Init if not already started
    sharedSingleton.apiKey = key;
    
    
    // Check to see if we have ever run with the lib
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"__TG__firstLaunchDate"]) // Check to see if we have ever launched
    {
        NSLog(@"ThinkGaming - first time run");
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
        [ThinkGaming logEvent:@"__TG__sessionStart"];
    }
    // TODO handshake?
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

+ (void)endTimedEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters {
    [sharedSingleton logEvent:eventName withParameters:parameters timed:YES stopTimer:YES];
}
@end