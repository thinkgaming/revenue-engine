//
//  ThinkGamingProductsViewController.m
//  ThinkGamingTestHarness
//
//  Created by Aaron Junod on 7/17/13.
//  Copyright (c) 2013 thinkgaming. All rights reserved.
//

#import "ThinkGamingProductsViewController.h"
#import "ThinkGamingProductCell.h"

@interface ThinkGamingProductsViewController ()
@property (strong) NSArray *thinkGamingProducts;
@property (strong) ThinkGamingStoreSDK *thinkGamingStoreSDK;

@end

@implementation ThinkGamingProductsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.thinkGamingStoreSDK = [[ThinkGamingStoreSDK alloc] init];
    self.thinkGamingProducts = [NSArray array];
    
    [self.thinkGamingStoreSDK getListOfProductsForStoreIdentifier:self.thinkGamingStore.storeIdentifier thenCall:^(BOOL success, NSArray *products) {
        self.thinkGamingProducts = products;
        [self.tableView reloadData];
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.thinkGamingProducts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ThinkGamingProductCell";
    ThinkGamingProductCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    ThinkGamingProduct *product = self.thinkGamingProducts[indexPath.row];
    cell.displayDescription.text = product.displayDescription;
    cell.displayName.text = product.displayName;
    cell.iTunesId.text = product.iTunesProductIdentifier;
    cell.offerText.text = product.offerText;
    cell.productId.text = product.productIdentifier;
    cell.price.text = [product.price stringValue];
    cell.percentage.text = [product.buyPercentage stringValue];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ThinkGamingProduct *product = self.thinkGamingProducts[indexPath.row];
    [self.thinkGamingStoreSDK purchaseProduct:product.iTunesProduct thenCall:^(BOOL success, SKPaymentTransaction *transaction) {
        // YAY DONE!
    }];
}

@end
