//
//  SettingViewController.h
//  MahJongAccount
//
//  Created by yubo liu on 2017/12/14.
//  Copyright © 2017年 yubo liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingViewControllerDelegate

- (void)sendNames:(NSArray *)names;

@end

@interface SettingViewController : UIViewController

@property (nonatomic, weak) id <SettingViewControllerDelegate> delegate;

@end
