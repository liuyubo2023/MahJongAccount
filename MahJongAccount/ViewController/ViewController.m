//
//  ViewController.m
//  MahJongAccount
//
//  Created by yubo liu on 2017/12/4.
//  Copyright © 2017年 yubo liu. All rights reserved.
//

#import "ViewController.h"
#import "HomeCollectionViewDataSource.h"
#import "MJAlertUtils.h"
#import "CalculateNumUtils.h"
#import "SettingViewController.h"
#import "FileManager.h"


static NSString *const kCollectionCell = @"MJCollectionViewCell";

@interface ViewController () <
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) HomeCollectionViewDataSource *collectionViewDatasource;

@property (nonatomic, assign) NSInteger bankerCount;       //庄的计数
@property (nonatomic, assign) NSUInteger winTimes;         //倍数
@property (nonatomic, copy) NSArray *namesArray;           //名字数组
@property (nonatomic, strong) NSMutableArray *countArray;  //计数的数组

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"账单计算器";
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self collectionViewReloadDataSource];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(30, 16, 0, 16);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (ScreenWidth - 70) / 4;
    return CGSizeMake(width, width);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    //行数
    NSInteger divisor = indexPath.row / 4;
    //列数
    NSInteger remainder = indexPath.row  % 4;
    //庄是第几列
    NSInteger bankerNum = _bankerCount % 4;
    switch (divisor) {
            case 0:
            _bankerCount = remainder;
            [self saveGameInfo];
            break;
        case 3:
            [self updateAndSaveNumber:winTypeHu winnerNum:remainder bankerNum:bankerNum];
            break;
        case 4:
            [self updateAndSaveNumber:winTypeZimo winnerNum:remainder bankerNum:bankerNum];
            break;
        case 5:
            [self updateAndSaveNumber:winTypeGang winnerNum:remainder bankerNum:bankerNum];
            break;
        default:
            break;
    }
}

#pragma mark - event handlers
- (void)setupRightBarButton {
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(TapToSettingVC)];
    self.navigationItem.rightBarButtonItem = button;
}

- (void)setupLeftBarButton {
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(tapRevoke)];
    self.navigationItem.leftBarButtonItem = button;
}

#pragma mark - private methods
- (void)setup {
    [self setupLeftBarButton];
    [self setupRightBarButton];
    [self configureCollectionView];
    self.synthesizer = [[AVSpeechSynthesizer alloc] init];}

- (void)configureCollectionView {
    self.collectionViewDatasource = [[HomeCollectionViewDataSource alloc] initWithCollectionView:self.collectionView];
    self.collectionView.dataSource = self.collectionViewDatasource;
}

- (void)collectionViewReloadDataSource {
    self.namesArray = [[FileManager defaultManager] loadDataForKey:kNamesSaving];
    [self.collectionView reloadData];
}

- (void)updateAndSaveNumber:(WinType)wintype winnerNum:(NSInteger)winnerNum bankerNum:(NSInteger)bankerNum {
    _countArray = [[CalculateNumUtils sharedManager] calculateWithWinType:wintype winnerNum:winnerNum bankerNum:bankerNum];
    //是否做庄，如果做庄计数加1
    if (wintype != winTypeGang && winnerNum != bankerNum) {
        _bankerCount += 1;
    }
    //语音播报
    NSString *speakString = [NSString stringWithFormat:@"%@+%d",self.namesArray[winnerNum],([_countArray[winnerNum+4] intValue] * 2)];
    [self speechInfo:speakString];
    
    [self saveGameInfo];
}

- (void)saveGameInfo {
    GameModel *currentGame = [[GameModel alloc] init];
    currentGame.countArray = _countArray;
    currentGame.bankerCount = _bankerCount;
    
    Stack *games = [[FileManager defaultManager] loadDataForKey:kGamesSaving];
    
    if (!games) {
        games = [[Stack alloc] initWithSize:10];
    }
    [games push:currentGame];
    [[FileManager defaultManager] saveData:games forKey:kGamesSaving];
    
    [self.collectionView reloadData];
}

- (void)TapToSettingVC {
    SettingViewController *vc = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tapRevoke {
    [MJAlertUtils showAlertWithTitle:@"回撤" msg:@"确定回撤到上步操作" buttonsStatement:@[@"取消",@"回撤"] chooseBlock:^(NSInteger buttonIdx) {
        if (buttonIdx == 1) {
            Stack *games = [[FileManager defaultManager] loadDataForKey:kGamesSaving];
            [games pop];
            [[FileManager defaultManager] saveData:games forKey:kGamesSaving];
            [self.collectionView reloadData];
        }
    }];
}

//语音播报
- (void)speechInfo:(NSString *)string {
    //设置播报的内容
    AVSpeechUtterance * utterance = [[AVSpeechUtterance alloc] initWithString:string];
    //设置语言类别
    AVSpeechSynthesisVoice * voiceType = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    utterance.voice = voiceType;
    //设置播报语速
    utterance.rate = 0.5;
    [_synthesizer speakUtterance:utterance];
}

@end
