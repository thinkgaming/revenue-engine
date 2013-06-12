//
//  IAPProductListTableViewController.m
//  ThinkGamingTestHarness
//
//  Created by Aaron Junod on 6/11/13.
//  Copyright (c) 2013 thinkgaming. All rights reserved.
//

#import "IAPProductListTableViewController.h"
#import "ThinkGamingIAPAdapter.h"

@interface IAPProductListTableViewController ()
@property (strong) NSArray *productList;

@end

@implementation IAPProductListTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.productList = [NSArray array];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.productList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
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
