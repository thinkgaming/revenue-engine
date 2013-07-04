//
//  ThinkGamingStoreUIStyleAppearance.h
//  ThinkGamingStoreUI
//
//  Created by Aaron Junod on 7/3/13.
//  Copyright (c) 2013 ThinkGaming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThinkGamingStoreUIViewController.h"
#import "ThinkGamingSingleStoreItemCell.h"
#import "ThinkGamingStoreListViewController.h"


@interface ThinkGamingStoreUIStyleAppearance : NSObject

+ (void) apply;
+ (void) applyToStore:(ThinkGamingStoreUIViewController *)store;
+ (void) applyToStoreList:(ThinkGamingStoreListViewController *)storeList;
+ (void) applyToStoreItemCell:(ThinkGamingSingleStoreItemCell *)cell;

#define tgStoreStyleNavigationBarTintColor @"tgStoreStyleNavigationBarTintColor"
#define tgStoreStyleNavigationBarSolidColor @"tgStoreStyleNavigationBarSolidColor"
#define tgStoreStyleNavigationBarFontColor @"tgStoreStyleNavigationBarFontColor"
#define tgStoreStyleNavigationBarCloseImage @"tgStoreStyleNavigationBarCloseImage"
#define tgStoreStyleFontName @"tgStoreStyleFontName"
#define tgStoreStyleBackgroundImage @"tgStoreStyleBackgroundImage"
#define tgStoreStyleCurrencyLabelFontColor @"tgStoreStyleCurrencyLabelFontColor"
#define tgStoreStyleStoreItemDescriptionFontColor @"tgStoreStyleStoreItemDescriptionFontColor"
#define tgStoreStyleStoreItemPriceFontColor @"tgStoreStyleStoreItemPriceFontColor"
#define tgStoreStyleStoreItemPromoFontName @"tgStoreStyleStoreItemPromoFontName"
#define tgStoreStyleStoreItemPromoFontColor @"tgStoreStyleStoreItemPromoFontColor"
#define tgStoreStyleStoreItemBackgroundImage @"tgStoreStyleStoreItemBackgroundImage"
#define tgStoreStyleBackButtonImage @"tgStoreStyleBackButtonImage"
#define tgStoreStyle @""

@end
