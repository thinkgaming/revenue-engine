//
//  ThinkGamingStoreUIViewController.m
//  ThinkGamingStoreUI
//
//  Created by Aaron Junod on 7/2/13.
//  Copyright (c) 2013 ThinkGaming. All rights reserved.
//

#import "ThinkGamingStoreUIViewController.h"
#import "ThinkGamingStoreUIStyleAppearance.h"
#import "ThinkGamingStoreUI.h"
#import "ThinkGamingCurrencyStoreSDK.h"

#define DegreesToRadians(degrees) (degrees *M_PI /180)

static CGRect screenRect() {
    
    CGSize screenSize = [UIScreen mainScreen].applicationFrame.size;
    
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        return CGRectMake(0.0f, 0.0f, screenSize.height, screenSize.width);
    }
    
    return CGRectMake(0.0f, 0.0f, screenSize.width, screenSize.height);
}

@interface ThinkGamingStoreUIViewController ()

@property (weak) IBOutlet UIView *storeView;
@property (strong) ThinkGamingCurrencyStoreSDK *sdk;

- (IBAction)didTapClose:(id)sender;

@end

@implementation ThinkGamingStoreUIViewController

#pragma mark - Orientation handlers

- (void) rotateStore {
    
    CGAffineTransform rotate;
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    switch (orientation)
    {
        case UIInterfaceOrientationPortraitUpsideDown:
            rotate = CGAffineTransformMakeRotation(-DegreesToRadians(180));
            break;
        case UIInterfaceOrientationLandscapeLeft:
            rotate = CGAffineTransformMakeRotation(DegreesToRadians(-90));
            break;
        case UIInterfaceOrientationLandscapeRight:
            rotate = CGAffineTransformMakeRotation(DegreesToRadians(90));
            break;
        default:
            rotate = CGAffineTransformMakeRotation(-DegreesToRadians(0));
            break;                             
    }
    self.view.frame = screenRect();
    [self.view setTransform:rotate];
}

- (void) didTapClose:(id)sender {
    [ThinkGamingStoreUI hideStore];
}

- (void) didTapBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(rotateStore)
                                                 name:UIApplicationWillChangeStatusBarOrientationNotification
                                               object:nil];
    [self applyStyles];
    
    self.sdk = [[ThinkGamingCurrencyStoreSDK alloc] init];
    NSArray *balances = [self.sdk getCurrencyBalances];
    
    [balances enumerateObjectsUsingBlock:^(ThinkGamingCurrency *currency, NSUInteger idx, BOOL *stop) {
        if ([currency.currencyIdentifier rangeOfString:@"coins"].location == NSNotFound) {
            self.dollarsLabel.text = [NSString stringWithFormat:@"$ %@", currency.bankTotal];
        } else {
            self.coinsLabel.text = [NSString stringWithFormat:@"$ %@", currency.bankTotal];
        }
    }];
    
}


- (void) applyStyles {
    [ThinkGamingStoreUIStyleAppearance applyToStore:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
