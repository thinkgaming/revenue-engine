//
//  ThinkGamingStore.h
//  ThinkGaming
//
//  Created by Aaron Junod on 7/3/13.
//  Copyright (c) 2013 ThinkGaming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThinkGamingStoreSDK.h"

#define kDidPurchaseCurrencyNotification @"kdidPurchaseCurrencyNotification"
#define kDidPurchaseItemNotification @"kDidPurchaseItemNotification"

@class ThinkGamingCurrencyStoreSDK;


@interface ThinkGamingCurrency : NSObject

@property (strong) NSString *currencyName;
@property (strong) NSString *currencyIdentifier;
@property (strong) NSNumber *bankTotal;

@end

@interface ThinkGamingItem : NSObject

@property (strong) NSString *itemName;
@property (strong) NSString *itemIdentifier;
@property (strong) NSString *itemDescription;
@property (strong) NSString *promoCaption;
@property (strong) NSString *currencyIdentifierRequired;
@property (strong) NSDecimalNumber *currencyCost;
@property (strong) NSNumber *totalOwned;
@property (strong) NSString *itemImageName;

@end

//@protocol ThinkGamingStoreDelegate <NSObject>
//
//- (void) thinkGamingStore:(ThinkGamingCurrencyStoreSDK *)store didPurchaseCurrency:(ThinkGamingCurrency *)currency;
//- (void) thinkGamingStore:(ThinkGamingCurrencyStoreSDK *)store didPurchaseItem:(ThinkGamingItem *)item;
//
//@end

@interface ThinkGamingCurrencyStoreSDK : NSObject

@property id <ThinkGamingStoreDelegate> delegate;

- (NSArray *) getStoreList;
- (NSArray *) getStoreItems:(NSString *) storeIdentifier;
- (NSArray *) getCurrencyBalances;

- (void) purchaseCurrency:(NSString *)currencyIdentifier
         amountOfCurrency:(NSNumber *)amount
             successBlock:(void (^)(ThinkGamingCurrency *))successBlock
                erroBlock:(void (^)(NSError *))errorBlock;

- (void) purchaseItem:(NSString *)itemIdentifier
         amountOfItem:(NSNumber *)amount
             successBlock:(void (^)(ThinkGamingItem *))successBlock
                erroBlock:(void (^)(NSError *))errorBlock;


@end
