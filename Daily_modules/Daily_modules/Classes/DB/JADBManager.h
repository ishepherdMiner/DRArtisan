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


- (JAModel *)selectWithValue:(id)value;
/// 多个的情况下,会取最后一个 [暂时]
- (JAModel *)selectWithValue:(id)value
                       field:(NSString *)field
                relationship:(NSString *)rs;
- (NSArray <JAModel *> *)selectAll;

- (void)deleteWithValue:(id)value;
- (void)deleteWithValue:(id)value
                  field:(NSString *)field
           relationship:(NSString *)rs;

- (void)deleteAll;

@end

/// 测试
/*
 // 创建数据库
 JADBManager *dbMg = [JADBManager sharedDBManager];
 [dbMg open];
 
 // 创建表
 JADBTable *table = [dbMg createTableWithName:@"MSUser" templates:@[
 [MSUserModel class],@{
                        @"profile":[MSProfileModel class],
                        @"bookshelf":@{
                            @"this":[MSBookModel class],
                            @"charters":[MSCharterModel class]
                        }
                     },
 ]];
 
 // NSLog(@"%@",[dbMg allTables]);
 table = [dbMg selectTableWithName:@"MSCharter"];
 
 // 添加数据
 MSCharterModel *cm1 = [[MSCharterModel alloc] init];
 cm1.charterid = @1;
 cm1.charterTitle = @"第1章";
 cm1.pageCount = @"5";
 cm1.content = @"你好好好大沙发沙发撒发大水";
 
 [table insertWithModel:cm1];
 
 MSCharterModel *cm2 = [[MSCharterModel alloc] init];
 cm2.charterid = @2;
 cm2.charterTitle = @"第2章";
 cm2.pageCount = @"5";
 cm2.content = @"你好好好大沙发沙发撒发大水";
 
 [table insertWithModel:cm2];
 
 MSCharterModel *cm3 = [[MSCharterModel alloc] init];
 cm3.charterid = @3;
 cm3.charterTitle = @"第3章";
 cm3.pageCount = @"10";
 cm3.content = @"你好好好大沙发沙发撒发大水dfafdafafafaafdasf";
 [table insertWithModel:cm3];
 
 // NSLog(@"%@",[table selectAll]);
 
 table = [dbMg selectTableWithName:@"MSBook"];
 
 MSBookModel *b1 = [[MSBookModel alloc] init];
 b1.bookid = @1;
 b1.bookname = @"哈姆雷特";
 b1.charters = @[cm1,cm2,cm3];
 
 [table insertWithModel:b1];
 NSLog(@"%@",[table selectAll]);
 
 table = [dbMg selectTableWithName:@"MSProfile"];
 
 MSProfileModel *p1 = [[MSProfileModel alloc] init];
 p1.profileid = @1;
 p1.username = @"wdl";
 
 [table insertWithModel:p1];
 
 table = [dbMg selectTableWithName:@"MSUser"];
 
 MSUserModel *u1 = [[MSUserModel alloc] init];
 u1.userid = @1;
 u1.profile = p1;
 u1.bookshelf = @[b1];
 
 [table insertWithModel:u1];
 */
///

@interface JADBManager : NSObject

+ (instancetype)sharedDBManager;

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


- (JADBTable *)selectTableWithName:(NSString *)tableName;

/// 所有的表名
- (NSArray *)allTables;

- (void)deleteTable;
- (void)deleteTableWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
