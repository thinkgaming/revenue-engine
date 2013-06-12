//
//  IAPAdapter.m
//  ThinkGamingTestHarness
//
//  Created by Aaron Junod on 6/11/13.
//  Copyright (c) 2013 thinkgaming. All rights reserved.
//

#import "IAPAdapter.h"

@interface IAPAdapter()

@property (strong) SKProductsRequest *productRequest;
@property (strong) NSArray *productIdentifiers;
@property (strong) NSMutableArray *purchasedProductIdentifiers;
@property (strong) DidDownloadProductsBlock didDownloadProductsBlock;


@end

@implementation IAPAdapter

- (id) initWithProductIds:(NSArray *)productIdentifiers {
    if (self == [super init]) {
        self.productIdentifiers = productIdentifiers;
        self.purchasedProductIdentifiers = [NSMutableArray array];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [self.productIdentifiers enumerateObjectsUsingBlock:^(NSString *productId, NSUInteger idx, BOOL *stop) {
            BOOL purchased = [defaults boolForKey:productId];
            if (purchased) {
                [self.purchasedProductIdentifiers addObject:productId];
            }
        }];
        
    }
    return self;
}

- (void)requestProducts:(DidDownloadProductsBlock)didDownloadProductsBlock {

    self.didDownloadProductsBlock = didDownloadProductsBlock;
    
    self.productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:self.productIdentifiers]];
    self.productRequest.delegate = self;
    [self.productRequest start];
}

#pragma mark - SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    self.productRequest = nil;
    
    NSArray *skProducts = response.products;
    for (SKProduct *skProduct in skProducts) {
        NSLog(@"Found product: %@ %@ %0.2f",
              skProduct.productIdentifier,
              skProduct.localizedTitle,
              skProduct.price.floatValue);
    }
    
    self.didDownloadProductsBlock(YES, skProducts);
    self.didDownloadProductsBlock = nil;
    
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    NSLog(@"Failed to load list of products.");
    self.productRequest = nil;
    
    self.didDownloadProductsBlock(NO, nil);
    self.didDownloadProductsBlock = nil;
    
}

@end
