//
//  MJCollectionViewCell.m
//  MahJongAccount
//
//  Created by yubo liu on 2017/12/4.
//  Copyright © 2017年 yubo liu. All rights reserved.
//

#import "MJCollectionViewCell.h"

@implementation MJCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setup];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = 20;
}

- (void)setup {
    self.textField.layer.cornerRadius = 20;
    self.textField.userInteractionEnabled = NO;
}

@end
