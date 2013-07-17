//
//  ViewController.m
//  ThinkGamingTestHarness
//
//  Created by Aaron Junod on 6/3/13.
//  Copyright (c) 2013 thinkgaming. All rights reserved.
//

#import "ViewController.h"
#import "ThinkGamingLogger.h"
#import "Reachability.h"

@interface ViewController ()

@property (weak) IBOutlet UITextField *apiKeyField;
@property (weak) IBOutlet UITextField *eventField;

- (IBAction)didTapInit:(id)sender;
- (IBAction)didTapLog:(id)sender;
- (IBAction)didTapStartTimed:(id)sender;
- (IBAction)didTapEndTimed:(id)sender;
- (IBAction)didTapShowStore:(id)sender;
- (IBAction)didTapForceFlush:(id)sender;

@end

@implementation ViewController

- (IBAction)didTapInit:(id)sender {
    [ThinkGamingLogger startSession:self.apiKeyField.text];
}

- (IBAction)didTapLog:(id)sender {
    [ThinkGamingLogger logEvent:self.eventField.text];
}

- (IBAction)didTapStartTimed:(id)sender {
    [ThinkGamingLogger startTimedEvent:self.eventField.text];
}

- (IBAction)didTapEndTimed:(id)sender {
    [ThinkGamingLogger endTimedEvent:self.eventField.text];
}

- (IBAction)didTapShowStore:(id)sender {
//    [ThinkGamingStoreUI showStore];
}

-(IBAction)didTapForceFlush:(id)sender {
    [ThinkGamingLogger forceFlush];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"connected %i", [self isConnected]);
    self.apiKeyField.text = @"f234rctqc3t4c";
}

- (BOOL) isConnected
{
    Reachability *hostReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [hostReach currentReachabilityStatus];
    return !(netStatus == NotReachable);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
