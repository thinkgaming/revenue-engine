//
//  ThinkGamingStore.m
//  ThinkGaming
//
//  Created by Aaron Junod on 7/16/13.
//  Copyright (c) 2013 ThinkGaming. All rights reserved.
//


#import "ThinkGamingStoreSDK.h"
#import "ThinkGamingStoreApiAdapter.h"

#define kThinkGamingPersistedPurchasedProducts @"kThinkGamingPersistedPurchasedProducts"

@interface ThinkGamingStoreSDK()
@property (strong) NSMutableArray *productIdentifiers;
@property (strong) NSMutableArray *purchasedProductIdentifiers;
@property (strong) NSMutableArray *thinkGamingProducts;
@property (strong) SKProductsRequest *productRequest;
@property (strong) DidDownloadProductsBlock didDownloadProductsBlock;
@property (strong) DidDownloadStoresBlock didDownloadStoresBlock;
@property (strong) DidPurchaseProductBlock didPurchaseProductBlock;


@end

@implementation ThinkGamingStoreSDK

- (id) init {
    if (self = [super init]) {
        self.purchasedProductIdentifiers = [[NSUserDefaults standardUserDefaults] objectForKey:kThinkGamingPersistedPurchasedProducts];
        if (self.purchasedProductIdentifiers == nil) {
            self.purchasedProductIdentifiers = [NSMutableArray array];
        }
    }
    return self;
}

#pragma mark - Public methods
- (void) getListOfStoresThenCall:(DidDownloadStoresBlock)didDownloadStoresBlock {
    self.didDownloadStoresBlock = didDownloadStoresBlock;
    [ThinkGamingStoreApiAdapter getStoresWithSuccess:^(NSDictionary *results) {
        NSArray *stores = results[@"stores"];
        __block NSMutableArray *thinkGamingStores = [NSMutableArray array];
        [stores enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ThinkGamingStore *store = [[ThinkGamingStore alloc] init];
            store.storeIdentifier = obj[@"store_id"];
            store.displayName = obj[@"display_name"];
            [thinkGamingStores addObject:store];
        }];
        self.didDownloadStoresBlock(YES, thinkGamingStores);
    } error:^(NSError *err) {
        self.didDownloadStoresBlock(NO, nil);
    }];
}

- (void) getListOfProductsForStoreIdentifier:(NSString *)storeIdentifier thenCall:(DidDownloadProductsBlock)didDownloadProductsBlock; {
    self.didDownloadProductsBlock = didDownloadProductsBlock;
    
    [ThinkGamingStoreApiAdapter getProductsForStore:storeIdentifier success:^(NSDictionary *results) {
        NSArray *products = results[@"products"];
        __block NSMutableArray *thinkGamingProducts = [NSMutableArray array];
        __block NSMutableArray *itunesProductIdentifiers = [NSMutableArray array];
        [products enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ThinkGamingProduct *product = [[ThinkGamingProduct alloc] init];
            product.productIdentifier = obj[@"product_id"];
            product.displayName = obj[@"display_name"];
            product.displayDescription = obj[@"display_description"];
            product.price = obj[@"price"];
            product.buyPercentage = obj[@"p_buy"];
            product.iTunesProductIdentifier = obj[@"itunes_id"];
            [thinkGamingProducts addObject:product];
            [itunesProductIdentifiers addObject:product.iTunesProductIdentifier];
        }];
        self.productIdentifiers = itunesProductIdentifiers;
        self.thinkGamingProducts = thinkGamingProducts;
        self.productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:self.productIdentifiers]];
        self.productRequest.delegate = self;
        [self.productRequest start];
    } error:^(NSError *err) {
        self.didDownloadProductsBlock(NO, nil);
    }];
}

- (void) purchaseProduct:(SKProduct *)product thenCall:(DidPurchaseProductBlock)didPurchaseProductBlock {
    self.didPurchaseProductBlock = didPurchaseProductBlock;
    
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (BOOL) hasPreviouslyPurchasedProductWithIdentifider:(NSString *) iTunesProductIdentifier {
    return [self.purchasedProductIdentifiers containsObject:iTunesProductIdentifier];
}

- (void) restorePreviouslyPurchasedProducts {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void) didErrorWhilePurchasingProduct:(NSString *)productIdentifier withTransaction:(SKPaymentTransaction *)transaction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(thinkGamingStore:didFailPurchasingProduct:withTransaction:)]) {
        [self.delegate thinkGamingStore:self didFailPurchasingProduct:productIdentifier withTransaction:transaction];
    }
}

- (void) persistProductIdentifierAsPurchased:(NSString *)productIdentifier {
    if ([self hasPreviouslyPurchasedProductWithIdentifider:productIdentifier]) return;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *storedProducts = [[defaults objectForKey:kThinkGamingPersistedPurchasedProducts] mutableCopy];
    [storedProducts addObject:productIdentifier];
    self.purchasedProductIdentifiers = storedProducts;
    [defaults setObject:storedProducts forKey:kThinkGamingPersistedPurchasedProducts];
    [defaults synchronize];
}

- (void) didCompletePurchaseOfProduct:(NSString *)productIdentifier withTransaction:(SKPaymentTransaction *) transaction{
    [self.purchasedProductIdentifiers addObject:productIdentifier];
    if (self.delegate && [self.delegate respondsToSelector:@selector(thinkGamingStore:didPurchaseProduct:withTransaction:)]) {
        [self.delegate thinkGamingStore:self didPurchaseProduct:productIdentifier withTransaction:transaction];
    }
    
    [self persistProductIdentifierAsPurchased:productIdentifier];
}

#pragma mark - SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    self.productRequest = nil;
    
    [response.products enumerateObjectsUsingBlock:^(SKProduct *product, NSUInteger idx, BOOL *stop) {
        [self.thinkGamingProducts enumerateObjectsUsingBlock:^(ThinkGamingProduct *thinkGamingProduct, NSUInteger idx, BOOL *internalStop) {
            if ([thinkGamingProduct.iTunesProductIdentifier isEqualToString:product.productIdentifier]) {
                thinkGamingProduct.iTunesProduct = product;
                *internalStop = YES;
            }
            
        }];
    }];
    
    self.didDownloadProductsBlock(YES, self.thinkGamingProducts);
    self.didDownloadProductsBlock = nil;
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    self.productRequest = nil;
    
    self.didDownloadProductsBlock(NO, nil);
    self.didDownloadProductsBlock = nil;
}



# pragma mark - SKPaymentTransactionObserver methods

- (void) completeTransaction:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    [self didCompletePurchaseOfProduct:transaction.payment.productIdentifier withTransaction:transaction];
}

- (void) failedTransaction:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    [self didErrorWhilePurchasingProduct:transaction.payment.productIdentifier withTransaction:transaction];
}

- (void) restoreTransaction:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    [self didCompletePurchaseOfProduct:transaction.originalTransaction.payment.productIdentifier withTransaction:transaction];
}


- (void) paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    [transactions enumerateObjectsUsingBlock:^(SKPaymentTransaction *transaction, NSUInteger idx, BOOL *stop) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }];    
}



@end
