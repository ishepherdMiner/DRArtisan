//
//  JADBManager.m
//  AntRecord
//
//  Created by Jason on 09/06/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "JADBManager.h"
#import "JAModel.h"
#import "JACategory.h"
#import "JAConfigure.h"
#import <objc/message.h>
#import <FMDB.h>

@interface JADBTable ()

@property (nonatomic,weak) Class cls;
@property (nonatomic,strong) NSArray *fields;
@property (nonatomic,strong) NSDictionary *fieldValues;
@property (nonatomic,strong) NSMutableDictionary <NSString *,JADBTable *> *innerTables;
@property (nonatomic,strong) NSArray <Class> *innerClasses;

///
@property (nonatomic,copy) NSString *tableName;
@property (nonatomic,strong) FMDatabaseQueue *dbQueue;
@property (nonatomic,strong) NSDictionary *fieldsTypePair;
@property (nonatomic,strong) Class template;
@property (nonatomic,strong) NSMutableArray <Class> *hostingTemplates;
@property (nonatomic,strong) NSMutableDictionary <NSString *,JADBTable *> *hostingTables;

@end

@implementation JADBTable

- (instancetype)initWithDb:(FMDatabaseQueue *)dbQueue
                 tableName:(NSString *)tableName
                 templates:(NSArray <Class>*)templates{
    
    if (self = [super init]) {
        self.dbQueue = dbQueue;
        self.tableName = tableName;
        NSMutableString *sql = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (",self.tableName];
        if ([templates.firstObject isSubclassOfClass:[NSString class]]) {
            /// 关联表
            for (int i = 0; i < templates.count; ++i) {
                NSString *k = (NSString *)templates[i];
                [sql appendString:k];
                [sql appendString:@" TEXT"];
                if (i != (templates.count - 1)) {
                    [sql appendString:@","];
                }
            }
        }else {
            self.template = templates[0];
            self.fieldsTypePair = [[[self.template alloc] init] ja_propertyAndEncodeTypeList:false];
            self.hostingTemplates = [NSMutableArray arrayWithArray:templates];
            [self.hostingTemplates removeObjectAtIndex:0];
            if (self.hostingTables == nil) {
                self.hostingTables = [NSMutableDictionary dictionary];
            }
            
            NSMutableString *sql = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (",self.tableName];
            NSArray *allKeys = self.fieldsTypePair.allKeys;
            for (int i = 0; i < allKeys.count; ++i) {
                NSString *k = allKeys[i];
                [sql appendString:k];
                
                /// 数据类型 => 数据库字段
                /// 主键
                if ([[_template pK] isEqualToString:k]) {
                    [sql appendString:@" INTEGER PRIMARY KEY NOT NULL"];
                }else {
                    NSString *v = [_fieldsTypePair objectForKey:k];
                    
                    if ([v isEqualToString:@"NSString"]) {
                        
                        /// 当属性为字符串时
                        [sql appendString:@" TEXT"];
                        
                    }else if ([v isEqualToString:@"NSNumber"]) {
                        
                        /// 当属性为整形时
                        [sql appendString:@" INTEGER"];
                        
                    }else if ([v rangeOfString:@"Model"].location != NSNotFound) {
                        
                        /// 当属性为模型对象时,
                        /// 创建对应的子表
                        /// 主表: 包含该属性的表,即当前的表
                        /// 子表: 由该属性生成的表 名称为 前缀 + 属性名(首字母大写)
                        /// 策略:
                        /// !important 主表中该属性保存了在子表的主键值,用于在查找时对模型属性进行赋值
                        NSString *sonTableName = [NSString stringWithFormat:@"%@%@",[JAConfigure sharedCf].prefix ? [JAConfigure sharedCf].prefix : @"",[k capitalizedString]];
                        
                        JADBTable *sonTable = [[JADBTable alloc] initWithDb:_dbQueue
                                                                  tableName:sonTableName
                                                                  templates:@[v.class]];
                        
                        [_hostingTables setObject:sonTable forKey:sonTableName];
                        
                        /// 创建关联表
                        NSString *relateTableName = [NSString stringWithFormat:@"%@_RELATE_%@",_tableName,[k capitalizedString]];
                        NSString *parentPk = [_template primaryKey];
                        NSString *sonPk = [NSClassFromString(v) primaryKey];
                        
                        JADBTable *relateTable = [[JADBTable alloc] initWithDb:_dbQueue
                                                                     tableName:relateTableName
                                                                     templates:@[parentPk,sonPk]];
                        
                        [_hostingTables setObject:relateTable forKey:relateTableName];
                        
                        [sql appendString:@" TEXT"];
                        
                    }else if ([v isEqualToString:@"NSArray"]) {
                        
                        /// 当属性为数组时
                        for (int i = 0; i < _hostingTemplates.count; ++i) {
                            
                            NSString *hostTableName = [NSString stringWithFormat:@"%@%@",[JAConfigure sharedCf].prefix,[k capitalizedString]];
                            
                            JADBTable *hostTable = [[JADBTable alloc] initWithDb:_dbQueue
                                                                       tableName:hostTableName
                                                                       templates:@[_hostingTemplates[i]]];
                            
                            [_hostingTables setObject:hostTable forKey:hostTableName];
                            
                            /// 创建关联表
                            NSString *relateTableName = [NSString stringWithFormat:@"%@_RELATE_%@",_tableName,[k capitalizedString]];
                            NSString *parentPk = [_template primaryKey];
                            NSString *sonPk = [NSClassFromString(v) primaryKey];
                            
                            JADBTable *relateTable = [[JADBTable alloc] initWithDb:_dbQueue
                                                                         tableName:relateTableName
                                                                         templates:@[parentPk,sonPk]];
                            
                            [_hostingTables setObject:relateTable forKey:relateTableName];
                            
                            [sql appendString:@" TEXT"];
                        }
                        
                    }else if ([v isEqualToString:@"NSDictionary"]) {
                        
                        /// 当属性为字典时 --
                    }
                }
                
                if (i != (allKeys.count - 1)) {
                    [sql appendString:@","];
                }
            }
        }
        
        [sql appendString:@")"];
        

        [self executeUpateWithSql:sql okLog:@"[JA]:表创建成功" failLog:@"[JA]:表创建失败"];
    }
    return self;
}

- (void)executeUpateWithSql:(NSString *)sql
                      okLog:(NSString *)okLog
                    failLog:(NSString *)failLog {
    
#if DEBUG
    NSLog(@"%@",sql);
#endif
    
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        BOOL r = [db executeUpdate:sql];
        if(r) {
            NSLog(@"%@",okLog);
        }else {
            NSLog(@"%@",failLog);
            *rollback = true;
            return ;
        }
    }];
}
// ---

