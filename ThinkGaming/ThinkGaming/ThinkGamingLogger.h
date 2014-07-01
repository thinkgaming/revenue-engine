//
//  ThinkGaming.h
//  ThinkGaming
//
//  Copyright (c) 2013 ThinkGaming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class ThinkGamingEvent;


@interface ThinkGamingLogger : NSObject

/*
Return the current ApiKey
*/
+ (NSString *) currentApiKey;
+ (NSString *) deviceId;
;

/*
Force flushing the current logging data to the server
*/
+ (void) forceFlush;

/*
Start session with given API key (get your API key from your dashboard)
*/
+ (ThinkGamingLogger *)startSession:(NSString *)apiKey;
+ (ThinkGamingLogger *)startSession:(NSString *)apiKey andMediaSourceId:(NSString *)mediaSourceId;
+ (ThinkGamingLogger *)startSession:(NSString *)apiKey andMediaSourceId:(NSString *)mediaSourceId andIdentifierForAdvertising:(NSString *)idfa;

/*
 log events after session has started. If passing parameters, simply make a dictionary with the key-value pairs as you wish for them to appear in your event dashboard.
 */
+ (void)logEvent:(NSString *)eventName;
+ (void)logEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters;

/*
 start or end timed events. NOTE: For event start and end times to be paired properly, the eventName must match in the logEvent and endTimedEvent calls.
*/

/*
 Log timed events. End a timed event by calling endTimedEvent on the logger, or the returned Event object
 */
+ (ThinkGamingEvent *)startTimedEvent:(NSString *)eventName;
+ (ThinkGamingEvent *)startTimedEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters;
+ (ThinkGamingEvent *)endTimedEvent:(NSString *)eventName;
+ (ThinkGamingEvent *)endTimedEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters;

/*
Store and product logging methods
*/
+ (ThinkGamingEvent *) startLoggingViewedStore:(NSString *)storeIdentifier __deprecated_msg("Store SDK no longer supported.");
+ (ThinkGamingEvent *) startLoggingBuyingProduct:(NSString *)productIdentifier withPriceId:(NSNumber *)priceId andMessageId:(NSNumber *)messageId __deprecated_msg("Store SDK no longer supported.");
+ (ThinkGamingEvent *) endLoggingBuyingProduct:(NSString *)productIdentifier
                                   withPriceId:(NSNumber *)priceId
                                  andMessageId:(NSNumber *)messageId
                                     andResult:(NSString*) result __deprecated_msg("Store SDK no longer supported.");

/* 
 ThinkGamingStoreKitLogger
*/

+ (void) logProductPurchased:(NSString *)productIdentifier withPrice:(NSDecimalNumber *)price andPriceLocale:(NSString *) priceLocale andTitle:(NSString *)title;



/* DEFAULT IS ENABLED */
+ (void) setImplicitStoreLoggingEnabled __deprecated_msg("Store SDK no longer supported.");
+ (void) setImplicitStoreLoggingDisabled __deprecated_msg("Store SDK no longer supported.");



@end

/*
 Convenience objects for timed events.
 */
@interface ThinkGamingEvent : NSObject
@property (strong) NSString *eventName;
- (id) initWithEventName:(NSString *)eventName;


- (ThinkGamingEvent *)endTimedEvent;
- (ThinkGamingEvent *)endTimedEventWithParameters:(NSDictionary *)parameters;
- (ThinkGamingEvent *)endViewProductWithPurchaseWithParameters:(NSDictionary *) parameters;
- (ThinkGamingEvent *)endViewProductWithOutPurchaseWithParameters:(NSDictionary *) parameters;
@end
