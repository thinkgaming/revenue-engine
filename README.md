thinksdk
========

ThinkSDK

// User instructions
Getting started

There are 2 versions of the ThinkGaming library. 

If you are using the AFNetworking library in your project:
 - Copy the libThinkGaming.a and ThinkGaming.h files to your project.
 - Make sure the libThinkGaming.a library shows up in the "Link Binaries With Libraries" section in your project's Build Phases tab
 
If you are NOT using the AFNetworking library in your project:
 - Copy the libThinkGamingAF.a and ThinkGaming.h files to your project.
 - Make sure the libThinkGamingAF.a library shows up in the "Link Binaries With Libraries" section in your project's Build Phases tab
 
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
To create the libraries, choose either the libThinkGamingCombined or libThinkGamingCombinedAF schemes. This will clean and build the appropriate static libraries in both
simulator and device targets, and combine them into a single static library, as well as move the resulting .a and .h files into the libs directory via a post-build script.
