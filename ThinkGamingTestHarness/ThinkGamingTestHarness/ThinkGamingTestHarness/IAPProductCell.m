//
//  IAPProductCell.m
//  ThinkGamingTestHarness
//
//  Created by Aaron Junod on 6/12/13.
//  Copyright (c) 2013 thinkgaming. All rights reserved.
//

#import "IAPProductCell.h"
#import "ThinkGamingIAPAdapter.h"

@implementation IAPProductCell

- (IBAction)didTapBuyProduct:(id)sender {
    [[ThinkGamingIAPAdapter shared] buyProduct:self.product];
}

@end
