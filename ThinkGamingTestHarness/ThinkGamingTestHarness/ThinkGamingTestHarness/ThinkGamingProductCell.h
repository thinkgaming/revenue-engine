//
//  ThinkGamingProductCell.h
//  ThinkGamingTestHarness
//
//  Created by Aaron Junod on 7/17/13.
//  Copyright (c) 2013 thinkgaming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThinkGamingProductCell : UITableViewCell

@property (weak) IBOutlet UILabel *displayName;
@property (weak) IBOutlet UILabel *displayDescription;
@property (weak) IBOutlet UILabel *iTunesId;
@property (weak) IBOutlet UILabel *offerText;
@property (weak) IBOutlet UILabel *percentage;
@property (weak) IBOutlet UILabel *price;
@property (weak) IBOutlet UILabel *productId;


@end
