//
//  ThinkGamingStoreUI.m
//  ThinkGamingStoreUI
//
//  Created by Aaron Junod on 7/2/13.
//  Copyright (c) 2013 ThinkGaming. All rights reserved.
//

#import "ThinkGamingStoreUI.h"
#import "ThinkGamingStoreUIViewController.h"
#import "ThinkGamingStoreUIStyleAppearance.h"

static ThinkGamingStoreUI *thinkGamingStoreUI;

@interface ThinkGamingStoreUI()

@property (strong) UIViewController *storeController;

+ (ThinkGamingStoreUI *) shared;

- (void) showStore;
- (void) hideStore;

@end

@implementation ThinkGamingStoreUI

+ (ThinkGamingStoreUI *) shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        thinkGamingStoreUI = [[ThinkGamingStoreUI alloc] init];
        [ThinkGamingStoreUIStyleAppearance apply];
    });
    return thinkGamingStoreUI;
}

+ (void) showStore {
    [[ThinkGamingStoreUI shared] showStore];
}

- (void) showStore {
    UIWindow *rootWindow = [UIApplication sharedApplication].windows[0];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"ThinkGamingStoreUIStoryBoard" bundle:nil];
    self.storeController = [storyBoard instantiateInitialViewController];
    UIViewController *rootViewController = rootWindow.rootViewController;
    rootViewController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [rootViewController presentViewController:self.storeController animated:YES completion:nil];
}

+ (void) hideStore {
    [[ThinkGamingStoreUI shared] hideStore];
}

- (void) hideStore {
    if (self.storeController) {
        [self.storeController dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
