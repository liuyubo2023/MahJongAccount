//
//  FileManager.h
//  MahJongAccount
//
//  Created by Michael on 17/12/2017.
//  Copyright © 2017 yubo liu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GameModel.h"
#import "Stack.h"

@interface FileManager : NSObject

+ (instancetype)defaultManager;

- (void)saveData:(id)data forKey:(NSString *)key;

- (id)loadDataForKey:(NSString *)key;

@end
