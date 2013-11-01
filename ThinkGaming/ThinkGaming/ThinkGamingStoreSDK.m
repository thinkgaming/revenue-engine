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
#import "ThinkGamingCache.h"
#import "VerificationController.h"

#define kThinkGamingPersistedPurchasedProducts @"kThinkGamingPersistedPurchasedProducts"


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
@property (strong) NSString *currentStoreIdentifier;
@property (strong) ThinkGamingProduct *currentProduct;

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
    [self.startedEvents addObject:[ThinkGamingLogger startLoggingViewedStore:storeIdentifier]];
}

- (void) startLoggingBuyingProduct:(NSString *)productIdentifier priceId:(NSNumber *)priceId messageId:(NSNumber *)messageId{
    self.currentProductEvent = [ThinkGamingLogger startLoggingBuyingProduct:productIdentifier withPriceId:priceId andMessageId:messageId];
    [self.startedEvents addObject:self.currentProductEvent];
}

 - (void) endLoggingBuyingProduct:(NSString *)productIdentifier withTransactionState:(SKPaymentTransactionState)state {
    if (self.currentProductEvent == nil) return;
     
    switch (state) {
        case SKPaymentTransactionStateFailed:
            [self.currentProductEvent endViewProductWithOutPurchaseWithParameters:@{@"product_id":self.currentProduct.productIdentifier, @"price_id":self.currentProduct.priceId, @"message_id":self.currentProduct.messageId}];
            self.currentProductEvent = nil;
            break;
        case SKPaymentTransactionStatePurchased:
            [self.currentProductEvent endViewProductWithPurchaseWithParameters:@{@"product_id":self.currentProduct.productIdentifier, @"price_id":self.currentProduct.priceId, @"message_id":self.currentProduct.messageId, @"price":self.currentProduct.thinkGamingPrice}];
            self.currentProductEvent = nil;
            break;
        default:
            break;
    }
     
}


#pragma mark - Public methods

- (NSArray *) getListOfPreviouslyPurchasedProductIdentifiers {
    return self.purchasedProductIdentifiers;
}

- (void) getListOfStoresThenCall:(DidDownloadStoresBlock)didDownloadStoresBlock {
    self.didDownloadStoresBlock = didDownloadStoresBlock;
    [ThinkGamingStoreApiAdapter getStoresWithSuccess:^(NSDictionary *results) {
        if (results[@"stores"]) {
            NSArray *stores = results[@"stores"];
            __block NSMutableArray *thinkGamingStores = [NSMutableArray array];
            [stores enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ThinkGamingStore *store = [[ThinkGamingStore alloc] initWithResponse:obj];
                [thinkGamingStores addObject:store];
            }];
            self.didDownloadStoresBlock(YES, thinkGamingStores);
            [ThinkGamingCache persistStoreList:stores];
        } else {
            self.didDownloadStoresBlock(NO, nil);
        }
    } error:^(NSError *err) {
        NSArray *stores = [ThinkGamingCache getStoreList];
        if (stores) {
            __block NSMutableArray *thinkGamingStores = [NSMutableArray array];
            [stores enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ThinkGamingStore *store = [[ThinkGamingStore alloc] initWithResponse:obj];
                [thinkGamingStores addObject:store];
            }];

            self.didDownloadStoresBlock(YES, thinkGamingStores);
            return;
        }
        self.didDownloadStoresBlock(NO, nil);
    }];
}

- (void) getListOfProductsForStoreIdentifier:(NSString *)storeIdentifier thenCall:(DidDownloadProductsBlock)didDownloadProductsBlock; {
    self.didDownloadProductsBlock = didDownloadProductsBlock;
    self.currentStoreIdentifier = storeIdentifier;

    [ThinkGamingStoreApiAdapter getProductsForStore:storeIdentifier success:^(NSDictionary *results) {
        if (results[@"products"]) {
            [self didGetListOfProducts:results[@"products"]];
            [ThinkGamingCache persistStore:self.currentStoreIdentifier withProducts:results[@"products"]];
        } else {
            self.didDownloadProductsBlock(NO, nil);
        }
    } error:^(NSError *err) {
        NSArray *stores = [ThinkGamingCache getProductsForStore:storeIdentifier];
        if (stores) {
            [self didGetListOfProducts:stores];
            return;
        }
        self.didDownloadProductsBlock(NO, nil);
    }];
}