- (void)insertWithModel:(JAModel *)model {
    
    NSMutableString *sql = [NSMutableString stringWithString:[NSString stringWithFormat:@"INSERT INTO %@ (",self.tableName]];
    
    NSUInteger count = self.fields.count;
    NSMutableArray *property = [NSMutableArray arrayWithCapacity:2];
    for (NSString *key in self.fields) {
        [sql appendString:key];
        if (--count > 0) {
            [sql appendString:@","];
        }
        [property addObject:key];
    }
    [sql appendString:@")"];
    [sql appendString:@" VALUES("];
    count = self.fields.count;
    for (NSString *key in property) {
        [sql appendString:@"'"];
        if ([[self.fieldValues objectForKey:key] isEqualToString:@"NSString"]) {
            if ([model valueForKeyPath:key]) {
                [sql appendString:[model valueForKeyPath:key]];
            }else {
                [sql appendString:@""];
            }
        }else if([[self.fieldValues objectForKey:key] isEqualToString:@"NSNumber"]) {
            [sql appendString:[[model valueForKeyPath:key] stringValue]];
        }else if([[self.fieldValues objectForKey:key] isEqualToString:@"NSArray"]) {
            // 在关联表中添加相关的记录
            NSString *relateTName = [NSString stringWithFormat:@"%@_JOIN_%@",self.tableName,[key capitalizedString]];
            NSString *subTName = [NSString stringWithFormat:@"%@%@",[JAConfigure sharedCf].prefix ? [JAConfigure sharedCf].prefix : @"",[key capitalizedString]];
            JADBTable *innerTModel = [self.innerTables objectForKey:subTName];
            
            // 预先查询子表中是否存在对应的记录，如果没有，关联表不能插入，直接断言就好了
            NSArray *subTableRecords = [model valueForKeyPath:key];
            for (int i = 0; i < subTableRecords.count; ++i) {
                NSString *primaryKey = [[subTableRecords[i] class] primaryKey];
                JAModel *innerModel = [innerTModel selectWithField:primaryKey
                                                 relationship:@"="
                                                        value:[(id)subTableRecords[i] valueForKeyPath:primaryKey]name:subTName];
                NSAssert(innerModel, @"[JA]:无法添加,因为子表中没有对应的记录");
                
                JADBTable *relateTModel = [self.innerTables objectForKey:relateTName];                
                [relateTModel insertWithTableName:relateTName propertiesDic:@{
                                                                        [model.class primaryKey]:
                                                                            [model valueForKeyPath:[model.class primaryKey]],
                                                                        [innerModel.class primaryKey]:
                                                                            [innerModel valueForKeyPath:[innerModel.class primaryKey]]
                                                                        }];
                
                NSString *innerPkeys = [NSString stringWithFormat:@"%@",[innerModel valueForKeyPath:primaryKey]];
                [sql appendString:innerPkeys];
                
                if (i != (subTableRecords.count - 1)) {
                    [sql appendString:@","];
                }
            }
        }
        [sql appendString:@"'"];
        if (--count >0) {
            [sql appendString:@","];
        }
    }
    [sql appendString:@")"];
    NSLog(@"[JA]:%@",[NSString stringWithFormat:@"%@",sql]);
    
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
       
        BOOL r = [db executeUpdate:sql];
        if (r) {
            NSLog(@"[JA]:数据插入成功");
        }else {
            NSLog(@"[JA]:数据插入失败");
            *rollback = true;
            return ;
        }
        
    }];
}

