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
Start session with given API key (get your API key from your dashboard)
*/
+ (ThinkGamingLogger *)startSession:(NSString *)apiKey;

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


@end

/*
 Convenience objects for timed events.
 */
@interface ThinkGamingEvent : NSObject
- (ThinkGamingEvent *)endTimedEvent;
- (ThinkGamingEvent *)endTimedEventWithParameters:(NSDictionary *)parameters;
@end
