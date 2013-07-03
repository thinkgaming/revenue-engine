//
//  ThinkGamingStore.h
//  ThinkGaming
//
//  Created by Aaron Junod on 7/3/13.
//  Copyright (c) 2013 ThinkGaming. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ThinkGamingStoreSDK;

@interface ThinkGamingStore : NSObject
@property (strong) NSString *storeName;
@property (strong) NSString *storeIdentifier;
@property (strong) NSString *storeDescription;
@end

@interface ThinkGamingCurrency : NSObject

@property (strong) NSString *currencyName;
@property (strong) NSString *currencyIdentifier;
@property (strong) NSNumber *currencyAmount;
@property (strong) NSNumber *bankTotal;

@end

@interface ThinkGamingItem : NSObject

@property (strong) NSString *itemName;
@property (strong) NSString *itemIdentifier;
@property (strong) NSNumber *currentAmount;
@property (strong) NSNumber *totalAmount;

@end

@protocol ThinkGamingStoreDelegate <NSObject>

- (void) thinkGamingStore:(ThinkGamingStoreSDK *)store didPurchaseCurrency:(ThinkGamingCurrency *)currency;
- (void) thinkGamingStore:(ThinkGamingStoreSDK *)store didPurchaseItem:(ThinkGamingItem *)item;

@end

@interface ThinkGamingStoreSDK : NSObject

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
