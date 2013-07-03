//
//  ThinkGamingStoreItemsCollectionView.m
//  ThinkGamingStoreUI
//
//  Created by Aaron Junod on 7/3/13.
//  Copyright (c) 2013 ThinkGaming. All rights reserved.
//

#import "ThinkGamingStoreItemsCollectionView.h"
#import "ThinkGamingSingleStoreItemCell.h"
#import "ThinkGamingStoreUIStyleAppearance.h"
#import "ThinkGamingStoreSDK.h"


@interface ThinkGamingStoreItemsCollectionView ()

@property (strong) NSArray *storeItems;
@property (strong) ThinkGamingStoreSDK *sdk;

@end

@implementation ThinkGamingStoreItemsCollectionView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sdk = [[ThinkGamingStoreSDK alloc] init];
    self.storeItems = [self.sdk getStoreItems:@"bank"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionView Delegates
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.storeItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ThinkGamingSingleStoreItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ThinkGamingSingleStoreItemCell class]) forIndexPath:indexPath];
    [ThinkGamingStoreUIStyleAppearance applyToStoreItemCell:cell];
    
    ThinkGamingItem *item = self.storeItems[indexPath.row];
    
    cell.itemImageView.image = [UIImage imageNamed:item.itemImageName];
    cell.itemDescription.text = item.itemName;
    cell.itemPrice.text = [item.currencyCost stringValue];
    cell.itemPromoText.text = item.promoCaption;
    
    return cell;
}


@end
