//
//  ThinkGamingApiAdapter.m
//  ThinkGaming
//
//  Created by Aaron Junod on 6/4/13.
//  Copyright (c) 2013 ThinkGaming. All rights reserved.
//

#import "ThinkGamingLoggingApiAdapter.h"

static NSString * const kThinkGamingAPIBaseURLString = @"http://api.thinkgaming.com:8080/";
static NSString * const kLoggingPath = @"/log_activity2/";

@interface ThinkGamingLoggingApiAdapter()
@property (strong) NSURLConnection *connection;
@property (strong) NSMutableData *response;
@property (nonatomic, copy) void(^success)(NSData *);
@property (nonatomic, copy) void(^error)(NSError*);


- (void) dispatchEvents:(NSDictionary *)events
                success:(void(^)(NSData *))success
                  error:(void(^)(NSError*))error;


@end

@implementation ThinkGamingLoggingApiAdapter

- (NSMutableURLRequest *) makeRequest {
    self.response = [NSMutableData data];
    NSURL *root = [NSURL URLWithString:kThinkGamingAPIBaseURLString];
    NSURL *url = [NSURL URLWithString:kLoggingPath relativeToURL:root];
    return [NSMutableURLRequest requestWithURL:url];
}

- (void) dispatchEvents:(NSDictionary *)events
                success:(void(^)(NSData *))success
                  error:(void(^)(NSError*))error {

    self.success = success;
    self.error = error;
    
    NSMutableURLRequest *request = [self makeRequest];
    NSError *err;
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    
    if (events) {
        NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
        [request setValue:[NSString stringWithFormat:@"application/json; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:events options:0 error:&err]];
    }
    
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

#pragma mark - NSURLConnection Delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.response appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"Status : %i", [(NSHTTPURLResponse*)response statusCode]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.connection = nil;
    
    NSLog(@"connectionDidFinishLoading : %@", self.response);
    
    
    if (self.success != nil) {
        self.success(self.response);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection Encountered an Error");
    self.connection = nil;
    
    self.error(error);
}



+ (void) dispatchEvents:(NSDictionary *)events
                success:(void(^)(NSData *))success
                  error:(void(^)(NSError*))error {
    ThinkGamingLoggingApiAdapter *adapter = [[ThinkGamingLoggingApiAdapter alloc] init];
    [adapter dispatchEvents:events success:success error:error];
}

@end
