//
//  ThinkGamingCache.m
//  ThinkGaming
//
//  Created by Aaron Junod on 7/31/13.
//  Copyright (c) 2013 ThinkGaming. All rights reserved.
//

#import "ThinkGamingCache.h"

#define kThinkGamingStoreListPersistanceKey @"kThinkGamingStoreListPersistanceKey"
#define kThinkGamingProductListPersistanceKey @"kThinkGamingProductListPersistanceKey"

@implementation ThinkGamingCache


+ (void) persistStoreList:(NSArray *)storeListPayload {
    if (storeListPayload) {
        [[NSUserDefaults standardUserDefaults] setObject:storeListPayload forKey:kThinkGamingStoreListPersistanceKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NSArray *) getStoreList {
    NSDictionary *stores = [[NSUserDefaults standardUserDefaults] objectForKey:kThinkGamingStoreListPersistanceKey];
    if (stores) {
        return [stores mutableCopy];
    }
    return [NSArray array];
}

+ (void) persistStore:(NSString *)storeIdentifier withProducts:(NSArray *)products {
    if (storeIdentifier && products) {
        NSDictionary *persistedStores = [[NSUserDefaults standardUserDefaults] objectForKey:kThinkGamingProductListPersistanceKey];
        NSMutableDictionary *currentStores = nil;
        if (persistedStores) {
            currentStores = [persistedStores mutableCopy];
        } else {
            currentStores = [NSMutableDictionary dictionary];
        }
        currentStores[storeIdentifier] = products;

        [[NSUserDefaults standardUserDefaults] setObject:currentStores forKey:kThinkGamingProductListPersistanceKey];
        [[NSUserDefaults standardUserDefaults] synchronize];        
    }
}

+ (NSArray *) getProductsForStore:(NSString *)storeIdentifier {
    NSDictionary *persistedStores = [[NSUserDefaults standardUserDefaults] objectForKey:kThinkGamingProductListPersistanceKey];
    if (persistedStores == nil) return [NSArray array];
    NSArray *matches = [[persistedStores allKeys] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF == %@", storeIdentifier]];
    if (matches && matches.count > 0) {
        return [persistedStores[matches[0]] mutableCopy];
    }
    return [NSArray array];
}


@end