- (void)insertWithTableName:(NSString *)name
              propertiesDic:(NSDictionary <NSString *,id> *)propertiesDic {
    
    NSMutableString *sql = [NSMutableString stringWithString:@"INSERT INTO "];
    [sql appendString:name ? name : self.tableName];
    [sql appendString:@"("];
    
    NSUInteger count = [propertiesDic allKeys].count;
    NSMutableArray *property = [NSMutableArray arrayWithCapacity:count];
    NSArray *properties = [propertiesDic allKeys];
    for (NSString *key in properties) {
        [sql appendString:key];
        if (--count > 0) {
            [sql appendString:@","];
        }
        [property addObject:key];
    }
    [sql appendString:@")"];
    [sql appendString:@" VALUES("];
    count = [propertiesDic allKeys].count;
    for (NSString *key in properties) {
        [sql appendString:@"'"];
        id property = [propertiesDic objectForKey:key];
        if ([property isKindOfClass:[NSNumber class]]) {
            [sql appendString:[(NSNumber *)property stringValue]];
        }else {
            [sql appendString:property];
        }
        [sql appendString:@"'"];
        if (--count >0) {
            [sql appendString:@","];
        }
    }
    
    [sql appendString:@")"];
    NSLog(@"[JA]:%@",[NSString stringWithFormat:@"%@",sql]);
    
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        BOOL r = [db executeUpdate:sql];
        if (r) {
            NSLog(@"[JA]:数据插入成功");
        }else {
            NSLog(@"[JA]:数据插入失败");
            *rollback = true;
            return ;
        }
        
    }];
}

- (void)updateWithModel:(JAModel *)model {
    NSMutableString *sql = [NSMutableString stringWithString:@"UPDATE "];
    [sql appendString:self.tableName];
    [sql appendString:@" SET "];
    NSUInteger count = self.fields.count;
    for (NSString *key in self.fields) {
        if (![key isEqualToString:[model.class primaryKey]]) {
            [sql appendString:key];
            [sql appendString:@" = '"];
            if ([[model valueForKeyPath:key] isKindOfClass:[NSNumber class]]) {
                
            }else if ([[model valueForKeyPath:key] isKindOfClass:[NSString class]]){
                [sql appendString:[model valueForKeyPath:key]];
                [sql appendString:@"'"];
            }
            
            // 排除主键
            if (--count > 1) {
                [sql appendString:@","];
            }
        }
    }
    [sql appendString:@" WHERE "];
    [sql appendString:[model.class primaryKey]];
    [sql appendString:@" = "];
    if ([[model valueForKeyPath:[model.class primaryKey]] isKindOfClass:[NSNumber class]]) {
        NSNumber *n = [model valueForKeyPath:[model.class primaryKey]];
        [sql appendString:n.stringValue];
    }    
    
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
       
        BOOL r = [db executeUpdate:sql];
        if (r) {
            NSLog(@"[JA]:数据更新成功");
        }else {
            NSLog(@"[JA]:数据更新失败");
            *rollback = true;
            return ;
        }
    }];
}

