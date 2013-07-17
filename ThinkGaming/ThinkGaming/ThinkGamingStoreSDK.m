//
//  ThinkGamingStore.m
//  ThinkGaming
//
//  Created by Aaron Junod on 7/16/13.
//  Copyright (c) 2013 ThinkGaming. All rights reserved.
//


#import "ThinkGamingStoreSDK.h"
#import "ThinkGamingStoreApiAdapter.h"
#import "ThinkGamingLogger.h"

#define kThinkGamingPersistedPurchasedProducts @"kThinkGamingPersistedPurchasedProducts"
#define kThinkGamingViewStoreLogId @"viewed_store"
#define kThinkGamingTappedItemLogIf @"tapped_purchase";


@interface ThinkGamingStoreSDK()
@property (strong) NSMutableArray *productIdentifiers;
@property (strong) NSMutableArray *purchasedProductIdentifiers;
@property (strong) NSMutableArray *thinkGamingProducts;
@property (strong) SKProductsRequest *productRequest;
@property (strong) DidDownloadProductsBlock didDownloadProductsBlock;
@property (strong) DidDownloadStoresBlock didDownloadStoresBlock;
@property (strong) DidPurchaseProductBlock didPurchaseProductBlock;
@property (strong) NSMutableArray *startedEvents;
@property (strong) ThinkGamingEvent *currentProductEvent;

@end

@implementation ThinkGamingStoreSDK

- (id) init {
    if (self = [super init]) {
        NSArray *products = [[NSUserDefaults standardUserDefaults] objectForKey:kThinkGamingPersistedPurchasedProducts];
        if (products) {
            self.purchasedProductIdentifiers = [products mutableCopy];
        } else {
            self.purchasedProductIdentifiers = [NSMutableArray array];
        }
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

- (void) dealloc {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    [self.startedEvents enumerateObjectsUsingBlock:^(ThinkGamingEvent *event, NSUInteger idx, BOOL *stop) {
        [event endTimedEvent];
    }];
}

#pragma mark - Logging Methods

- (void) startLoggingViewedStore:(NSString *)storeIdentifier {
    [self.startedEvents addObject:[ThinkGamingLogger startTimedEvent:kThinkGamingViewStoreLogId withParameters:@{@"store_id":storeIdentifier}]];
}

- (void) startLoggingBuyingProduct:(NSString *)productIdentifier {
    self.currentProductEvent = [ThinkGamingLogger startTimedEvent:kThinkGamingViewStoreLogId withParameters:@{@"itunes_id":productIdentifier}];
    [self.startedEvents addObject:self.currentProductEvent];
}

 - (void) endLoggingBuyingProduct:(NSString *)productIdentifier withTransactionState:(SKPaymentTransactionState)state {
    if (self.currentProductEvent == nil) return;
     
    switch (state) {
        case SKPaymentTransactionStateFailed:
            [self.currentProductEvent endTimedEventWithParameters:@{@"result":@"didNotPurchase"}];
            break;
        default:
            [self.currentProductEvent endTimedEventWithParameters:@{@"result":@"didPurchase"}];
            break;
    }
     self.currentProductEvent = nil;
}


#pragma mark - Public methods

- (NSArray *) getListOfPreviouslyPurchasedProductIdentifiers {
    return self.purchasedProductIdentifiers;
}

- (void) getListOfStoresThenCall:(DidDownloadStoresBlock)didDownloadStoresBlock {
    self.didDownloadStoresBlock = didDownloadStoresBlock;
    [ThinkGamingStoreApiAdapter getStoresWithSuccess:^(NSDictionary *results) {
//        NSArray *stores = results[@"stores"];
#warning make this go away;
        NSArray *stores = (NSArray *)results;
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
            product.price = [NSDecimalNumber decimalNumberWithString:obj[@"price"]];
            product.buyPercentage = [NSDecimalNumber decimalNumberWithString:obj[@"p_buy"]];
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
    [self startLoggingBuyingProduct:product.productIdentifier];
    
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
    
    if (self.didPurchaseProductBlock) {
        self.didPurchaseProductBlock(NO, transaction);
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(thinkGamingStore:didFailPurchasingProduct:withTransaction:)]) {
        [self.delegate thinkGamingStore:self didFailPurchasingProduct:productIdentifier withTransaction:transaction];
    }
}

- (void) persistProductIdentifierAsPurchased:(NSString *)productIdentifier {
    if ([self hasPreviouslyPurchasedProductWithIdentifider:productIdentifier]) return;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self.purchasedProductIdentifiers addObject:productIdentifier];
    [defaults setObject:self.purchasedProductIdentifiers forKey:kThinkGamingPersistedPurchasedProducts];
    [defaults synchronize];
}

- (void) didCompletePurchaseOfProduct:(NSString *)productIdentifier withTransaction:(SKPaymentTransaction *) transaction{
    [self persistProductIdentifierAsPurchased:productIdentifier];
    
    if (self.didPurchaseProductBlock) {
        self.didPurchaseProductBlock(YES, transaction);
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(thinkGamingStore:didPurchaseProduct:withTransaction:)]) {
        [self.delegate thinkGamingStore:self didPurchaseProduct:productIdentifier withTransaction:transaction];
    }
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

- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions {
    
}

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

@implementation ThinkGamingStore
@end
@implementation ThinkGamingProduct
@end
