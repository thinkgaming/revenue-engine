//
//  ViewController.m
//  ThinkGamingStoreUI
//
//  Created by Aaron Junod on 7/2/13.
//  Copyright (c) 2013 ThinkGaming. All rights reserved.
//

#import "ViewController.h"
#import "ThinkGamingStoreUI.h"

@interface ViewController ()

- (IBAction)didTapShowStore:(id)sender;

@end

@implementation ViewController

- (IBAction)didTapShowStore:(id)sender {
    [ThinkGamingStoreUI showStore];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