- (JAModel *)selectWithValue:(NSString *)value {
    return [self selectWithField:[self.cls primaryKey]
                    relationship:@"="
                           value:value];
}

- (JAModel *)selectWithField:(NSString *)field
                relationship:(NSString *)rs
                       value:(id)value {
    
    return [self selectWithField:field
                    relationship:rs
                           value:value
                            name:self.tableName];
}

- (JAModel *)selectWithField:(NSString *)field
                relationship:(NSString *)rs
                       value:(id)value
                        name:(NSString *)name{
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ %@ '%@'",name,field,rs,value];
    
    NSLog(@"[JA]:%@",[NSString stringWithFormat:@"%@",sql]);
    __block JAModel *m = nil;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            m = [[self.cls alloc] init];
            for (NSString *k in self.fields) {
                if ([[self.fieldValues objectForKey:k] isEqualToString:@"NSString"]) {
                    [m setValue:[rs stringForColumn:k] forKey:k];
                }else if ([[self.fieldValues objectForKey:k] isEqualToString:@"NSNumber"]) {
                    [m setValue:@([[rs stringForColumn:k] doubleValue]) forKey:k];
                }
            }
        }
    }];
    
    return m;
}

- (NSArray <JAModel *> *)selectAll {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",self.tableName];
    NSMutableArray *models = [NSMutableArray array];
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            JAModel *m = [[self.cls alloc] init];
            for (NSString *k in self.fields) {
                if ([[self.fieldValues objectForKey:k] isEqualToString:@"NSString"]) {
                    [m setValue:[rs stringForColumn:k] forKey:k];
                }else if ([[self.fieldValues objectForKey:k] isEqualToString:@"NSNumber"]) {
                    [m setValue:@([[rs stringForColumn:k] doubleValue]) forKey:k];
                }else if ([[self.fieldValues objectForKey:k] isEqualToString:@"NSArray"]) {
                    // 子表中读取模型进行赋值
                    NSArray *records = [[rs stringForColumn:k] componentsSeparatedByString:@","];
                    NSString *keyOfTableName = [NSString stringWithFormat:@"%@%@",[JAConfigure sharedCf].prefix ? [JAConfigure sharedCf].prefix : @"",[k capitalizedString]];
                    JADBTable *t = [self.innerTables objectForKey:keyOfTableName];
                    NSMutableArray *imm = [NSMutableArray arrayWithCapacity:records.count];
                    for (int i = 0; i < records.count; ++i) {
                        JAModel *im = [t selectWithField:[t.cls primaryKey] relationship:@"=" value:records[i]];
                        [imm addObject:im];
                    }
                    [m setValue:[imm copy] forKey:k];
                }else if ([[self.fieldValues objectForKey:k] rangeOfString:@"Model"].location != NSNotFound) {
                    
                }
            }
            [models addObject:m];
        }
    }];
    
    return [models copy];
}

- (void)deleteWithValue:(NSString *)value {
    [self deleteWithField:[self.cls primaryKey]
             relationship:@"="
                    value:value];    
}

- (void)deleteWithField:(NSString *)field
           relationship:(NSString *)rs
                  value:(id)value {
    
    NSString *sql = [NSString stringWithFormat:@"DELETE  FROM %@ WHERE %@ %@ '%@'",self.tableName,field,rs,value];
    
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
       
        BOOL r = [db executeUpdate:sql];
        if (r) {
            NSLog(@"[JA]:数据删除成功");
        }else {
            NSLog(@"[JA]:数据删除失败");
            *rollback = true;
            return ;
        }
        
    }];
}

- (void)deleteAll {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@",self.tableName];
    
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        BOOL r = [db executeUpdate:sql];
        if (r) {
            NSLog(@"[JA]:数据删除成功");
        }else {
            NSLog(@"[JA]:数据删除失败");
            *rollback = true;
            return ;
        }
        
    }];
}

