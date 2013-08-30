//
//  ThinkGamingCache.h
//  ThinkGaming
//
//  Created by Aaron Junod on 7/31/13.
//  Copyright (c) 2013 ThinkGaming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThinkGamingCache : NSObject

+ (void) persistStoreList:(NSArray *)storeListPayload;
+ (NSArray *) getStoreList;
+ (void) persistStore:(NSString *)storeIdentifier withProducts:(NSArray *)products;
+ (NSArray *) getProductsForStore:(NSString *)storeIdentifier;

@end
