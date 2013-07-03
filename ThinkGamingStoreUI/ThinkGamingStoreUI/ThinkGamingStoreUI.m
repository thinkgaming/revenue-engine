//
//  ThinkGamingStoreUI.m
//  ThinkGamingStoreUI
//
//  Created by Aaron Junod on 7/2/13.
//  Copyright (c) 2013 ThinkGaming. All rights reserved.
//

#import "ThinkGamingStoreUI.h"
#import "ThinkGamingStoreUIViewController.h"

@implementation ThinkGamingStoreUI

+ (void) showStore {
    UIWindow *rootWindow = [UIApplication sharedApplication].windows[0];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"ThinkGamingStoreUIStoryBoard" bundle:nil];
    ThinkGamingStoreUIViewController *storeUI = [storyBoard instantiateInitialViewController];
    
    [rootWindow addSubview:storeUI.view];
    
}

@end
