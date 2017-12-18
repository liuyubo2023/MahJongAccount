//
//  ViewController.m
//  MahJongAccount
//
//  Created by yubo liu on 2017/12/4.
//  Copyright © 2017年 yubo liu. All rights reserved.
//

#import "ViewController.h"
#import "MJCollectionViewCell.h"
#import "CalculateNumUtils.h"
#import "SettingViewController.h"
#import "FileManager.h"

static NSString *const kCollectionCell = @"MJCollectionViewCell";

@interface ViewController () <
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    SettingViewControllerDelegate
>

@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger bankerCount;    //庄的计数
@property (nonatomic, assign) BOOL isBanker;            //是不是庄
@property (nonatomic, assign) NSInteger bankerNum;      //庄是第几列
@property (nonatomic, assign) NSUInteger winTimes;      //倍数

@property (nonatomic, strong) NSMutableArray *countArray;  //计数的数组

@property (nonatomic, copy) NSArray *callBackNames;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[FileManager defaultManager].games clear];
    
    self.title = @"计算";
    [self setupCollectionView];
    [self setupLeftBarButton];
    [self setupRightBarButton];
    [self setupForDismissKeyboard];
    self.synthesizer = [[AVSpeechSynthesizer alloc] init];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 24;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(30, 16, 0, 16);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (ScreenWidth - 70) / 4;
    return CGSizeMake(width, width);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MJCollectionViewCell *cell = (MJCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCell forIndexPath:indexPath];
    self.bankerCount = [[[FileManager defaultManager].games peek] bankerCount];
    self.countArray = [[[FileManager defaultManager].games peek] countArray];
    switch (indexPath.row) {
        case 0 ... 3: {
            if (self.callBackNames.count == 4) {
                cell.textField.text = self.callBackNames[indexPath.row];
            } else {
                cell.textField.text = @"姓";
            }
            if (indexPath.row == _bankerCount % 4) {
                cell.textField.backgroundColor = [UIColor redColor];
            } else {
                cell.textField.backgroundColor = [UIColor purpleColor];
            }
        }
            break;
        case 4 ... 11:
            cell.textField.backgroundColor = [UIColor brownColor];
            cell.textField.text = [NSString stringWithFormat:@"%d",([self.countArray[indexPath.row - 4] intValue] * 2)];
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
            cell.textField.backgroundColor = [UIColor magentaColor];
            break;
        
        default:
            break;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    //行数
    NSInteger divisor = indexPath.row / 4;
    //列数
    NSInteger remainder = indexPath.row  % 4;
    //庄是第几列
    _bankerNum =_bankerCount % 4;
    switch (divisor) {
            case 0:
            _bankerCount = remainder;
            [self saveGameInfo];
            break;
        case 3:
            [self changeNumber:winTypeHu winnerNum:remainder bankerNum:_bankerNum];
            break;
        case 4:
            [self changeNumber:winTypeZimo winnerNum:remainder bankerNum:_bankerNum];
            break;
        case 5:
            [self changeNumber:winTypeGang winnerNum:remainder bankerNum:_bankerNum];
            break;
        default:
            break;
    }
    NSLog(@"%lu",indexPath.row);
}

#pragma mark - private methods
- (void)setupCollectionView {
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:kCollectionCell bundle:nil] forCellWithReuseIdentifier:kCollectionCell];
}

- (void)changeNumber:(WinType)wintype winnerNum:(NSInteger)winnerNum bankerNum:(NSInteger)bankerNum{
    _countArray = [[CalculateNumUtils sharedManager] calculateWithWinType:wintype winnerNum:winnerNum bankerNum:bankerNum];
    
    if (wintype != winTypeGang && winnerNum != bankerNum) {
        _bankerCount += 1;
    }
    
    [self saveGameInfo];
}

- (void)saveGameInfo {
    GameModel *game = [[GameModel alloc] init];
    game.countArray = _countArray;
    game.bankerCount = _bankerCount;
    
    [[FileManager defaultManager].games push:game];
    [[FileManager defaultManager] saveGame];
    [self.collectionView reloadData];
}

- (void)setupRightBarButton {
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(TapToSettingVC)];
    self.navigationItem.rightBarButtonItem = button;
}

- (void)setupLeftBarButton {
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(tapRevoke)];
    self.navigationItem.leftBarButtonItem = button;
}

- (void)TapToSettingVC {
    SettingViewController *vc = [[SettingViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tapRevoke {
    [[FileManager defaultManager].games pop];
    [self.collectionView reloadData];
}

//语音播报
- (void)speechInfo:(NSString *)string {
    //设置播报的内容
    AVSpeechUtterance * utterance = [[AVSpeechUtterance alloc] initWithString:string];
    //设置语言类别
    AVSpeechSynthesisVoice * voiceType = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    utterance.voice = voiceType;
    //设置播报语速
    utterance.rate = 0.4;
    [_synthesizer speakUtterance:utterance];
}

- (NSMutableArray *)countArray {
    if (!_countArray) {
        _countArray = [NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0,@0,@0,@0, nil];
    }
    return _countArray;
}

#pragma mark - delegate
- (void)sendNames:(NSArray *)names {
    self.callBackNames = [names copy];
    [self.collectionView reloadData];
}

@end
