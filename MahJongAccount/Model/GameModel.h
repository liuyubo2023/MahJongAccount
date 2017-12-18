//
//  GameModel.h
//  MahJongAccount
//
//  Created by Michael on 18/12/2017.
//  Copyright © 2017 yubo liu. All rights reserved.
//

#import <Foundation/Foundation.h>

// 这个model定义了主页面的数据结构
@interface GameModel : NSObject

@property (nonatomic, strong) NSMutableArray *countArray;
@property (nonatomic, assign) NSInteger bankerCount;

@end
