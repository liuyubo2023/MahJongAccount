//
//  SettingViewController.m
//  MahJongAccount
//
//  Created by yubo liu on 2017/12/14.
//  Copyright © 2017年 yubo liu. All rights reserved.
//

#import "SettingViewController.h"
#import "GamerNameTableViewCell.h"
#import "FileManager.h"
#import "MJAlertUtils.h"

static NSString *const KGamerNameTableViewCell = @"GamerNameTableViewCell";

@interface SettingViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *namesMutableArray;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 76;
    }
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (indexPath.section == 0) {
        GamerNameTableViewCell *nameCell = (GamerNameTableViewCell *)[tableView dequeueReusableCellWithIdentifier:KGamerNameTableViewCell forIndexPath:indexPath];
        nameCell.nameLabel.text = [NSString stringWithFormat:@"第%lu列的名字",indexPath.row];
        nameCell.nameTextField.text = self.namesMutableArray[indexPath.row];
        nameCell.nameTextField.tag = indexPath.row;
        nameCell.nameTextField.delegate = self;
        [nameCell.nameTextField addTarget:self action:@selector(textFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
        cell = nameCell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(16, 40, CGRectGetWidth([UIScreen mainScreen].bounds) - 32, 44)];
        [button setBackgroundColor:UIColorFromRGB(0xed5565)];
        [button setTitle:@"清除数据" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(didTapClearGameInfo) forControlEvents:UIControlEventTouchUpInside];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 56)];
        [view addSubview:button];
        return view;
    }
    return nil;
}

#pragma mark - private methods
- (void)setupTableView {
    [self.tableView registerNib:[UINib nibWithNibName:KGamerNameTableViewCell bundle:nil] forCellReuseIdentifier:KGamerNameTableViewCell];
    
    
    self.namesMutableArray = [[[FileManager defaultManager] loadNames] mutableCopy];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(didTapDone:)];
}

- (void)didTapDone:(id)sender {
    [[FileManager defaultManager] saveNames:[self.namesMutableArray copy]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didTapClearGameInfo {
    [MJAlertUtils showAlertWithTitle:nil msg:@"你确定清除所有数据" buttonsStatement:@[@"取消",@"清除"] chooseBlock:^(NSInteger buttonIdx) {
        if (buttonIdx == 1) {
            [[FileManager defaultManager].games clear];
            [[FileManager defaultManager] saveGame];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)textFieldTextChanged:(UITextField *)textField {
    switch (textField.tag) {
        case 0:
            self.namesMutableArray[0] = textField.text;
            break;
        case 1:
            self.namesMutableArray[1] = textField.text;
            break;
        case 2:
            self.namesMutableArray[2] = textField.text;
            break;
        case 3:
            self.namesMutableArray[3] = textField.text;
            break;
            
        default:
            break;
    }
}

#pragma mark - getters
- (NSMutableArray *)namesMutableArray {
    if (!_namesMutableArray) {
        _namesMutableArray = [@[@"", @"", @"", @""] mutableCopy];
    }
    return _namesMutableArray;
}

@end
