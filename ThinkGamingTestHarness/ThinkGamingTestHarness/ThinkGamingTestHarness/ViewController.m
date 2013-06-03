//
//  ViewController.m
//  ThinkGamingTestHarness
//
//  Created by Aaron Junod on 6/3/13.
//  Copyright (c) 2013 thinkgaming. All rights reserved.
//

#import "ViewController.h"
#import "ThinkGaming.h"

@interface ViewController ()

@property (weak) IBOutlet UITextField *apiKeyField;
@property (weak) IBOutlet UITextField *eventField;

- (IBAction)didTapInit:(id)sender;
- (IBAction)didTapLog:(id)sender;
- (IBAction)didTapStartTimed:(id)sender;
- (IBAction)didTapEndTimed:(id)sender;

@end

@implementation ViewController

- (IBAction)didTapInit:(id)sender {
    [ThinkGaming startSession:self.apiKeyField.text];
}

- (IBAction)didTapLog:(id)sender {
    [ThinkGaming logEvent:self.eventField.text];
}

- (IBAction)didTapStartTimed:(id)sender {
    [ThinkGaming logEvent:self.eventField.text timed:YES];
}

- (IBAction)didTapEndTimed:(id)sender {
    [ThinkGaming endTimedEvent:self.eventField.text withParameters:nil];
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
