//
//  ThinkGamingStore.h
//  ThinkGaming
//
//  Created by Aaron Junod on 7/16/13.
//  Copyright (c) 2013 ThinkGaming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
@class ThinkGamingStoreSDK;

typedef void (^DidDownloadStoresBlock)(BOOL success, NSArray *stores);
typedef void (^DidDownloadProductsBlock)(BOOL success, NSArray *products);
typedef void (^DidPurchaseProductBlock)(BOOL success, SKPaymentTransaction *transaction);

@interface ThinkGamingStore : NSObject

@property (strong) NSString *displayName;
@property (strong) NSString *storeIdentifier;

@end

@interface ThinkGamingProduct : NSObject

@property (strong) NSString *productIdentifier;
@property (strong) NSString *displayName;
@property (strong) NSString *displayDescription;
@property (strong) NSDecimalNumber *price;
@property (strong) NSString *offerText;
@property (strong) NSDecimalNumber *buyPercentage;
@property (strong) NSString *iTunesProductIdentifier;
@property (strong) SKProduct *iTunesProduct;

@end


@protocol ThinkGamingStoreDelegate <NSObject>
@optional

-(void) thinkGamingStore:(ThinkGamingStoreSDK *)thinkGamingStore didPurchaseProduct:(NSString *)productIdentifier withTransaction:(SKPaymentTransaction *)transaction;
-(void) thinkGamingStore:(ThinkGamingStoreSDK *)thinkGamingStore didRestoreProduct:(NSString *)productIdentifier withTransaction:(SKPaymentTransaction *)transaction;
-(void) thinkGamingStore:(ThinkGamingStoreSDK *)thinkGamingStore didFailPurchasingProduct:(NSString *)productIdentifier withTransaction:(SKPaymentTransaction *)transaction;

@end

@interface ThinkGamingStoreSDK : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (weak) id<ThinkGamingStoreDelegate> delegate;

- (void) getListOfStoresThenCall:(DidDownloadStoresBlock)didDownloadStoresBlock;

- (void) getListOfProductsForStoreIdentifier:(NSString *)storeIdentifier thenCall:(DidDownloadProductsBlock)didDownloadProductsBlock;;

- (void) purchaseProduct:(SKProduct *)product thenCall:(DidPurchaseProductBlock)didPurchaseProductBlock;

- (BOOL) hasPreviouslyPurchasedProductWithIdentifider:(NSString *) iTunesProductIdentifier;

- (void) restorePreviouslyPurchasedProducts;

- (NSArray *) getListOfPreviouslyPurchasedProductIdentifiers;


@end
