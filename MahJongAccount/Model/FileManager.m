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
//    if (self) {
//        [self loadGames];
//    }
    return self;
}

- (NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    return documentsDirectory;
}

- (NSString *)dataFilePath {
    return [[self documentsDirectory] stringByAppendingPathComponent:@"Games.plist"];
}

- (NSString *)nameFilePath {
    return [[self documentsDirectory] stringByAppendingPathComponent:@"Names.plist"];
}

- (void)saveGame {
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self.games forKey:@"Games"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

- (void)loadGames {
    NSString *path = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        self.games = [unarchiver decodeObjectForKey:@"Games"];
        [unarchiver finishDecoding];
    } else {
        self.games = [[Stack alloc] initWithSize:10];
    }
}

- (void)saveNames:(NSArray<NSString *> *)namesArray {
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:namesArray forKey:@"Names"];
    [archiver finishEncoding];
    [data writeToFile:[self nameFilePath] atomically:YES];
}

- (NSArray<NSString *> *)loadNames {
    NSString *path = [self nameFilePath];
    NSArray *namesArray = [NSArray array];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        namesArray = [unarchiver decodeObjectForKey:@"Names"];
        [unarchiver finishDecoding];
    } else {
        namesArray = @[@"姓",@"姓",@"姓",@"姓"];
    }
    return namesArray;
}

@end
