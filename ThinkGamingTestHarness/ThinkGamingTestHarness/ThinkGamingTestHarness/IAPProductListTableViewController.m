//
//  IAPProductListTableViewController.m
//  ThinkGamingTestHarness
//
//  Created by Aaron Junod on 6/11/13.
//  Copyright (c) 2013 thinkgaming. All rights reserved.
//

#import "IAPProductListTableViewController.h"
#import "ThinkGamingIAPAdapter.h"
#import "IAPProductCell.h"

@interface IAPProductListTableViewController ()
@property (strong) NSArray *productList;

@end

@implementation IAPProductListTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.productList = [NSArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdatePurchases) name:kDidUpdatePurchasesDatabase object:nil];
}

- (void) didUpdatePurchases {
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.productList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"IAPProductCell";
    IAPProductCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    SKProduct *product = self.productList[indexPath.row];
    cell.descriptionLabel.text = product.localizedDescription;
    cell.titleLabel.text = product.localizedTitle;
    cell.priceLabel.text = [product.price stringValue];
    cell.productIdentifierLabel.text = product.productIdentifier;
    cell.product = product;
    
    if ([[ThinkGamingIAPAdapter shared] productPurchased:product.productIdentifier]) {
        [cell.buyButton setTitle:@"Buy Again" forState:UIControlStateNormal];
    } else {
        [cell.buyButton setTitle:@"Buy" forState:UIControlStateNormal];
    }
    
    return cell;
}

- (void) loadList {
    [[ThinkGamingIAPAdapter shared] requestProducts:^(BOOL success, NSArray *products) {
        if (success) {
            self.productList = products;
            [self.tableView reloadData];
        }
    }];
}

@end
