//
//  ThinkGamingStoresViewController.m
//  ThinkGamingTestHarness
//
//  Created by Aaron Junod on 7/17/13.
//  Copyright (c) 2013 thinkgaming. All rights reserved.
//

#import "ThinkGamingStoresViewController.h"
#import "ThinkGamingStoreCell.h"
#import "ThinkGamingStoreSDK.h"

@interface ThinkGamingStoresViewController ()
@property (strong) NSArray *thinkGamingStores;
@property (strong) ThinkGamingStoreSDK *thinkGamingStoreSDK;

@end

@implementation ThinkGamingStoresViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.thinkGamingStores = [NSArray array];
    self.thinkGamingStoreSDK = [[ThinkGamingStoreSDK alloc] init];
    
    [self.thinkGamingStoreSDK getListOfStoresThenCall:^(BOOL success, NSArray *stores) {
        if (success) {
            self.thinkGamingStores = stores;
            [self.tableView reloadData];
        }
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.thinkGamingStores.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ThinkGamingStoreCell";
    ThinkGamingStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    ThinkGamingStore *store = self.thinkGamingStores[indexPath.row];
    cell.storeName.text = store.displayName;
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
