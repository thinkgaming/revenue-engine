//
//  ThinkGamingStoreListViewController.m
//  ThinkGamingStoreUI
//
//  Created by Aaron Junod on 7/3/13.
//  Copyright (c) 2013 ThinkGaming. All rights reserved.
//

#import "ThinkGamingStoreListViewController.h"
#import "ThinkGamingStoreUI.h"
#import "ThinkGamingStoreUIStyleAppearance.h"

@interface ThinkGamingStoreListViewController ()

@end

@implementation ThinkGamingStoreListViewController

- (void) didTapClose:(id)sender {
    [ThinkGamingStoreUI hideStore];
}

- (void) applyStyles {
    [ThinkGamingStoreUIStyleAppearance applyToStoreList:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self applyStyles];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
