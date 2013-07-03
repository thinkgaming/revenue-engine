//
//  ThinkGamingStoreUIStyleAppearance.m
//  ThinkGamingStoreUI
//
//  Created by Aaron Junod on 7/3/13.
//  Copyright (c) 2013 ThinkGaming. All rights reserved.
//

#import "ThinkGamingStoreUIStyleAppearance.h"
#import "ThinkGamingStoreUINavigationController.h"

@implementation ThinkGamingStoreUIStyleAppearance

+ (NSDictionary *) getStyles {
    return @{
             /* UIColor
                Tint color for navigation bar. Return nil and return a color below for solid colors.
              */
//             tgStoreStyleNavigationBarTintColor : [UIColor blackColor],

             /* UIColor
                Solid color for navigation bar. To use return nil for tint color as well.
              */
             tgStoreStyleNavigationBarSolidColor : [self colorWithHexString:@"#2466ad"],

             /* UIColor
              Font color for navigation bar.
              */
             tgStoreStyleNavigationBarFontColor : [UIColor whiteColor],

             /* NSString
                Font name. Ensure the font is added to the bundle, and the Font keys are added to your *-Info.plist.
              */
             tgStoreStyleFontName : @"GROBOLD",
             
             /* UIImage
                Background image for store.
              */
             tgStoreStyleBackgroundImage : [UIImage imageNamed:@"background"]
             };
}


+ (void) apply {
    NSDictionary *styles = [self getStyles];
    
    if (styles[tgStoreStyleNavigationBarTintColor]) {
        [[UINavigationBar appearanceWhenContainedIn:[ThinkGamingStoreUINavigationController class], nil] setTintColor:styles[tgStoreStyleNavigationBarTintColor]];
    } else {
        [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearanceWhenContainedIn:[ThinkGamingStoreUINavigationController class], nil] setBackgroundColor:styles[tgStoreStyleNavigationBarSolidColor]];
    }
    
    [[UINavigationBar appearanceWhenContainedIn:[ThinkGamingStoreUINavigationController class], nil] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      styles[tgStoreStyleNavigationBarFontColor], UITextAttributeTextColor,
      [UIFont fontWithName:styles[tgStoreStyleFontName] size:16.0], UITextAttributeFont,nil]];
}

+ (void) applyToStore:(ThinkGamingStoreUIViewController *)store {
    NSDictionary *styles = [self getStyles];
    store.backgroundImage.image = styles[tgStoreStyleBackgroundImage];
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert {
    NSString *noHashString = [stringToConvert stringByReplacingOccurrencesOfString:@"#" withString:@""]; // remove the #
    NSScanner *scanner = [NSScanner scannerWithString:noHashString];
    [scanner setCharactersToBeSkipped:[NSCharacterSet symbolCharacterSet]]; // remove + and $
    
    unsigned hex;
    if (![scanner scanHexInt:&hex]) return nil;
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f];
}




@end
