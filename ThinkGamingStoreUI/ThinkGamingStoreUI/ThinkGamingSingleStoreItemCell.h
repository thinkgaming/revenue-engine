//
//  ThinkGamingSingleStoreItemCell.h
//  ThinkGamingStoreUI
//
//  Created by Aaron Junod on 7/3/13.
//  Copyright (c) 2013 ThinkGaming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThinkGamingSingleStoreItemCell : UICollectionViewCell

@property (weak) IBOutlet UIImageView *backgroundImageView;
@property (weak) IBOutlet UIImageView *itemImageView;
@property (weak) IBOutlet UITextView *itemDescription;
@property (weak) IBOutlet UILabel *itemPrice;
@property (weak) IBOutlet UILabel *itemPromoText;

@end
