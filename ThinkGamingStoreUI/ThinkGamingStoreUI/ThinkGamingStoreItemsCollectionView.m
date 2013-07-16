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
#import "ThinkGamingCurrencyStoreSDK.h"
#import "ThinkGamingStoreUI.h"


@interface ThinkGamingStoreItemsCollectionView ()

@property (strong) NSArray *storeItems;
@property (strong) ThinkGamingCurrencyStoreSDK *sdk;

@end

@implementation ThinkGamingStoreItemsCollectionView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sdk = [[ThinkGamingCurrencyStoreSDK alloc] init];
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ThinkGamingItem *item = self.storeItems[indexPath.row];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:item.itemName message:item.itemDescription delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"buy", nil];
    alert.tag = indexPath.row;
    [alert show];
}

#pragma mark - UIAlertView delegates
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag > 0) {
        ThinkGamingItem *item = self.storeItems[alertView.tag];
        if (buttonIndex == 1) {
            ThinkGamingCurrencyStoreSDK *sdk = [[ThinkGamingCurrencyStoreSDK alloc] init];
            [sdk purchaseCurrency:item.itemIdentifier amountOfCurrency:@1
                     successBlock:^(ThinkGamingCurrency *currency)  {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thanks!" message:@"purchase complete" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
                         alert.tag = -1;
                [alert show];
            } erroBlock:^(NSError *err) {
                nil;
            }];
        }
    }
    
    if (alertView.tag < 0) {
        [ThinkGamingStoreUI hideStore];
    }
}




@end
