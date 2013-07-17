//
//  ThinkGamingProductsViewController.m
//  ThinkGamingTestHarness
//
//  Created by Aaron Junod on 7/17/13.
//  Copyright (c) 2013 thinkgaming. All rights reserved.
//

#import "ThinkGamingProductsViewController.h"

@interface ThinkGamingProductsViewController ()
@property NSArray *thinkGamingProducts;

@end

@implementation ThinkGamingProductsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.thinkGamingProducts = [NSArray array];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.thinkGamingProducts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

@end
