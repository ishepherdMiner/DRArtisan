//
//  JADBManager.h
//  AntRecord
//
//  Created by Jason on 09/06/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "JAModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JADBTable : JAModel

- (void)insertWithModel:(JAModel *)model;
- (void)updateWithModel:(JAModel *)model;
- (JAModel *)selectWithValue:(NSString *)value;
- (void)deleteWithValue:(NSString *)value;

/// 多个的情况下,会取最后一个 [暂时]
- (JAModel *)selectWithField:(NSString *)field
                relationship:(NSString *)rs
                       value:(id)value;

- (void)deleteWithField:(NSString *)field
           relationship:(NSString *)rs
                  value:(id)value;

- (NSArray <JAModel *> *)selectAll;
- (void)deleteAll;

@end

@interface JADBManager : NSObject

+ (instancetype)sharedDBManager;

/// 测试
/*
 // [JAConfigure sharedCf].prefix = @"MS";
 //
 // 创建数据库
 // JADBManager *dbMg = [JADBManager sharedDBManager];
 //
 // 方式1: 默认方式
 // [dbMg open];
 //
 // 方式2: 数据库名
 // [[JADBManager sharedDBManager] openWithDbName:@"LSY"];
 //
 // 方式3: 数据库全路径
 // NSString *executable = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
 // NSString *dbDirectory = [[NSFileManager defaultManager] createDirectoryAtDocumentWithName:executable];
 // NSString *path = [NSString stringWithFormat:@"%@/%@.sqlite",dbDirectory,executable];
 // [[JADBManager sharedDBManager] openWithDbPath:path];
 //
 // 关闭数据库
 // [[JADBManager sharedDBManager] close];
 //
 // 存在依赖时，表名要求是依赖表的属性名
 // JADBTable *table = [dbMg createTableWithName:@"MSCharters" modelClass:[MSCharterModel class]];
 //
 // MSCharterModel *m = [[MSCharterModel alloc] init];
 // m.charterid = @1;
 // m.charterTitle = @"标题";
 // m.pageCount = @"3";
 // m.content = @"123 432";
 // [table insertWithModel:m];
 //
 // MSCharterModel *m2 = [[MSCharterModel alloc] init];
 // m2.charterid = @2;
 // m2.charterTitle = @"标题";
 // m2.pageCount = @"3";
 // m2.content = @"123 432";
 // [table insertWithModel:m2];
 //
 // JADBTable *table2 = [dbMg createTableWithName:@"MSBookModel"
 //                                    modelClass:[MSBookModel class]
 //                             innerModelClasses:@[[MSCharterModel class]]];
 //
 // MSBookModel *b = [[MSBookModel alloc] init];
 // b.bookid = @1;
 // b.bookname = @"哈姆雷特";
 // b.charters = @[m,m2];
 //
 // [table2 insertWithModel:b];
 // NSArray *bs = [table2 selectAll];
 // NSLog(@"%@",bs);

 // 需要预先建立好所有的数据库结构
 // 
 // [dbMg deleteTable];
 // [table selectAll];
 */
///

/**
 创建 || 连接 数据库

 默认在沙盒的docuemnt下,创建名为可执行文件字段的文件夹，数据库名称为:可执行文件.sqlite
 比如工程名为MStarReader，则会在document下创建名为 MStarReader 的文件夹，同时在该文件夹下，创建名为 MStarReader.sqlite 的数据库
 
 @return 数据库对象
 */
- (instancetype)open;

/**
 数据库名 创建 || 连接 数据库
 
 @param dbName 数据库名
 @return 数据库对象
 */
- (instancetype)openWithDbName:(NSString *)dbName;

/**
 数据库全路径 创建 || 连接 数据库

 @param dbPath 数据库全路径
 @return 数据库对象
 */
- (instancetype)openWithDbPath:(nullable NSString *)dbPath;
/// 关闭数据库
- (void)close;

/**
 创建/选择数据表
 
 @param tableName 表名
 @param templates 绑定的模型
 @return 表对象
 */

- (JADBTable *)createTableWithName:(NSString *)tableName
                         templates:(NSArray <Class> *)templates;

- (void)deleteTable;
- (void)deleteTableWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
