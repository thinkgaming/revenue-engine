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
             
             /* UIImage
              Background image for store.
              */
             tgStoreStyleNavigationBarCloseImage : [UIImage imageNamed:@"redx"],

             /* NSString
                Font name. Ensure the font is added to the bundle, and the Font keys are added to your *-Info.plist.
              */
             tgStoreStyleFontName : @"GROBOLD",
             
             /* UIImage
                Background image for store.
              */
             tgStoreStyleBackgroundImage : [UIImage imageNamed:@"background"],
             
             /* UIColor
              Font color for currency.
              */
             tgStoreStyleCurrencyLabelFontColor : [UIColor whiteColor],
             
             /* UIColor
              Font color for store item description
              */
             tgStoreStyleStoreItemDescriptionFontColor : [self colorWithHexString:@"#247287"],

             /* UIColor
              Font color for store item description
              */
             tgStoreStyleStoreItemPriceFontColor : [UIColor whiteColor],

             /* NSString
              Font name. Ensure the font is added to the bundle, and the Font keys are added to your *-Info.plist.
              */
             tgStoreStyleStoreItemPromoFontName : @"ChalkDuster",

             /* UIImage
              Background image for item.
              */
             tgStoreStyleStoreItemBackgroundImage : [UIImage imageNamed:@"single_button"],

             /* UIImage
              Background image for item.
              */
             tgStoreStyleBackButtonImage : [UIImage imageNamed:@"back_button"]
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
    
    if (styles[tgStoreStyleNavigationBarCloseImage]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:store action:@selector(didTapClose:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *buttonImage = styles[tgStoreStyleNavigationBarCloseImage];
        [button setImage:buttonImage forState:UIControlStateNormal];
        [button setFrame:CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height)];
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        store.navigationItem.rightBarButtonItem = barButton;
    }
    
    if (styles[tgStoreStyleBackButtonImage]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        store.navigationItem.hidesBackButton = YES;
        [button addTarget:store action:@selector(didTapBack:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *buttonImage = styles[tgStoreStyleBackButtonImage];
        [button setImage:buttonImage forState:UIControlStateNormal];
        [button setFrame:CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height)];
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        store.navigationItem.leftBarButtonItem = barButton;
    }

    
    [@[store.coinsLabel, store.dollarsLabel] enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        label.font = [UIFont fontWithName:styles[tgStoreStyleFontName] size:14.0];
        label.textColor = styles[tgStoreStyleCurrencyLabelFontColor];
    }];
}

+ (void) applyToStoreList:(ThinkGamingStoreListViewController *)storeList {
    NSDictionary *styles = [self getStyles];

    if (styles[tgStoreStyleNavigationBarCloseImage]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:storeList action:@selector(didTapClose:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *buttonImage = styles[tgStoreStyleNavigationBarCloseImage];
        [button setImage:buttonImage forState:UIControlStateNormal];
        [button setFrame:CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height)];
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        storeList.navigationItem.rightBarButtonItem = barButton;
    }

}

+ (void) applyToStoreItemCell:(ThinkGamingSingleStoreItemCell *)cell {
    NSDictionary *styles = [self getStyles];
    
    cell.itemDescription.font = [UIFont fontWithName:styles[tgStoreStyleFontName] size:11.0];
    cell.itemDescription.textColor = styles[tgStoreStyleStoreItemDescriptionFontColor];
    
    cell.itemPrice.font = [UIFont fontWithName:styles[tgStoreStyleFontName] size:12.0];
    cell.itemPrice.textColor = styles[tgStoreStyleStoreItemPriceFontColor];
    
    cell.itemPromoText.font = [UIFont fontWithName:styles[tgStoreStyleStoreItemPromoFontName] size:9.0];
    
    cell.backgroundImageView.image = styles[tgStoreStyleStoreItemBackgroundImage];
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
