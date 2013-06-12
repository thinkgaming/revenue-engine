//
//  IAPProductCell.h
//  ThinkGamingTestHarness
//
//  Created by Aaron Junod on 6/12/13.
//  Copyright (c) 2013 thinkgaming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface IAPProductCell : UITableViewCell

@property (weak) SKProduct *product;
@property (weak) IBOutlet UILabel *descriptionLabel;
@property (weak) IBOutlet UILabel *titleLabel;
@property (weak) IBOutlet UILabel *priceLabel;
@property (weak) IBOutlet UILabel *productIdentifierLabel;
@property (weak) IBOutlet UIButton *buyButton;

- (IBAction)didTapBuyProduct:(id)sender;

@end
