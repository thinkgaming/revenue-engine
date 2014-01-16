//
//  ThinkGamingStoreKitLogger.m
//  ThinkGaming
//
//  Created by Aaron Junod on 12/18/13.
//  Copyright (c) 2013 ThinkGaming. All rights reserved.
//

#import "ThinkGamingStoreKitLogger.h"
#import "ThinkGamingLogger.h"

@implementation ThinkGamingStoreKitLogger

- (id) init {
    if (self = [super init]) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}


- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
        [transactions enumerateObjectsUsingBlock:^(SKPaymentTransaction *transaction, NSUInteger idx, BOOL *stop) {
            switch (transaction.transactionState) {
                case SKPaymentTransactionStatePurchased:
                    [self didPurchaseProductWithTransaction:transaction];
                    break;
                default:
                    break;
            }
        }];    

}

- (void) didPurchaseProductWithTransaction:(SKPaymentTransaction *)transaction {
    NSSet *set = [NSSet setWithObject:transaction.payment.productIdentifier];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    [request setDelegate:self];
    [request start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    [response.products enumerateObjectsUsingBlock:^(SKProduct *product, NSUInteger idx, BOOL *stop) {
        [ThinkGamingLogger logProductPurchased:product.productIdentifier withPrice:product.price andPriceLocale:[product.priceLocale localeIdentifier] andTitle:product.localizedTitle];
    }];
}

- (void) dealloc {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}


@end
