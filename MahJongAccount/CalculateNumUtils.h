//
//  CalculateNumUtils.h
//  MahJongAccount
//
//  Created by yubo liu on 2017/12/11.
//  Copyright © 2017年 yubo liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"

@interface CalculateNumUtils : NSObject

+ (instancetype)sharedManager;

- (NSMutableArray *)calculateWithWinType:(WinType)winType winnerNum:(NSUInteger)winnerNum bankerNum:(NSUInteger)bankerNum;

@end
