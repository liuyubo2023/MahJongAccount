//
//  Stack.m
//  MahJongAccount
//
//  Created by Michael on 18/12/2017.
//  Copyright © 2017 yubo liu. All rights reserved.
//

#import "Stack.h"

@interface Stack ()

@property (nonatomic, strong) NSMutableArray *stackArray;
@property (nonatomic, assign) NSUInteger maxSize;

@end

@implementation Stack

- (instancetype)init {
    self = [super init];
    if (self) {
        _stackArray = [@[] mutableCopy];
    }
    return self;
}

- (instancetype)initWithSize:(NSUInteger)size {
    self = [super init];
    if (self) {
        if (size > 0) {
            _stackArray = [@[] mutableCopy];
            _maxSize = size;
        } else {
            NSAssert(size != 0, @"Stack size must be > 0");
        }
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.stackArray = [aDecoder decodeObjectForKey:@"Stack"];
        self.maxSize = [[aDecoder decodeObjectForKey:@"Size"] integerValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.stackArray forKey:@"Stack"];
    [aCoder encodeObject:@(self.maxSize) forKey:@"Size"];
}

#pragma mark - public
- (void)pop {
    [self.stackArray removeLastObject];
}

- (void)removeFirstObject {
    if (self.stackArray.count > 0) {
        [self.stackArray removeObjectAtIndex:0];
    }
}

- (void)push:(id)object {
    if (self.isFull && self.maxSize) {
        [self removeFirstObject];
    } else {
        if (object != nil) {
            [self.stackArray addObject:object];
        } else {
            NSAssert(object != nil, @"Can't push nil to stack!");
        }
    }
}

- (id)peek {
    if (self.stackArray.count > 0) {
        return [self.stackArray lastObject];
    }
    return nil;
}

- (NSInteger)size {
    return (NSInteger)[self.stackArray count];
}

- (BOOL)isEmpty {
    return [self.stackArray count] == 0;
}

- (void)clear {
    [self.stackArray removeAllObjects];
}

- (NSArray *)allObjects {
    NSMutableArray *buffer = [@[] mutableCopy];
    
    for (id object in self.stackArray) {
        [buffer addObject:object];
    }
    return [buffer copy];
}

- (BOOL)isFull {
    return ([self size] == (NSInteger)self.maxSize) ? YES : NO;
}

@end
