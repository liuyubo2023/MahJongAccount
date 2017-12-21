//
//  FileManager.m
//  MahJongAccount
//
//  Created by Michael on 17/12/2017.
//  Copyright © 2017 yubo liu. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

+ (instancetype)defaultManager {
    static FileManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initPrivate];
    });
    return instance;
}

- (id)init {
    return nil;
}

- (instancetype)initPrivate {
    self = [super init];
    return self;
}

- (NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    return documentsDirectory;
}

- (NSString *)dataFilePathWithName:(NSString *)name {
    return [[self documentsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", name]];
}

#pragma mark - public
- (void)saveData:(id)data forKey:(NSString *)key {
    NSMutableData *mutableData = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:mutableData];
    [archiver encodeObject:data forKey:key];
    [archiver finishEncoding];
    [mutableData writeToFile:[self dataFilePathWithName:key] atomically:YES];
}

- (id)loadDataForKey:(NSString *)key {
    NSString *path = [self dataFilePathWithName:key];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        id unarchivedData = [unarchiver decodeObjectForKey:key];
        [unarchiver finishDecoding];
        return unarchivedData;
    }
    return nil;
}

@end
