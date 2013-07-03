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
                Tint color for navigation bar.
              */
             tgStoreStyleNavigationBarTintColor : [UIColor blackColor],

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
    [[UINavigationBar appearanceWhenContainedIn:[ThinkGamingStoreUINavigationController class], nil] setTintColor:styles[tgStoreStyleNavigationBarTintColor]];
    
    [[UINavigationBar appearanceWhenContainedIn:[ThinkGamingStoreUINavigationController class], nil] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor blackColor], UITextAttributeTextColor,
      [UIFont fontWithName:styles[tgStoreStyleFontName] size:16.0], UITextAttributeFont,nil]];
}

+ (void) applyToStore:(ThinkGamingStoreUIViewController *)store {
    NSDictionary *styles = [self getStyles];
    store.backgroundImage.image = styles[tgStoreStyleBackgroundImage];
}



@end
