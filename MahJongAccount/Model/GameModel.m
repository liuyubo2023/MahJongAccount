//
//  GameModel.m
//  MahJongAccount
//
//  Created by Michael on 18/12/2017.
//  Copyright © 2017 yubo liu. All rights reserved.
//

#import "GameModel.h"

@implementation GameModel

- (id)init {
    self = [super init];
    if (self) {
        self.countArray = [[NSMutableArray alloc] initWithCapacity:8];
        self.bankerCount = 0;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.countArray = [aDecoder decodeObjectForKey:@"CountArray"];
        self.bankerCount = [[aDecoder decodeObjectForKey:@"BankerCount"] integerValue];;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.countArray forKey:@"CountArray"];
    [aCoder encodeObject:@(self.bankerCount) forKey:@"BankerCount"];
}

@end