- (NSMutableDictionary<NSString *,JADBTable *> *)innerTables {
    if (_innerTables == nil) {
        _innerTables = [NSMutableDictionary dictionary];
    }
    return _innerTables;
}


+ (instancetype)tableWithDb:(FMDatabaseQueue *)dbQueue
                       name:(NSString *)name
              templateClass:(Class)cls
         templateInnerClass:(NSArray <Class>*)innerClasses{
    
    JADBTable *m = [[JADBTable alloc] init];
    m.dbQueue = dbQueue;
    m.cls = cls;
    m.tableName = name;
    m.fieldValues = [[[cls alloc] init] ja_propertyAndEncodeTypeList:false];
    m.fields = [m.fieldValues allKeys];
    
    NSMutableString *sql = [NSMutableString stringWithString:@"CREATE TABLE IF NOT EXISTS "];
    [sql appendString:name];
    [sql appendString:@"("];
    
    NSUInteger count = m.fields.count;
    for (NSString *key in m.fields) {
        [sql appendString:key];
        if ([[m.cls primaryKey] isEqualToString:key]) {
            [sql appendString:@" INTEGER PRIMARY KEY NOT NULL"];
        }else if ([[m.fieldValues objectForKey:key] isEqualToString:@"NSString"]) {
            [sql appendString:@" TEXT"];
        }else if ([[m.fieldValues objectForKey:key] isEqualToString:@"NSNumber"]) {
            [sql appendString:@" INTEGER"];
        }else if ([[m.fieldValues objectForKey:key] rangeOfString:@"Model"].location != NSNotFound) {
            //
            NSString *innerTName = [NSString stringWithFormat:@"%@%@",[JAConfigure sharedCf].prefix ? [JAConfigure sharedCf].prefix : @"",[key capitalizedString]];
            JADBTable *innerModel = [JADBTable tableWithDb:m.dbQueue
                                                      name:innerTName
                                             templateClass:NSClassFromString([m.fieldValues objectForKey:key])
                                        templateInnerClass:nil];
            
            [m.innerTables setObject:innerModel forKey:innerTName];
            
            NSString *innerJoinTName = [NSString stringWithFormat:@"%@_JOIN_%@",name,[key capitalizedString]];
            NSString *outerPrimaryKey = [NSString stringWithFormat:@"%@",[cls primaryKey]];
            NSString *innerPrimaryKey = [NSString stringWithFormat:@"%@",[NSClassFromString([m.fieldValues objectForKey:key]) primaryKey]];
            
            JADBTable *joinModel = [self tableWithDb:m.dbQueue
                                                name:innerJoinTName
                                          properties:@[outerPrimaryKey,innerPrimaryKey]];
            
            [m.innerTables setObject:joinModel forKey:innerJoinTName];
            
            
        }
        
        if (--count > 0) {
            [sql appendString:@","];
        }
        
        if ([[m.fieldValues objectForKey:key] isEqualToString:@"NSArray"]) {
            
            for (int i = 0; i < innerClasses.count; ++i) {
                /// 创建依赖的子表
                /// 一般模型生成的表都会有主键，关联表可以没有主键
                if (![innerClasses[i] isKindOfClass:[NSArray class]]) {
                    NSString *innerTName = [NSString stringWithFormat:@"%@%@",[JAConfigure sharedCf].prefix ? [JAConfigure sharedCf].prefix : @"",[key capitalizedString]];
                    JADBTable *innerModel = [JADBTable tableWithDb:m.dbQueue
                                                              name:innerTName
                                                     templateClass:innerClasses[i]
                                                templateInnerClass:nil];
                    
                    [m.innerTables setObject:innerModel forKey:innerTName];
                    
                    NSString *innerJoinTName = [NSString stringWithFormat:@"%@_JOIN_%@",name,[key capitalizedString]];
                    NSString *outerPrimaryKey = [NSString stringWithFormat:@"%@",[cls primaryKey]];
                    NSString *innerPrimaryKey = [NSString stringWithFormat:@"%@",[innerClasses[i] primaryKey]];
                    
                    JADBTable *joinModel = [self tableWithDb:m.dbQueue
                                                        name:innerJoinTName
                                                  properties:@[outerPrimaryKey,innerPrimaryKey]];
                    
                    [m.innerTables setObject:joinModel forKey:innerJoinTName];
                }
            }
        }
    }
    [sql appendString:@")"];
    
    NSLog(@"[JA]:%@",sql);
    
    [m.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        BOOL r = [db executeUpdate:sql];
        if(r) {
            NSLog(@"[JA]:表创建成功");
        }else {
            NSLog(@"[JA]:表创建失败");
            *rollback = true;
            return ;
        }
    }];
    return m;
}

