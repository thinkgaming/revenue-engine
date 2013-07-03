//
//  ThinkGamingStoreItemsCollectionView.m
//  ThinkGamingStoreUI
//
//  Created by Aaron Junod on 7/3/13.
//  Copyright (c) 2013 ThinkGaming. All rights reserved.
//

#import "ThinkGamingStoreItemsCollectionView.h"
#import "ThinkGamingSingleStoreItemCell.h"
#import "ThinkGamingStoreUIStyleAppearance.h"

@interface ThinkGamingStoreItemsCollectionView ()

@end

@implementation ThinkGamingStoreItemsCollectionView

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionView Delegates
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ThinkGamingSingleStoreItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ThinkGamingSingleStoreItemCell class]) forIndexPath:indexPath];
    [ThinkGamingStoreUIStyleAppearance applyToStoreItemCell:cell];
    return cell;
}


@end
