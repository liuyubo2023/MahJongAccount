//
//  CalculateNumUtils.m
//  MahJongAccount
//
//  Created by Liuyubo on 2017/12/9.
//  Copyright © 2017年 yubo liu. All rights reserved.
//

#import "CalculateNumUtils.h"
#import "FileManager.h"

static NSString *const kGamesSaving = @"Games";

@interface CalculateNumUtils()

@property (nonatomic, strong) NSMutableArray *totalMutableArray;
@property (nonatomic, strong) NSMutableArray *presentMutableArray;

@end

@implementation CalculateNumUtils

+ (instancetype)sharedManager {
    static CalculateNumUtils *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initPrivate];
    });
    return instance;
}

- (instancetype)init {
    return nil;
}

- (instancetype)initPrivate {
    self = [super init];
    return self;
}

- (NSMutableArray *)calculateWithWinType:(WinType)winType winnerNum:(NSUInteger)winnerNum bankerNum:(NSUInteger)bankerNum {
    NSArray *presentArray = [self presentGameWithWinType:winType winnerNum:winnerNum bankerNum:bankerNum];
    Stack *games = [[FileManager defaultManager] loadDataForKey:kGamesSaving];
    self.totalMutableArray = [[games.peek countArray] mutableCopy];
    for (int i = 0; i < 4; i++) {
        self.totalMutableArray[i] = @([self.totalMutableArray[i] intValue] + [presentArray[i] intValue]);
        self.totalMutableArray[i+4] = presentArray[i];
    }
    return self.totalMutableArray;
}

- (NSArray *)presentGameWithWinType:(WinType)winType winnerNum:(NSUInteger)winnerNum bankerNum:(NSUInteger)bankerNum {
    NSMutableArray *presentArray = [NSMutableArray arrayWithObjects:@0, @0, @0, @0, nil];
    
    int times = winType == winTypeZimo ? 2 : 1;
    
    if (winType == winTypeGang) {
        for (int i = 0; i < 4; i++) {
            if (i == winnerNum) {
                presentArray[i] = @3;
            } else {
                presentArray[i] = @-1;
            }
        }
    } else {
        if (winnerNum == bankerNum) {
            for (int i = 0; i < 4; i++) {
                if (i == bankerNum) {
                    presentArray[i] = @(6 * times);
                } else {
                    presentArray[i] = @(-2 * times);
                }
            }
        } else {
            for (int i = 0; i < 4; i++) {
                if (i == winnerNum) {
                    presentArray[i] = @(4 * times);
                } else if (i == bankerNum){
                    presentArray[i] = @(-2 * times);
                } else {
                    presentArray[i] = @(-1 * times);
                }
            }
        }
    }
    return [presentArray copy];
}

- (NSMutableArray *)totalMutableArray {
    if (!_totalMutableArray) {
        _totalMutableArray = [NSMutableArray arrayWithObjects:@0, @0, @0, @0, @0, @0, @0, @0, nil];
    }
    return _totalMutableArray;
}

@end

