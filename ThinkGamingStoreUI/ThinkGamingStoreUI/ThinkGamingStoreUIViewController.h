//
//  ThinkGamingStoreUIViewController.h
//  ThinkGamingStoreUI
//
//  Created by Aaron Junod on 7/2/13.
//  Copyright (c) 2013 ThinkGaming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThinkGamingStoreUIViewController : UIViewController
@property (weak) IBOutlet UIImageView *backgroundImage;

@property (weak) IBOutlet UIBarButtonItem *closeButton;
@property (weak) IBOutlet UILabel *coinsLabel;
@property (weak) IBOutlet UILabel *dollarsLabel;


- (void) rotateStore;


@end
