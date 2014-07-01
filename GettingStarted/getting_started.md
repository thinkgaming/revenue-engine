#Think Gaming iOS Quick Start

Downloading and integrating our SDK should be very quick and easy. Our SDK logs the details we need. Simply install it and initialize it with your API key. All the details you need are provided below.


##Integrate the SDK into your iOS app.

1. Drag the .a and h files into your project, or install via [cocoapods](http://cocoapods.org/?q=thinkgaming).
![Drag to project](drag_to_project.png "Drag to Project")

2. Add the files to your project.
![Add to project](add_to_project.png "Add to Project")

3. Add the following Libraries 
	* AdSupport.framework
	* SystemConfiguration.framework
	* StoreKit.framework
![Add libraries](add_libraries.png "Add libraries")

##Start using the Store SDK


####Initialize the SDK with your API key. We recommend you do this in your app delegate.

* Open your app delegate.
* Find the applicationDidFinishLaunchingWithOptions:.
* Add Add the following initialize call.
* NOTE : Be sure to use your ThinkGamingApiKey!

```Objective-C
#import "ThinkGamingLogger.h"

[ThinkGamingLogger startSession:@"YourThinkGamingApiKey"];


```
