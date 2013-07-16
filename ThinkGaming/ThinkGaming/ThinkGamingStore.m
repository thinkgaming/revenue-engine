//
//  ThinkGamingStore.m
//  ThinkGaming
//
//  Created by Aaron Junod on 7/16/13.
//  Copyright (c) 2013 ThinkGaming. All rights reserved.
//


#import "ThinkGamingStore.h"

static ThinkGamingStore *sharedStore;

@interface ThinkGamingStore()
@property (strong) NSMutableArray *productIdentifiers;
@property (strong) NSMutableArray *purchasedProductIdentifiers;
@property (strong) SKProductsRequest *productRequest;
@property (strong) DidDownloadProductsBlock didDownloadProductsBlock;
@property (strong) DidDownloadStoresBlock didDownloadStoresBlock;
@property (strong) DidPurchaseProductBlock didPurchaseProductBlock;


@end

@implementation ThinkGamingStore

+ (void) getProductList:(NSArray *)arrayOfItunesProductIdentifiers {
    
}

+ (void) getListOfStoresThenCall:(DidDownloadStoresBlock)didDownloadStoresBlock {
    
}

+ (void) getListOfProductsForStoreIdentifier:(NSString *)storeIdentifier thenCall:(DidDownloadProductsBlock)didDownloadProductsBlock; {
    
}

+ (void) purchaseProduct:(SKProduct *)product thenCall:(DidPurchaseProductBlock)didPurchaseProductBlock {
    
}

+ (BOOL) hasPreviouslyPurchasedProductWithIdentifider:(NSString *) iTunesProductIdentifier {
    return NO;
}

+ (void) restorePreviouslyPurchasedProducts {
}

+ (ThinkGamingStore *) shared {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedStore = [[self alloc] init];
    });
    return sharedStore;
}

@end
