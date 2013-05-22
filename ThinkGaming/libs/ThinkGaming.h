//
//  ThinkGaming.h
//  ThinkGaming
//
//  Copyright (c) 2013 ThinkGaming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "AFHTTPClient.h"

@interface ThinkGaming : AFHTTPClient {
    NSMutableArray *queue;
    NSTimer *dispatchTimer;
    NSString *apiKey;
}

+ (ThinkGaming *)sharedSingleton;

/*
 start session with given API key (get your API key from your dashboard)
 */
+ (void)startSession:(NSString *)apiKey;

/*
 log events after session has started. If passing parameters, simply make a dictionary with the key-value pairs as you wish for them to appear in your event dashboard.
 */
+ (void)logEvent:(NSString *)eventName;
+ (void)logEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters;

/*
 start or end timed events. NOTE: For event start and end times to be paired properly, the eventName must match in the logEvent and endTimedEvent calls.
 */
+ (void)logEvent:(NSString *)eventName timed:(BOOL)timed;
+ (void)logEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters timed:(BOOL)timed;
+ (void)endTimedEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters;

@end
