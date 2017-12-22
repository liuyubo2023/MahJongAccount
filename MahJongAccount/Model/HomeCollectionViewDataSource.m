//
//  HomeCollectionViewDataSource.m
//  MahJongAccount
//
//  Created by yubo liu on 2017/12/22.
//  Copyright © 2017年 yubo liu. All rights reserved.
//

#import "HomeCollectionViewDataSource.h"
#import "MJCollectionViewCell.h"

#import "FileManager.h"
#import "Chameleon.h"

static NSString *const kCollectionCell = @"MJCollectionViewCell";

@interface HomeCollectionViewDataSource()

@property (nonatomic, assign) NSInteger bankerCount;    //庄的计数

@property (nonatomic, strong) NSMutableArray *countArray;  //计数的数组
@property (nonatomic, copy) NSArray *namesArray;
@property (nonatomic, assign) NSUInteger winTimes;         //倍数

@end

@implementation HomeCollectionViewDataSource

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView {
    self = [super init];
    if (self) {
        _collectionView = collectionView;
        [self setupCollectionView];
    }
    return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 24;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MJCollectionViewCell *cell = (MJCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCell forIndexPath:indexPath];
    Stack *games = [[FileManager defaultManager] loadDataForKey:kGamesSaving];
    self.namesArray = [[FileManager defaultManager] loadDataForKey:kNamesSaving];
    _winTimes = [[[FileManager defaultManager] loadDataForKey:kTimesSaving] integerValue];
    if (!_winTimes) {
        [[FileManager defaultManager] saveData:[NSNumber numberWithInt:1] forKey:kTimesSaving];
    }
    if (!self.namesArray) {
        self.namesArray = @[@"东", @"南", @"西", @"北"];
        [[FileManager defaultManager] saveData:self.namesArray forKey:kNamesSaving];
    }
    self.bankerCount = [games.peek bankerCount];
    self.countArray = [games.peek countArray];
    switch (indexPath.row) {
        case 0 ... 3: {
            cell.textField.text = self.namesArray[indexPath.row];
            if (indexPath.row == _bankerCount % 4) {
                cell.textField.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleDiagonal withFrame:cell.frame andColors:@[[UIColor flatGreenColor], [UIColor flatRedColor], [UIColor flatYellowColor]]];
            } else {
                cell.textField.backgroundColor = [UIColor flatMintColor];
            }
        }
            break;
        case 4 ... 11:
            cell.textField.backgroundColor = [UIColor flatBlueColor];
            cell.textField.text = [NSString stringWithFormat:@"%d",([self.countArray[indexPath.row - 4] intValue] * (int)_winTimes)];
            break;
        case 12 ... 15:
            cell.textField.text = @"胡";
            cell.textField.backgroundColor = [UIColor orangeColor];
            break;
        case 16 ... 19:
            cell.textField.text = @"自摸";
            cell.textField.backgroundColor = UIColorFromRGB(0xF96750);
            break;
        case 20 ... 23:
            cell.textField.text = @"杠";
            cell.textField.backgroundColor = [UIColor flatPinkColor];
            break;
            
        default:
            break;
    }
    return cell;
}

- (void)setupCollectionView {
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:kCollectionCell bundle:nil] forCellWithReuseIdentifier:kCollectionCell];
}

- (NSMutableArray *)countArray {
    if (!_countArray) {
        _countArray = [NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0,@0,@0,@0, nil];
    }
    return _countArray;
}

@end
