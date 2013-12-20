//
//  ThinkGamingStoreKitLogger.h
//  ThinkGaming
//
//  Created by Aaron Junod on 12/18/13.
//  Copyright (c) 2013 ThinkGaming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>


@interface ThinkGamingStoreKitLogger : NSObject <SKPaymentTransactionObserver, SKProductsRequestDelegate>

@end
