//
//  HomeCollectionViewDataSource.h
//  MahJongAccount
//
//  Created by yubo liu on 2017/12/22.
//  Copyright © 2017年 yubo liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeCollectionViewDataSource : NSObject <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) UICollectionView *collectionView;


- (instancetype)initWithCollectionView:(UICollectionView *)collectionView;

@end
