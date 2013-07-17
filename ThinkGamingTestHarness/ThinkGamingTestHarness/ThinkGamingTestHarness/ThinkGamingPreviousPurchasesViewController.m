//
//  ThinkGamingPreviousPurchasesViewController.m
//  ThinkGamingTestHarness
//
//  Created by Aaron Junod on 7/17/13.
//  Copyright (c) 2013 thinkgaming. All rights reserved.
//

#import "ThinkGamingPreviousPurchasesViewController.h"
#import "ThinkGamingStoreSDK.h"

@interface ThinkGamingPreviousPurchasesViewController ()

@property NSArray *previouslyPurchasedProducts;

@end

@implementation ThinkGamingPreviousPurchasesViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    ThinkGamingStoreSDK *storeSDK = [[ThinkGamingStoreSDK alloc] init];
    self.previouslyPurchasedProducts = [storeSDK getListOfPreviouslyPurchasedProductIdentifiers];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.previouslyPurchasedProducts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = self.previouslyPurchasedProducts[indexPath.row];
    
    return cell;
}


@end
