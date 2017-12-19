//
//  MJAlertUtils.h
//  MahJongAccount
//
//  Created by yubo liu on 2017/12/19.
//  Copyright © 2017年 yubo liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJAlertUtils : NSObject

/**
 *  模式对话框，选择一项
 *
 *  @param title      标题
 *  @param message    提示内容
 *  @param arrayItems 按钮数组，“取消按钮” 请放第一个，系统显示有默认效果,example:@[@"取消",@"确认1",@"确认2",@"确认3",@"确认4",@"确认5",@"确认6"]
 *  @param block      点击事件，返回按钮顺序
 */
+ (void)showAlertWithTitle:(NSString*)title
                       msg:(NSString*)message
          buttonsStatement:(NSArray<NSString*>*)arrayItems
               chooseBlock:(void (^)(NSInteger buttonIdx))block;

@end
