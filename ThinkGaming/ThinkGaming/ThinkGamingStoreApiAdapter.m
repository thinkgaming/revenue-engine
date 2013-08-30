//
//  ThinkGamingStoreApiAdapter.m
//  ThinkGaming
//
//  Created by Aaron Junod on 7/17/13.
//  Copyright (c) 2013 ThinkGaming. All rights reserved.
//

#import "ThinkGamingStoreApiAdapter.h"
#import "ThinkGamingLogger.h"

static NSString * const kThinkGamingAPIBaseURLString = @"https://api.thinkgaming.com/api/v2";
static NSString * const kThinkGamingAPIStorePath = @"/stores";
static NSString * const kThinkGamingAPIItemsPath = @"/stores/";

@interface ThinkGamingStoreApiAdapter()

@property (strong) NSURLConnection *connection;
@property (strong) NSMutableData *response;
@property BOOL isFinished;
@property (nonatomic, copy) void(^success)(NSDictionary *);
@property (nonatomic, copy) void(^error)(NSError*);


- (void) getStoresWithSuccess:(void(^)(NSDictionary *))success
                        error:(void(^)(NSError*))error;

- (void) getProductsForStore:(NSString *)storeIdentifier
                     success:(void(^)(NSDictionary *))success
                       error:(void(^)(NSError*))error;

@end



@implementation ThinkGamingStoreApiAdapter

- (NSMutableURLRequest *) makeRequestForUrl:(NSURL *)url {
    self.response = [NSMutableData data];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"GET"];
    [request addValue:[ThinkGamingLogger currentApiKey] forHTTPHeaderField:@"X-ThinkGaming-API-Key"];

    return request;
}

- (NSError *) validate {
    if ([ThinkGamingLogger currentApiKey] == nil) {
        return [NSError errorWithDomain:@"com.thinkgaming" code:1001 userInfo:@{@"error":@"No api key"}];
    }
    return nil;
}

- (void) getPayloadForUrl:(NSURL *) url {
    NSError *err = [self validate];
    if (err) {
        self.error(err);
        return;
    }
    
    NSMutableURLRequest *request = [self makeRequestForUrl:url];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    while(!self.isFinished) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }

}


#pragma mark - Public methods

- (void) getStoresWithSuccess:(void(^)(NSDictionary *))success
                        error:(void(^)(NSError*))error {
    self.success = success;
    self.error = error;

    NSString *urlString = [NSString stringWithFormat:@"%@%@", kThinkGamingAPIBaseURLString, kThinkGamingAPIStorePath];
    [self getPayloadForUrl:[NSURL URLWithString:urlString]];
}

- (void) getProductsForStore:(NSString *)storeIdentifier
                     success:(void(^)(NSDictionary *))success
                       error:(void(^)(NSError*))error {
    self.success = success;
    self.error = error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", kThinkGamingAPIBaseURLString, kThinkGamingAPIItemsPath, storeIdentifier];
    [self getPayloadForUrl:[NSURL URLWithString:urlString]];
}

#pragma mark - NSURLConnection Delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.response appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //NSLog(@"Status : %i", [(NSHTTPURLResponse*)response statusCode]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.connection = nil;
    self.isFinished = YES;
    
    //NSString *stringResponse = [[NSString alloc] initWithData:self.response encoding:NSUTF8StringEncoding];
    //NSLog(@"connectionDidFinishLoading : %@", stringResponse);
    
    
    if (self.success != nil) {
        NSError *err;
        NSDictionary *results = [NSJSONSerialization JSONObjectWithData:self.response options:0 error:&err];
        if (err) {
            self.error(err);
        } else {
            self.success(results);
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //NSLog(@"Connection Encountered an Error");
    self.connection = nil;
    
    self.error(error);
}


#pragma mark - Convenience methods

+ (void) getStoresWithSuccess:(void(^)(NSDictionary *))success
                        error:(void(^)(NSError*))error {
    ThinkGamingStoreApiAdapter *adapter = [[ThinkGamingStoreApiAdapter alloc] init];
    [adapter getStoresWithSuccess:success error:error];
    
}

+ (void) getProductsForStore:(NSString *)storeIdentifier
                     success:(void(^)(NSDictionary *))success
                       error:(void(^)(NSError*))error {
    ThinkGamingStoreApiAdapter *adapter = [[ThinkGamingStoreApiAdapter alloc] init];
    [adapter getProductsForStore:storeIdentifier success:success error:error];
}

@end
