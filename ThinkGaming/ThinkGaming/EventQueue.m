//
//  EventQueue.m
//  ThinkGaming
//
//  Created by Aaron Junod on 6/4/13.
//  Copyright (c) 2013 ThinkGaming. All rights reserved.
//

#import "EventQueue.h"

#define MAX_QUEUE_ITEM_COUNT 500
#define PURGE_SIZE_COUNT 25


@interface EventQueue()

@property NSMutableArray *events;

@end

@implementation EventQueue

- (id) init {
    if (self = [super init]) {
        self.events = [NSMutableArray array];
    }
    return self;
}

- (void) addEvent:(NSDictionary *)event {
    [self.events addObject:event];
    
    [self purgeIfRequired];
}

- (void) addEvents:(NSArray *)events {
    [self.events addObjectsFromArray:events];
    
    [self purgeIfRequired];
}

- (void) purgeIfRequired {
    if ([self queueSizeExceedsThreshold]) {
        [self purgeSomeOldItems];
    }
}

- (void) purgeSomeOldItems {
    [self.events removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, PURGE_SIZE_COUNT)]];
}

- (BOOL) queueSizeExceedsThreshold {
    bool exceeds = self.events.count >= MAX_QUEUE_ITEM_COUNT;
    return exceeds;
}


- (NSMutableArray *) drainEvents {
    NSMutableArray *copyOfEvents = [self.events copy];
    self.events = nil;
    self.events = [NSMutableArray array];
    return copyOfEvents;
}


@end
