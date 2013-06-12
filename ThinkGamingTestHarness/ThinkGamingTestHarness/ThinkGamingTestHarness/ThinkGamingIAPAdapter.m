//
//  ThinkGamingIAPAdapter.m
//  ThinkGamingTestHarness
//
//  Created by Aaron Junod on 6/11/13.
//  Copyright (c) 2013 thinkgaming. All rights reserved.
//

#import "ThinkGamingIAPAdapter.h"

@implementation ThinkGamingIAPAdapter

+(ThinkGamingIAPAdapter *) shared {
    static dispatch_once_t once;
    static ThinkGamingIAPAdapter *sharedAdapter;
    dispatch_once(&once, ^{
        sharedAdapter = [[self alloc] initWithProductIds:@[@"com.thinkgaming.testharness.arrows.10", @"com.thinkgaming.testharness.arrows.10.tier2"]];
    });
    return sharedAdapter;
}

@end
