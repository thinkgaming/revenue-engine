thinksdk
========

ThinkSDK

// User instructions
Getting started

 - Copy the libThinkGamingAF.a and ThinkGaming.h files to your project.
 - Make sure the libThinkGamingAF.a library shows up in the "Link Binaries With Libraries" section in your project's Build Phases tab

 - Make sure your app references SystemConfiguration.framework for Reachability
 - Make sure your app references AdSupport.framework for AdSupport support. This can be optional, and the SDK support iOS 5.
 
Once you have determined that the project successfully compiles, start the ThinkGaming session with the following call in your Application's AppDelegate:

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

 ...
     [ThinkGaming startSession:@"YOUR_API_KEY_HERE"];
}

You can log standard events using the following methods:
+ (void)logEvent:(NSString *)eventName;
+ (void)logEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters;
+ (void)logEvent:(NSString *)eventName timed:(BOOL)timed;
+ (void)logEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters timed:(BOOL)timed;
+ (void)endTimedEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters;

Please note that a timed event must have a matching endTimedEvent call to be tracked properly. The event name must be the same in the timed logEvent and endTimedEvent calls.

To pass in user-defined parameters, create an NSDictionary and pass it to any of the logEvent functions in the parameters field.



// COMPILATION INSTRUCTIONS
To create the libraries, choose the libThinkGamingCombined. This will clean and build the appropriate static libraries in both
simulator and device targets, and combine them into a single static library, as well as move the resulting .a and .h files into the libs directory via a post-build script.
