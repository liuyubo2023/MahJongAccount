//
//  SettingViewController.m
//  MahJongAccount
//
//  Created by yubo liu on 2017/12/14.
//  Copyright © 2017年 yubo liu. All rights reserved.
//

#import "SettingViewController.h"
#import "GamerNameTableViewCell.h"

static NSString *const KGamerNameTableViewCell = @"GamerNameTableViewCell";

@interface SettingViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *callBackNames;

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (indexPath.section == 0) {
        GamerNameTableViewCell *nameCell = (GamerNameTableViewCell *)[tableView dequeueReusableCellWithIdentifier:KGamerNameTableViewCell forIndexPath:indexPath];
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

#pragma mark - private methods
- (void)setupTableView {
    [self.tableView registerNib:[UINib nibWithNibName:KGamerNameTableViewCell bundle:nil] forCellReuseIdentifier:KGamerNameTableViewCell];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(didTapDone:)];
}

- (void)didTapDone:(id)sender {
    [self.delegate sendNames:self.callBackNames];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldTextChanged:(UITextField *)textField {
    switch (textField.tag) {
        case 0:
            self.callBackNames[0] = textField.text;
            break;
        case 1:
            self.callBackNames[1] = textField.text;
            break;
        case 2:
            self.callBackNames[2] = textField.text;
            break;
        case 3:
            self.callBackNames[3] = textField.text;
            break;
            
        default:
            break;
    }
}

#pragma mark - getters
- (NSMutableArray *)callBackNames {
    if (!_callBackNames) {
        _callBackNames = [@[@"", @"", @"", @""] mutableCopy];
    }
    return _callBackNames;
}

@end
