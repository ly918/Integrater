//
//  GNRDBManager.m
//  Integrater
//
//  Created by LvYuan on 2017/3/30.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRDBManager.h"
#import "FMDB.h"
#import "GNRIntegrater.h"

#define k_DB_SPLITE_NAME @"Task.sqlite"

@interface GNRDBManager ()

@property (nonatomic, strong) NSString * dbPath;
@property (nonatomic, strong)FMDatabase * db;

@end

@implementation GNRDBManager

+ (instancetype)manager{
    static GNRDBManager *c = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        c = [[self alloc] init];
    });
    return c;
}

- (instancetype)init{
    if (self = [super init]) {
        [self open];
        [self createTable];
    }
    return self;
}

- (FMDatabase *)db{
    if (!_db) {
        _db = [FMDatabase databaseWithPath:self.dbPath];
    }
    return _db;
}

- (NSString *)dbPath{
    NSString * cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    _dbPath = [cachePath stringByAppendingPathComponent:k_DB_SPLITE_NAME];
    return _dbPath;
}

- (void)open{
    bool ret = [self.db open];
    if (ret) {
        GLog(@"Table opened!");
    }else{
        GLog(@"Table open error!");
    }
}

- (void)createTable{
    if ([self.db tableExists:self.dbPath]) {//已存在
        GLog(@"Table Exists!");
    }else{
        BOOL created = [self.db executeUpdate:@"CREATE TABLE TaskList (Id text, name text, projectDir text, archivePath text, uploadURL text, appkey text, userkey text, createTime text, lastUploadTime text)"];
        if (created) {
            GLog(@"Table created!");
        }else{
            GLog(@"Table create error!");
        }
    }
}

- (void)close{
    bool ret = [self.db close];
    if (ret) {
        GLog(@"Table closed!");
    }else{
        GLog(@"Table close error!");
    }
}

//insert
- (void)insertNewTaskInfo:(GNRTaskInfo *)taskInfo{
    if ([self isEsists:taskInfo.taskName]) {
        return;
    }
    [self open];
    bool insert = [self.db executeUpdate:@"INSERT INTO TaskList (Id , name, projectDir, archivePath, uploadURL, appkey, userkey, createTime, lastUploadTime) VALUES (?,?,?,?,?,?,?,?,?)",taskInfo.taskName,taskInfo.schemeName,taskInfo.projectDir,taskInfo.archivePath,taskInfo.uploadURL,taskInfo.appkey,taskInfo.userkey,taskInfo.createTime,taskInfo.lastUploadTime];
    if (insert) {
        GLog(@"Inserted!");
    }else{
        GLog(@"Insert error!");
    }
    [self close];
}

//delete
- (void)deleteTaskInfo:(GNRTaskInfo *)taskInfo{
    if (![self isEsists:taskInfo.taskName]) {
        return;
    }
    [self open];
    bool delete = [self.db executeUpdate:@"DELETE FROM TaskList where Id like ?",taskInfo.taskName];
    if (delete) {
        GLog(@"Deleted!");
    }else{
        GLog(@"Delete error!");
    }
    [self close];
}


//update
- (void)updateTaskInfo:(GNRTaskInfo *)taskInfo{
    if (![self isEsists:taskInfo.taskName]) {
        return;
    }
    [self open];
    bool update = [self.db executeUpdate:@"UPDATE TaskList SET name = ? , projectDir = ? , archivePath = ? , uploadURL = ? , appkey = ? , userkey = ? , createTime = ? , lastUploadTime = ?  where Id = ?",taskInfo.schemeName,taskInfo.projectDir,taskInfo.archivePath,taskInfo.uploadURL,taskInfo.appkey,taskInfo.userkey,taskInfo.createTime,taskInfo.lastUploadTime,taskInfo.taskName];
    if (update) {
        GLog(@"Updated!");
    }else{
        GLog(@"Update error!");
    }
    [self close];
}

- (NSMutableArray <GNRTaskInfo *>*)taskInfos{
    [self open];
    NSMutableArray * taskInfos = [NSMutableArray array];
    
    FMResultSet * set = [self.db executeQuery:@"SELECT * FROM TaskList"];
    
    while ([set next]) {
        GNRTaskInfo * taskInfo = [[GNRTaskInfo alloc]init];
        NSDictionary * dict = [set resultDictionary];
        [taskInfo setValuesForKeysWithDictionary:dict];
        [taskInfos addObject:taskInfo];
        GLog(@"TaskInfo From DB %@",taskInfo);
    }
    [self close];
    return taskInfos;
}

//是否存在
- (BOOL)isEsists:(NSString *)taskName{
    for (GNRTaskInfo * obj in [self taskInfos]) {
        if ([obj.taskName isEqualToString:taskName]) {
            return YES;
        }
    }
    return NO;
}

@end
