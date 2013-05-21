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
 start session, attempt to send saved sessions to server
 */
+ (void)startSession:(NSString *)apiKey;

/*
 log events after session has started
 */
+ (void)logEvent:(NSString *)eventName;
+ (void)logEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters;

/*
 start or end timed events
 */
+ (void)logEvent:(NSString *)eventName timed:(BOOL)timed;
+ (void)logEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters timed:(BOOL)timed;
+ (void)endTimedEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters;

@end
