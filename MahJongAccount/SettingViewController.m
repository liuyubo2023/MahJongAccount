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

@interface SettingViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
}

@end