- (void) didGetListOfProducts:(NSArray *) products {
    __block NSMutableArray *thinkGamingProducts = [NSMutableArray array];
    __block NSMutableArray *itunesProductIdentifiers = [NSMutableArray array];
    [products enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ThinkGamingProduct *product = [[ThinkGamingProduct alloc] initWithResponse:obj];
        [thinkGamingProducts addObject:product];
        [itunesProductIdentifiers addObject:product.iTunesProductIdentifier];
    }];
    self.productIdentifiers = itunesProductIdentifiers;
    self.thinkGamingProducts = thinkGamingProducts;
    self.productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:self.productIdentifiers]];
    self.productRequest.delegate = self;
    [self.productRequest start];
    [self startLoggingViewedStore:self.currentStoreIdentifier];
}

- (void) purchaseProduct:(ThinkGamingProduct *)product thenCall:(DidPurchaseProductBlock)didPurchaseProductBlock {
    [self startLoggingBuyingProduct:product.iTunesProductIdentifier priceId:product.priceId messageId:product.messageId];
    self.currentProduct = product;
    
    if (product.iTunesProduct == nil) {
        didPurchaseProductBlock(NO, nil);
        return;
    }
    
    self.didPurchaseProductBlock = didPurchaseProductBlock;
    
    SKPayment *payment = [SKPayment paymentWithProduct:product.iTunesProduct];
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

- (void) didCompleteRestoreOfProduct:(NSString *)productIdentifier withTransaction:(SKPaymentTransaction *) transaction{
    [self persistProductIdentifierAsPurchased:productIdentifier];
    
//    if (self.didPurchaseProductBlock) {
//        self.didPurchaseProductBlock(YES, transaction);
//    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(thinkGamingStore:didRestoreProduct:withTransaction:)]) {
        [self.delegate thinkGamingStore:self didRestoreProduct:productIdentifier withTransaction:transaction];
    }
}


#pragma mark - SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    self.productRequest = nil;
    
    if (response == nil || response.products == nil) {
        self.didDownloadProductsBlock(NO, nil);
        return;
    }
    
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
    [transactions enumerateObjectsUsingBlock:^(SKPaymentTransaction *transaction, NSUInteger idx, BOOL *stop) {
        [self endLoggingBuyingProduct:transaction.payment.productIdentifier withTransactionState:transaction.transactionState];
    }];
}

- (void) completeTransaction:(SKPaymentTransaction *)transaction {
    TG_VerificationController *verifier = [TG_VerificationController sharedInstance];
    [verifier verifyPurchase:transaction completionHandler:^(BOOL success) {
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];

        if (success) {
            [self didCompletePurchaseOfProduct:transaction.payment.productIdentifier withTransaction:transaction];
        } else {
            [self didErrorWhilePurchasingProduct:transaction.payment.productIdentifier withTransaction:transaction];
        }
    }];
}

- (void) failedTransaction:(SKPaymentTransaction *)transaction {
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        [self didErrorWhilePurchasingProduct:transaction.payment.productIdentifier withTransaction:transaction];
}

- (void) restoreTransaction:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    [self didCompleteRestoreOfProduct:transaction.originalTransaction.payment.productIdentifier withTransaction:transaction];
}

- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(thinkGamingStore:didFinishRestoringProducts:)]) {
            [self.delegate thinkGamingStore:self didFinishRestoringProducts:YES];
        }
    }
}

- (void) paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(thinkGamingStore:didFinishRestoringProducts:)]) {
            [self.delegate thinkGamingStore:self didFinishRestoringProducts:NO];
        }
    }
}


- (void) paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    [transactions enumerateObjectsUsingBlock:^(SKPaymentTransaction *transaction, NSUInteger idx, BOOL *stop) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                if (self.currentProduct == nil) return;
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                if (self.currentProduct == nil) return;
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
- (id)initWithResponse:(NSDictionary *)response {
    if (self = [super init]) {
        self.storeIdentifier = response[@"store_id"];
        self.displayName = response[@"display_name"];
    }
    return self;
}	
@end
@implementation ThinkGamingProduct
- (id) initWithResponse:(NSDictionary *)response {
    if (self = [super init]) {
        self.productIdentifier = response[@"product_id"];
        self.displayName = response[@"display_name"];
        self.displayDescription = response[@"display_description"];
        self.iTunesProductIdentifier = response[@"itunes_id"];
        self.thinkGamingPrice = [NSDecimalNumber decimalNumberWithString:response[@"price"]];
        self.offerText = response[@"offer_text"];
        self.priceId = [NSNumber numberWithInt:[response[@"price_id"] integerValue]];
        self.messageId = [NSNumber numberWithInt:[response[@"message_id"] integerValue]];
        self.itunesReference = response[@"itunes_reference"];

    }
    return self;
}

- (NSDecimalNumber *) price {
    return self.iTunesProduct.price;
}

- (NSLocale *) priceLocale {
    return self.iTunesProduct.priceLocale;
}

- (NSString *) formattedPrice {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:self.priceLocale];
    return [numberFormatter stringFromNumber:self.price];
}

@end
