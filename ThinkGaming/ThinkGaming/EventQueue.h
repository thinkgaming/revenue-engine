//
//  EventQueue.h
//  ThinkGaming
//
//  Created by Aaron Junod on 6/4/13.
//  Copyright (c) 2013 ThinkGaming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventQueue : NSObject

- (void) addEvent:(NSDictionary *)event;
- (NSMutableArray *) drainEvents;
- (void) addEvents:(NSArray *)events;

@end
