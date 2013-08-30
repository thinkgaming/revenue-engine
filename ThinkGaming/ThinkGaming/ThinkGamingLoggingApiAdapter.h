//
//  ThinkGamingApiAdapter.h
//  ThinkGaming
//
//  Created by Aaron Junod on 6/4/13.
//  Copyright (c) 2013 ThinkGaming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThinkGamingLoggingApiAdapter : NSObject <NSURLConnectionDataDelegate, NSURLConnectionDelegate>

+ (void) dispatchEvents:(NSDictionary *)events
             success:(void(^)(NSData *))success
                  error:(void(^)(NSError*))error;


@end
