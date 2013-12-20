#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>


#define TG_IS_IOS6_AWARE (__IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_5_1)

#define TG_ITMS_PROD_VERIFY_RECEIPT_URL        @"https://buy.itunes.apple.com/verifyReceipt"
#define TG_ITMS_SANDBOX_VERIFY_RECEIPT_URL     @"https://sandbox.itunes.apple.com/verifyReceipt";

#define TG_KNOWN_TRANSACTIONS_KEY              @"knownIAPTransactions"
#define TG_ITC_CONTENT_PROVIDER_SHARED_SECRET  @"8581a699d1264c9eb0cd0b1123227f04"

char * TG_base64_encode(const void* buf, size_t size);
void * TG_base64_decode(const char* s, size_t * data_len);

typedef void (^TG_VerifyCompletionHandler)(BOOL success);

@interface TG_VerificationController : NSObject {
    NSMutableDictionary *transactionsReceiptStorageDictionary;
}
@property BOOL enabled;

@property (strong) NSString *serverUrl;
+ (TG_VerificationController *) sharedInstance;


// Checking the results of this is not enough.
// The final verification happens in the connection:didReceiveData: callback within
// this class.  So ensure IAP feaures are unlocked from there.
- (void)verifyPurchase:(SKPaymentTransaction *)transaction completionHandler:(TG_VerifyCompletionHandler)completionHandler;

@end
