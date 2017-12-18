//
//  Stack.h
//  MahJongAccount
//
//  Created by Michael on 18/12/2017.
//  Copyright © 2017 yubo liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stack : NSObject <NSCoding>

- (instancetype)initWithSize:(NSUInteger)size;

- (id)pop;
- (void)push:(id)object;
- (id)peek;
- (NSInteger)size;
- (BOOL)isEmpty;
- (BOOL)isFull;
- (void)clear;
- (void)removeFirstObject;
- (NSArray *)allObjects;

@end
