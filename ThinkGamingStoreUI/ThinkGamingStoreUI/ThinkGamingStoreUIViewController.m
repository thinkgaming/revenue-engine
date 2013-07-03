//
//  ThinkGamingStoreUIViewController.m
//  ThinkGamingStoreUI
//
//  Created by Aaron Junod on 7/2/13.
//  Copyright (c) 2013 ThinkGaming. All rights reserved.
//

#import "ThinkGamingStoreUIViewController.h"
#import "ThinkGamingStoreUIStyleAppearance.h"

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
@property (weak) IBOutlet UIImageView *backgroundImage;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(rotateStore)
                                                 name:UIApplicationWillChangeStatusBarOrientationNotification
                                               object:nil];
    [self applyStyles];
}


- (void) applyStyles {
    self.backgroundImage.image = [ThinkGamingStoreUIStyleAppearance backgroundImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
