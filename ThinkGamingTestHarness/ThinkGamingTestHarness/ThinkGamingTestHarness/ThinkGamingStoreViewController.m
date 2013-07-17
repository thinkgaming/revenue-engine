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

@property (strong) ThinkGamingStoreSDK *storeSDK;
- (IBAction)didTapRestore:(id)sender;

@end

@implementation ThinkGamingStoreViewController

- (void)viewDidLoad {
    self.storeSDK = [[ThinkGamingStoreSDK alloc] init];
    [super viewDidLoad];
}

- (IBAction)didTapRestore:(id)sender {
    [self.storeSDK restorePreviouslyPurchasedProducts];
}

@end
