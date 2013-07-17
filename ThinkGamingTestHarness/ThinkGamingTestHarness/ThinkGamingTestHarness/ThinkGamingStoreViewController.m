//
//  ThinkGamingStoreViewController.m
//  ThinkGamingTestHarness
//
//  Created by Aaron Junod on 7/17/13.
//  Copyright (c) 2013 thinkgaming. All rights reserved.
//

#import "ThinkGamingStoreViewController.h"
#import "ThinkGamingStoreSDK.h"

@interface ThinkGamingStoreViewController ()

- (IBAction)didTapRestore:(id)sender;

@end

@implementation ThinkGamingStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)didTapRestore:(id)sender {
    ThinkGamingStoreSDK *thinkGamingStoreSDK = [[ThinkGamingStoreSDK alloc] init];
    [thinkGamingStoreSDK restorePreviouslyPurchasedProducts];
}

@end
