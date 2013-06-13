//
//  IAPProductListViewController.m
//  ThinkGamingTestHarness
//
//  Created by Aaron Junod on 6/11/13.
//  Copyright (c) 2013 thinkgaming. All rights reserved.
//

#import "IAPProductListViewController.h"
#import "IAPProductListTableViewController.h"
#import "ThinkGamingIAPAdapter.h"

@interface IAPProductListViewController ()
@property (weak) IAPProductListTableViewController *productListTableView;
@property (weak) IBOutlet UIButton *loadListButton;

-(IBAction)didTapLoadList:(id)sender;
-(IBAction)didTapRefreshPurchases:(id)sender;

@end

@implementation IAPProductListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"embed"]) {
        self.productListTableView = segue.destinationViewController;
    }
}

- (IBAction)didTapLoadList:(id)sender {
    [self.productListTableView loadList];
}

-(IBAction)didTapRefreshPurchases:(id)sender {
    [[ThinkGamingIAPAdapter shared] restoreCompletedTransactions];
}


@end
