//
//  ThinkGamingStore.m
//  ThinkGaming
//
//  Created by Aaron Junod on 7/3/13.
//  Copyright (c) 2013 ThinkGaming. All rights reserved.
//

#import "ThinkGamingCurrencyStoreSDK.h"

@implementation ThinkGamingCurrencyStoreSDK

- (NSArray *) getStoreList {
    ThinkGamingStoreSDK *store1 = [[ThinkGamingStoreSDK alloc] init];
    store1.storeIdentifier = @"com.game.bank";
    store1.storeDescription = @"Buy coins and dollars!";
    store1.storeName = @"Bank";
    
    ThinkGamingStoreSDK *store2 = [[ThinkGamingStoreSDK alloc] init];
    store2.storeIdentifier = @"com.game.books";
    store2.storeDescription = @"Buy cookbooks to make new foods!";
    store2.storeName = @"Cookbooks";
    
    return @[store1, store2];
}

- (NSArray *) getStoreItems:(NSString *) storeIdentifier {
    ThinkGamingItem *item1 = [[ThinkGamingItem alloc] init];
    item1.itemName = @"Pile of Coins";
    item1.itemIdentifier = @"com.game.pileofcoins";
    item1.itemDescription = @"A pile of 75 coins!";
    item1.promoCaption = @"20% off";
    item1.currencyIdentifierRequired = @"com.thinkgaming.realCurrency";
    item1.currencyCost = [NSDecimalNumber decimalNumberWithString:@"2.99"];
    item1.itemImageName = @"pile_of_gold";
    
    item1.totalOwned = @126;
    
    ThinkGamingItem *item2 = [[ThinkGamingItem alloc] init];
    item2.itemName = @"Sack of Coins";
    item2.itemIdentifier = @"com.game.sackofcoins";
    item2.itemDescription = @"A sack of 200 coins!";
    item2.promoCaption = @"30% off";
    item2.currencyIdentifierRequired = @"com.thinkgaming.realCurrency";
    item2.itemImageName = @"sack_of_gold";
    item2.currencyCost = [NSDecimalNumber decimalNumberWithString:@"10.99"];
    item2.totalOwned = @5;

    ThinkGamingItem *item3 = [[ThinkGamingItem alloc] init];
    item3.itemName = @"Chest of Coins";
    item3.itemIdentifier = @"com.game.chestofcoins";
    item3.itemDescription = @"A chest of 500 coins!";
    item3.promoCaption = @"30% off";
    item3.currencyIdentifierRequired = @"com.thinkgaming.realCurrency";
    item3.itemImageName = @"chest_of_gold";
    item3.currencyCost = [NSDecimalNumber decimalNumberWithString:@"10.99"];
    item3.totalOwned = @5;

    ThinkGamingItem *item4 = [[ThinkGamingItem alloc] init];
    item4.itemName = @"Chest of Coins";
    item4.itemIdentifier = @"com.game.chestofcoins";
    item4.itemDescription = @"A chest of 500 coins!";
    item4.promoCaption = @"30% off";
    item4.currencyIdentifierRequired = @"com.thinkgaming.realCurrency";
    item4.itemImageName = @"sack_of_gold";
    item4.currencyCost = [NSDecimalNumber decimalNumberWithString:@"10.99"];
    item4.totalOwned = @5;

    ThinkGamingItem *item5 = [[ThinkGamingItem alloc] init];
    item5.itemName = @"Chest of Coins";
    item5.itemIdentifier = @"com.game.chestofcoins";
    item5.itemDescription = @"A chest of 500 coins!";
    item5.promoCaption = @"30% off";
    item5.currencyIdentifierRequired = @"com.thinkgaming.realCurrency";
    item5.itemImageName = @"sack_of_gold";
    item5.currencyCost = [NSDecimalNumber decimalNumberWithString:@"10.99"];
    item5.totalOwned = @5;

//    return @[item1, item2, item3, item4, item5];
    return @[item1, item2, item3];
    
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


@implementation ThinkGamingCurrency
@end

@implementation ThinkGamingItem
@end

@implementation ThinkGamingStoreSDK
@end
