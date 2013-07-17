//
//  ThinkGamingStore.h
//  ThinkGaming
//
//  Created by Aaron Junod on 7/16/13.
//  Copyright (c) 2013 ThinkGaming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
@class ThinkGamingStore;

typedef void (^DidDownloadStoresBlock)(BOOL success, NSArray *stores);
typedef void (^DidDownloadProductsBlock)(BOOL success, NSArray *products);
typedef void (^DidPurchaseProductBlock)(BOOL success);


@protocol ThinkGamingStoreDelegate <NSObject>
@optional

-(void) thinkGamingStore:(ThinkGamingStore *)thinkGamingStore didPurchaseProduct:(NSString *)productIdentifier withTransaction:(SKPaymentTransaction *)transaction;
-(void) thinkGamingStore:(ThinkGamingStore *)thinkGamingStore didRestoreProduct:(NSString *)productIdentifier withTransaction:(SKPaymentTransaction *)transaction;
-(void) thinkGamingStore:(ThinkGamingStore *)thinkGamingStore didFailPurchasingProduct:(NSString *)productIdentifier withTransaction:(SKPaymentTransaction *)transaction;

@end

@interface ThinkGamingStore : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (weak) id<ThinkGamingStoreDelegate> delegate;

- (void) getListOfStoresThenCall:(DidDownloadStoresBlock)didDownloadStoresBlock;

- (void) getListOfProductsForStoreIdentifier:(NSString *)storeIdentifier thenCall:(DidDownloadProductsBlock)didDownloadProductsBlock;;

- (void) purchaseProduct:(SKProduct *)product thenCall:(DidPurchaseProductBlock)didPurchaseProductBlock;

- (BOOL) hasPreviouslyPurchasedProductWithIdentifider:(NSString *) iTunesProductIdentifier;

- (void) restorePreviouslyPurchasedProducts;


@end