+ (instancetype)tableWithDb:(FMDatabaseQueue *)dbQueue
                       name:(NSString *)tName
                 properties:(NSArray *)propertys {
    
    JADBTable *m = [[JADBTable alloc] init];
    NSMutableString *sql = [NSMutableString stringWithString:@"CREATE TABLE IF NOT EXISTS "];
    [sql appendString:tName];
    [sql appendString:@"("];
    NSUInteger count = propertys.count;
    for (int i = 0; i < propertys.count; ++i) {
        [sql appendString:propertys[i]];
        if (--count > 0) {
            [sql appendString:@","];
        }
    }
    
    [sql appendString:@")"];
    NSLog(@"[JA]:%@",sql);
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        BOOL r = [db executeUpdate:sql];
        if(r) {
            NSLog(@"[JA]:表创建成功");
        }else {
            NSLog(@"[JA]:表创建失败");
            *rollback = true;
            return ;
        }
    }];
    
    return m;
}

@end

@interface JADBManager ()

@property (nonatomic,copy) NSString *curTableName;
@property (nonatomic,copy) NSString *curDbPath;

@property (nonatomic,strong) FMDatabaseQueue *dbQueue;
@property (nonatomic,strong) NSMutableDictionary <NSString *,JADBTable *> *tables;

@end

@implementation JADBManager

+ (instancetype)sharedDBManager {
    static id instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

#pragma mark - 数据库操作
- (instancetype)open {
    return [self openWithDbPath:nil];
}
- (instancetype)openWithDbName:(NSString *)dbName {
    return [self openWithDbPath:dbName];
}

- (instancetype)openWithDbPath:(nullable NSString *)dbPath {
    NSString *path = nil;
    if (_dbQueue == nil) {        
        if (dbPath == nil) {
            NSString *executable = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
            NSString *dbDirectory = [[NSFileManager defaultManager] createDirectoryAtDocumentWithName:executable];
            path = [NSString stringWithFormat:@"%@/%@.sqlite",dbDirectory,executable];
        }else if ([dbPath rangeOfString:@"/"].location != NSNotFound){
            path = dbPath;
        }else {
            NSString *executable = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
            NSString *dbDirectory = [[NSFileManager defaultManager] createDirectoryAtDocumentWithName:executable];
            path = [NSString stringWithFormat:@"%@/%@.sqlite",dbDirectory,dbPath];
        }
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
        _curDbPath = path;        
    }
    
    return self;
}

- (void)close {
    if (_dbQueue == nil) {
        NSLog(@"[JA]:请先调用open:打开数据库");
    }else {
        [_dbQueue close];
    }
}

#pragma mark - 表

- (JADBTable *)createTableWithName:(NSString *)tableName
                         templates:(NSArray <Class> *)templates {
    
    JADBTable *table = [[JADBTable alloc] initWithDb:self.dbQueue
                                           tableName:tableName
                                           templates:templates];
    
    [self.tables setObject:table forKey:tableName];
    [table.hostingTables enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, JADBTable * _Nonnull obj, BOOL * _Nonnull stop) {
        [self.tables setObject:obj forKey:key];
    }];
    return table;
}

- (void)deleteTable {
    NSString *sql = [NSString stringWithFormat:@" DROP TABLE %@",self.curTableName];
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL r = [db executeUpdate:sql];
        if (r) {
            NSLog(@"[JA]:%@表被成功删除",self.curTableName);
        }else {
            NSLog(@"[JA]:数据删除失败");
            *rollback = true;
            return ;
        }
    }];
}

- (void)deleteTableWithName:(NSString *)name {
    NSString *sql = [NSString stringWithFormat:@" DROP TABLE %@",name];
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL r = [db executeUpdate:sql];
        if (r) {
            NSLog(@"[JA]:%@表被成功删除",name);
        }else {
            NSLog(@"[JA]:数据删除失败");
            *rollback = true;
            return ;
        }
    }];
}

@end
