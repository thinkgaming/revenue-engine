//
//  ThinkGamingStoreUIViewController.m
//  ThinkGamingStoreUI
//
//  Created by Aaron Junod on 7/2/13.
//  Copyright (c) 2013 ThinkGaming. All rights reserved.
//

#import "ThinkGamingStoreUIViewController.h"

static CGRect screenRect() {
    
    CGSize screenSize = [UIScreen mainScreen].applicationFrame.size;
    
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        return CGRectMake(0.0f, 0.0f, screenSize.height, screenSize.width);
    }
    
    return CGRectMake(0.0f, 0.0f, screenSize.width, screenSize.height);
}

@interface ThinkGamingStoreUIViewController ()

@property (weak) IBOutlet UIView *storeView;

@end

@implementation ThinkGamingStoreUIViewController

#pragma mark - Orientation handlers

- (void) rotateStore {
    CGAffineTransform rotate = CGAffineTransformMakeRotation(M_PI/2.0);
    [self.view setTransform:rotate];
    [self.view setCenter:[UIApplication sharedApplication].keyWindow.rootViewController.view.center];
    self.storeView.center = [UIApplication sharedApplication].keyWindow.rootViewController.view.center;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
