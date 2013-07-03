//
//  ThinkGamingStoreUIStyleAppearance.m
//  ThinkGamingStoreUI
//
//  Created by Aaron Junod on 7/3/13.
//  Copyright (c) 2013 ThinkGaming. All rights reserved.
//

#import "ThinkGamingStoreUIStyleAppearance.h"
#import "ThinkGamingStoreUINavigationController.h"

@implementation ThinkGamingStoreUIStyleAppearance

+ (void) apply {
    [[UINavigationBar appearanceWhenContainedIn:[ThinkGamingStoreUINavigationController class], nil] setTintColor:[UIColor blackColor]];
}

@end
