//
//  ThinkGamingStoreApiAdapter.h
//  ThinkGaming
//
//  Created by Aaron Junod on 7/17/13.
//  Copyright (c) 2013 ThinkGaming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThinkGamingStoreApiAdapter : NSObject

+ (void) getStoresWithSuccess:(void(^)(NSDictionary *))success
                  error:(void(^)(NSError*))error;

+ (void) getProductsForStore:(NSString *)storeIdentifier
                success:(void(^)(NSDictionary *))success
                  error:(void(^)(NSError*))error;

@end
