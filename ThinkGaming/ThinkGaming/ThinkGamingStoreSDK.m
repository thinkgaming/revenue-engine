//
//  ThinkGamingStore.m
//  ThinkGaming
//
//  Created by Aaron Junod on 7/3/13.
//  Copyright (c) 2013 ThinkGaming. All rights reserved.
//

#import "ThinkGamingStoreSDK.h"

@implementation ThinkGamingStoreSDK

- (NSArray *) getStoreList {
    ThinkGamingStore *store1 = [[ThinkGamingStore alloc] init];
    store1.storeIdentifier = @"com.game.bank";
    store1.storeDescription = @"Buy coins and dollars!";
    store1.storeName = @"Bank";
    
    ThinkGamingStore *store2 = [[ThinkGamingStore alloc] init];
    store2.storeIdentifier = @"com.game.books";
    store2.storeDescription = @"Buy cookbooks to make new foods!";
    store2.storeName = @"Cookbooks";
    
    return @[store1, store2];
}

- (NSArray *) getStoreItems:(NSString *) storeIdentifier {
    ThinkGamingItem *item1 = [[ThinkGamingItem alloc] init];
    item1.itemName = @"Coin Pile";
    item1.itemIdentifier = @"com.game.pileofcoins";
    item1.itemDescription = @"A pile of 75 coins!";
    item1.promoCaption = @"20% off for the holiday!";
    item1.currencyIdentifierRequired = @"com.thinkgaming.realCurrency";
    item1.currencyCost = [NSDecimalNumber decimalNumberWithString:@"2.99"];
    item1.totalOwned = @126;
    
    ThinkGamingItem *item2 = [[ThinkGamingItem alloc] init];
    item2.itemName = @"Coin Sack";
    item2.itemIdentifier = @"com.game.sackofcoins";
    item2.itemDescription = @"A sack of 200 coins!";
    item2.promoCaption = @"30% off if you buy bulk!";
    item2.currencyIdentifierRequired = @"com.thinkgaming.realCurrency";
    item2.currencyCost = [NSDecimalNumber decimalNumberWithString:@"10.99"];
    item2.totalOwned = @5;
    
    return @[item1, item2];
    
}

- (NSArray *) getCurrencyBalances {
    ThinkGamingCurrency *currency1 = [[ThinkGamingCurrency alloc] init];
    currency1.currencyName = @"Coins";
    currency1.currencyIdentifier = @"com.game.coins";
    currency1.bankTotal = @100;
    
    ThinkGamingCurrency *currency2 = [[ThinkGamingCurrency alloc] init];
    currency2.currencyName = @"Dollars";
    currency2.currencyIdentifier = @"com.game.dollars";
    currency2.bankTotal = @75;
    
    return @[currency1, currency2];
}

- (void) purchaseCurrency:(NSString *)currencyIdentifier
         amountOfCurrency:(NSNumber *)amount
             successBlock:(void (^)(ThinkGamingCurrency *))successBlock
                erroBlock:(void (^)(NSError *))errorBlock {
    
    ThinkGamingCurrency *purchased = [[ThinkGamingCurrency alloc] init];
    purchased.currencyIdentifier = currencyIdentifier;
    purchased.bankTotal = amount;
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        successBlock(purchased);
        if (self.delegate) {
            [self.delegate thinkGamingStore:self didPurchaseCurrency:purchased];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidPurchaseCurrencyNotification object:purchased];
    });

}

- (void) purchaseItem:(NSString *)itemIdentifier
         amountOfItem:(NSNumber *)amount
         successBlock:(void (^)(ThinkGamingItem *))successBlock
            erroBlock:(void (^)(NSError *))errorBlock {
    
    ThinkGamingItem *item = [[ThinkGamingItem alloc] init];
    item.itemIdentifier = itemIdentifier;
    item.totalOwned = amount;
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        successBlock(item);
        if (self.delegate) {
            [self.delegate thinkGamingStore:self didPurchaseItem:item];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidPurchaseItemNotification object:item];
    });
    
}


@end
