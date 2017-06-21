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

@property (nonatomic,copy) NSString *tableName;
@property (nonatomic,strong) FMDatabaseQueue *dbQueue;
@property (nonatomic,strong) NSDictionary *fieldsTypePair;
@property (nonatomic,strong) Class template;
@property (nonatomic,strong) NSMutableDictionary *hostingTemplates;
@property (nonatomic,strong) NSMutableDictionary <NSString *,JADBTable *> *hostingTables;

@end

@implementation JADBTable

- (instancetype)initWithDb:(FMDatabaseQueue *)dbQueue
                 tableName:(NSString *)tableName
                 templates:(NSArray *)templates{
    
    if (self = [super init]) {
        self.dbQueue = dbQueue;
        self.tableName = tableName;
        NSMutableString *sql = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (",self.tableName];
        if ([[templates[0] class] isSubclassOfClass:[NSString class]]) {
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
            if (templates.count == 2) {
                self.hostingTemplates = templates.lastObject;
            }
            
            if (self.hostingTables == nil) {
                self.hostingTables = [NSMutableDictionary dictionary];
            }

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
                        /// !important 主表中该属性保存了在子表的主键值,用于在查找时对模型属性进行赋值，其实就是外键
                        /// 暂未实现
                        id kTemplate = [_hostingTemplates objectForKey:k];
                        NSMutableDictionary *kHostTemplates = [NSMutableDictionary dictionary];
                        // 模型属性嵌套模型
                        if ([kTemplate isKindOfClass:[NSDictionary class]]) {
                            kTemplate = [[_hostingTemplates objectForKey:k] objectForKey:@"this"];
                            [[_hostingTemplates objectForKey:k] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                                if (![key isEqualToString:@"this"]) {
                                    [kHostTemplates setObject:obj forKey:key];
                                }
                            }];
                        }
                        
                        NSString *kTableName = NSStringFromClass(kTemplate);
                        if ([[kTableName substringFromIndex:kTableName.length - 5] isEqualToString:@"Model"]) {
                            // 去掉结尾的model
                            kTableName = [kTableName substringToIndex:kTableName.length - 5];
                        }
                        
                        NSString *sonTableName = [NSString stringWithFormat:@"%@",kTableName];
                        
                        NSArray *kTemplates = nil;
                        if (kHostTemplates.count == 0) {
                            kTemplates = @[kTemplate];
                        }else {
                            kTemplates = @[kTemplate,kHostTemplates];
                        }
                        
                        JADBTable *sonTable = [[JADBTable alloc] initWithDb:_dbQueue
                                                                  tableName:sonTableName
                                                                  templates:kTemplates];
                        
                        [_hostingTables setObject:sonTable forKey:sonTableName];
                        
                        /// 创建关联表
                        NSString *relateTableName = [NSString stringWithFormat:@"%@_RELATE_%@",_tableName,kTableName];
                        NSString *parentPk = [_template pK];
                        NSString *sonPk = [NSClassFromString(v) pK];
                        
                        JADBTable *relateTable = [[JADBTable alloc] initWithDb:_dbQueue
                                                                     tableName:relateTableName
                                                                     templates:@[parentPk,sonPk]];
                        
                        [_hostingTables setObject:relateTable forKey:relateTableName];
                        
                        [sql appendString:@" TEXT"];
                        
                    }else if ([v isEqualToString:@"NSArray"]) {
                        
                        id kTemplate = [_hostingTemplates objectForKey:k];
                        NSMutableDictionary *kHostTemplates = [NSMutableDictionary dictionary];
                        // NSLog(@"%@",kTemplate);
                        if ([kTemplate isKindOfClass:[NSDictionary class]] ) {
                            kTemplate = [[_hostingTemplates objectForKey:k] objectForKey:@"this"];
                            [[_hostingTemplates objectForKey:k] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                                if (![key isEqualToString:@"this"]) {
                                    [kHostTemplates setObject:obj forKey:key];
                                }
                            }];
                        }
                        
                        NSArray *kTemplates = nil;
                        if (kHostTemplates.count == 0) {
                            kTemplates = @[kTemplate];
                        }else {
                            kTemplates = @[kTemplate,kHostTemplates];
                        }
                        
                        NSString *kTableName = NSStringFromClass(kTemplate);
                        if ([[kTableName substringFromIndex:kTableName.length - 5] isEqualToString:@"Model"]) {
                            // 去掉结尾的model
                            kTableName = [kTableName substringToIndex:kTableName.length - 5];
                            // 可数复数
                            if ([[kTableName substringFromIndex:kTableName.length - 1] isEqualToString:@"s"]) {
                                kTableName = [kTableName substringToIndex:kTableName.length - 1];
                            }
                        }
                        
                        JADBTable *hostTable = [[JADBTable alloc] initWithDb:_dbQueue
                                                                   tableName:kTableName
                                                                   templates:kTemplates];
                        
                        [_hostingTables setObject:hostTable forKey:kTableName];
                        
                        /// 创建关联表
                        NSString *relateTableName = [NSString stringWithFormat:@"%@_RELATE_%@",_tableName,kTableName];
                        NSString *parentPk = [_template pK];
                        NSString *sonPk = [kTemplate pK];
                        
                        JADBTable *relateTable = [[JADBTable alloc] initWithDb:_dbQueue
                                                                     tableName:relateTableName
                                                                     templates:@[parentPk,sonPk]];
                        
                        [_hostingTables setObject:relateTable forKey:relateTableName];
                        
                        [sql appendString:@" TEXT"];
                        
                    }else if ([v isEqualToString:@"NSDictionary"]) {
                        
                        /// 当属性为字典时 -- 暂时没碰到
                        NSLog(@"%@",v);
                    }
                }
                
                if (i != (allKeys.count - 1)) {
                    [sql appendString:@","];
                }
            }
        }
        
        [sql appendString:@")"];
        

        [self executeUpateWithSql:sql okLog:@"表创建成功" failLog:@"表创建失败"];
    }
    return self;
}

- (void)executeUpateWithSql:(NSString *)sql
                      okLog:(NSString *)okLog
                    failLog:(NSString *)failLog {
    
#if DEBUG
    NSLog(@"[JA]:%@",sql);
#endif
    
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        BOOL r = [db executeUpdate:sql];
        if(r) {
            NSLog(@"[JA]:%@",okLog);
        }else {
            NSLog(@"[JA]:%@",failLog);
            *rollback = true;
            return ;
        }
    }];
}

- (void)insertWithModel:(JAModel *)model {
    
    NSMutableString *sql = [NSMutableString stringWithString:[NSString stringWithFormat:@"INSERT INTO %@ (",self.tableName]];
    
    NSArray *allKeys = self.fieldsTypePair.allKeys;
    for (int i = 0; i < allKeys.count; ++i) {
        NSString *k = allKeys[i];
        [sql appendString:k];
        if (i != (allKeys.count - 1)) {
            [sql appendString:@","];
        }
    }
    
    [sql appendString:@") VALUES("];
    for (int i = 0; i < allKeys.count; ++i) {
        NSString *k = allKeys[i];
        [sql appendString:@"'"];
        NSString *t = [_fieldsTypePair objectForKey:k];
        id v = [model valueForKeyPath:k];
        if ([t isEqualToString:@"NSString"]) {
            if (v) {
                [sql appendString:v];
            }else {
                [sql appendString:@""];
            }
        }else if ([t isEqualToString:@"NSNumber"]) {
            [sql appendString:[v stringValue]];
        }else if ([t rangeOfString:@"Model"].location != NSNotFound) {
            NSString *hostK = [[v class] pK];
            NSNumber *hostV = [v valueForKeyPath:hostK];
#warning Wait
            // 比如所有章节表中为 [1,6]
            // 当为这本书添加新章节时,只能在上面的 [1,6] 中选择
            // 预先查询,因为查询的方法,还未写,先 PASS
            //
            //
            [sql appendString:hostV.stringValue];
        }else if ([t isEqualToString:@"NSArray"]) {
            
            /// 在关联表中添加相关的记录
            id kTemplate = [_hostingTemplates objectForKey:k];
            NSMutableDictionary *kHostTemplates = [NSMutableDictionary dictionary];
            
            if ([kTemplate isKindOfClass:[NSDictionary class]] ) {
                kTemplate = [[_hostingTemplates objectForKey:k] objectForKey:@"this"];
                [[_hostingTemplates objectForKey:k] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    if (![key isEqualToString:@"this"]) {
                        [kHostTemplates setObject:obj forKey:key];
                    }
                }];
            }
            
            // 子表表名
            NSString *kTableName = NSStringFromClass(kTemplate);
            if ([[kTableName substringFromIndex:kTableName.length - 5] isEqualToString:@"Model"]) {
                // 去掉结尾的model
                kTableName = [kTableName substringToIndex:kTableName.length - 5];
                // 可数复数
                if ([[kTableName substringFromIndex:kTableName.length - 1] isEqualToString:@"s"]) {
                    kTableName = [kTableName substringToIndex:kTableName.length - 1];
                }
            }
            
            /// 子表对象
            JADBTable *hostTable = [_hostingTables objectForKey:kTableName];
            
            /// 关联表表名
            NSString *relateTableName = [NSString stringWithFormat:@"%@_RELATE_%@",_tableName,kTableName];
            
            /// 关联表的属性名称
            /// 来自主表
            NSString *parentPk = [_template pK];
            /// 来自子表
            NSString *sonPk = [kTemplate pK];
            
            /// 关联表对象
            JADBTable *relateTable = [_hostingTables objectForKey:relateTableName];

            /// 子表中是否存在对应记录
            NSArray *vs = (NSArray *)v;
            for (int i = 0; i < vs.count; ++i) {
                NSString *pk = [[vs[i] class] pK];
                id value = [vs[i] valueForKeyPath:pk];
                // 主键为索引查询子表

                // PASS 查询语句暂时这么写
                JAModel *hostModel = [hostTable selectWithValue:value field:pk relationship:@"="];
                                      
                
                NSAssert([hostModel valueForKey:pk],([NSString stringWithFormat:@"[JA]:无法添加,因为 %@ 表中没有对应的记录",kTableName]));
                
                /// 添加值(子表主键1,子表主键2...)
                NSString *hostPk = [NSString stringWithFormat:@"%@",[hostModel valueForKeyPath:pk]];
                [sql appendString:hostPk];
                
                /// 为关联表添加记录                
                id hostModelPkValue = [hostModel valueForKeyPath:sonPk];
                id modelPkValue = [model valueForKeyPath:parentPk];
                [relateTable insertWithTableName:relateTableName propertiesDic:@{
                                                                                 parentPk:hostModelPkValue,
                                                                                 sonPk:modelPkValue
                                                                                 }];
                
                if (i != (vs.count - 1)) {
                    [sql appendString:@","];
                }
            }
            
        }
        [sql appendString:@"'"];
        if (i != (allKeys.count - 1)) {
            [sql appendString:@","];
        }
    }
    [sql appendString:@")"];
    
    [self executeUpateWithSql:sql okLog:@"数据插入成功" failLog:@"数据插入失败"];
}

- (void)insertWithTableName:(NSString *)name
              propertiesDic:(NSDictionary <NSString *,id> *)propertiesDic {
    
    NSMutableString *sql = [NSMutableString stringWithString:[NSString stringWithFormat:@"INSERT INTO %@ (",self.tableName]];
    
    NSArray *properties = propertiesDic.allKeys;
    
    for (int i = 0; i < properties.count; ++i) {
        NSString *k = properties[i];
        [sql appendString:k];
        if (i != (properties.count - 1)) {
            [sql appendString:@","];
        }
    }
    
    [sql appendString:@") VALUES("];
    
    for (int i = 0; i < properties.count; ++i) {
        [sql appendString:@"'"];
        NSString *k = properties[i];
        id property = [propertiesDic objectForKey:k];
        if ([property isKindOfClass:[NSNumber class]]) {
            [sql appendString:[property stringValue]];
        }else {
            [sql appendString:property];
        }
        [sql appendString:@"'"];
        if (i != (properties.count - 1)) {
            [sql appendString:@","];
        }
    }
    
    [sql appendString:@")"];
    
    [self executeUpateWithSql:sql okLog:@"数据插入成功" failLog:@"数据插入失败"];
}

#pragma mark -
#pragma mark - 需要优化

- (void)updateWithModel:(JAModel *)model {
    NSMutableString *sql = [NSMutableString stringWithString:@"UPDATE "];
    [sql appendString:self.tableName];
    [sql appendString:@" SET "];
    NSArray *allKeys = self.fieldsTypePair.allKeys;
    for (int i = 0; i < allKeys.count; ++i) {
        NSString *k = allKeys[i];
        if (![k isEqualToString:[[model class] pK]]) {
            [sql appendString:k];
            [sql appendString:@" = '"];
            
            if ([[model valueForKeyPath:k] isKindOfClass:[NSNumber class]]) {
                
            }else if ([[model valueForKeyPath:k] isKindOfClass:[NSString class]]){
                
                [sql appendString:[model valueForKeyPath:k]];
                [sql appendString:@"'"];
                
            }else if ([[model valueForKeyPath:k] isKindOfClass:[NSArray class]]) {
                
                // 数组类型
                
            }else if([[model valueForKeyPath:k] isKindOfClass:[JAModel class]]) {
                
                // 模型类型
            }
            
            [sql appendString:@","];
        }
    }
    
    [sql appendString:@" WHERE "];
    [sql appendString:[model.class pK]];
    [sql appendString:@" = "];
    
    // 主键
    if ([[model valueForKeyPath:[model.class pK]] isKindOfClass:[NSNumber class]]) {
        NSNumber *n = [model valueForKeyPath:[model.class pK]];
        [sql appendString:n.stringValue];
    }
    
    [self executeUpateWithSql:sql okLog:@"数据更新成功" failLog:@"数据更新失败"];
}

- (JAModel *)selectWithValue:(NSString *)value {
    return [self selectWithValue:value
                           field:[self.template pK]
                    relationship:@"="];
}

- (JAModel *)selectWithValue:(id)value
                       field:(NSString *)field
                relationship:(NSString *)rs {
    
    return [self selectWithValue:value
                           field:field
                    relationship:rs
                            name:self.tableName];
}

#pragma mark -
#pragma mark - 需要优化
- (JAModel *)selectWithValue:(id)value
                       field:(NSString *)field
                relationship:(NSString *)rs
                        name:(NSString *)name {
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ %@ '%@'",name,field,rs,value];
    
    NSLog(@"[JA]:%@",[NSString stringWithFormat:@"%@",sql]);
    
    JAModel *m = [[self.template alloc] init];
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSArray *fieldKeys = self.fieldsTypePair.allKeys;
            for (NSString *k in fieldKeys) {
                if ([[_fieldsTypePair objectForKey:k] isEqualToString:@"NSString"]) {
                    
                    [m setValue:[rs stringForColumn:k] forKey:k];
                    
                }else if ([[_fieldsTypePair objectForKey:k] isEqualToString:@"NSNumber"]) {
                    
                    [m setValue:@([[rs stringForColumn:k] doubleValue]) forKey:k];
                    
                }else if ([[_fieldsTypePair objectForKey:k] isEqualToString:@"NSArray"]) {
                    
                    NSLog(@"select NSArray");
                    
                }else if ([[_fieldsTypePair objectForKey:k] rangeOfString:@"Model"].location != NSNotFound) {
                    
                    NSLog(@"select Model");
                    
                }
            }
        }
    }];
    
    return m;
}

#pragma mark -
#pragma mark - 需要优化

- (NSArray <JAModel *> *)selectAll {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",_tableName];
    NSMutableArray *models = [NSMutableArray array];
    
    NSMutableDictionary *kIsDic = [NSMutableDictionary dictionary];
    
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *rs = [db executeQuery:sql];
        int i = 0;
        while ([rs next]) {
            JAModel *m = [[self.template alloc] init];
            NSArray *filedKeys = self.fieldsTypePair.allKeys;
            for (NSString *k in filedKeys) {
                NSString *v = [self.fieldsTypePair objectForKey:k];
                if ([v isEqualToString:@"NSString"]) {
                    
                    [m setValue:[rs stringForColumn:k] forKey:k];
                    
                }else if ([v isEqualToString:@"NSNumber"]) {
                    
                    [m setValue:@([[rs stringForColumn:k] doubleValue]) forKey:k];
                    
                }else if ([v isEqualToString:@"NSArray"]) {
                    
                    /// 对于数组属性,通过分割主表中的数组属性的字符串,到子表中查询得到模型对象,然后进行KVC赋值操作
                    /// 但是fmdb内嵌方式的情况下,运行会崩溃,大约还是锁的问题先记录下来,然后再处理
                    NSArray *kHostPks = [[rs stringForColumn:k] componentsSeparatedByString:@","];
                    [kIsDic setValue:@[kHostPks,k] forKey:@(i).stringValue];
                    
                }else if ([v rangeOfString:@"Model"].location != NSNotFound) {
                    
                    // 与 NSArray 时类似处理
                    
                }
            }
            [models addObject:m];
            i++;
        }
    }];
    
    /// 这一段挺混乱的,目前想不出比较棒的数据组织方式,命名也挺糟糕
    NSArray *allKeys = [kIsDic allKeys];
    for (int i = 0; i < allKeys.count; ++i) {
        JAModel *m = [models objectAtIndex:[allKeys[i] doubleValue]];
        NSArray *list = [kIsDic objectForKey:allKeys[i]];
        NSArray *kHostPks = list[0];
        NSString *k = list[1];
        NSString *kTableName = [self createNameWithKey:k];
        JADBTable *table = [self.hostingTables objectForKey:kTableName];
        NSMutableArray *imm = [NSMutableArray arrayWithCapacity:kHostPks.count];
        for (NSString *pkValue in kHostPks) {
            JAModel *im = [table selectWithValue:pkValue field:[table.template pK] relationship:@"="];
            [imm addObject:im];
        }
        [m setValue:[imm copy] forKey:k];
    }
    return [models copy];
}

- (void)deleteWithValue:(id)value {
    [self deleteWithValue:value
                    field:[self.template pK]
             relationship:@"="];
}

- (void)deleteWithValue:(id)value
                  field:(NSString *)field
           relationship:(NSString *)rs {
    
    NSString *sql = [NSString stringWithFormat:@"DELETE  FROM %@ WHERE %@ %@ '%@'",self.tableName,field,rs,value];
    [self executeUpateWithSql:sql okLog:@"数据删除成功" failLog:@"数据删除失败"];
}

- (void)deleteAll {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@",self.tableName];
    [self executeUpateWithSql:sql okLog:@"数据删除成功" failLog:@"数据删除失败"];
}

#pragma mark -
#pragma mark - 需要优化
- (NSString *)createNameWithKey:(NSString *)k {
    id kTemplate = [_hostingTemplates objectForKey:k];
    NSMutableDictionary *kHostTemplates = [NSMutableDictionary dictionary];
    
    if ([kTemplate isKindOfClass:[NSDictionary class]] ) {
        kTemplate = [[_hostingTemplates objectForKey:k] objectForKey:@"this"];
        [[_hostingTemplates objectForKey:k] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if (![key isEqualToString:@"this"]) {
                [kHostTemplates setObject:obj forKey:key];
            }
        }];
    }
    
    // 子表表名
    NSString *kTableName = NSStringFromClass(kTemplate);
    if ([[kTableName substringFromIndex:kTableName.length - 5] isEqualToString:@"Model"]) {
        // 去掉结尾的model
        kTableName = [kTableName substringToIndex:kTableName.length - 5];
        // 可数复数
        if ([[kTableName substringFromIndex:kTableName.length - 1] isEqualToString:@"s"]) {
            kTableName = [kTableName substringToIndex:kTableName.length - 1];
        }
    }
    
    return kTableName;
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
    [self pushWithTable:table];
    return table;
}

- (void)pushWithTable:(JADBTable *)table {
    [table.hostingTables enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, JADBTable * _Nonnull obj, BOOL * _Nonnull stop) {
        
        if (obj.hostingTables.count > 0) {
            [self pushWithTable:obj];
        }
        
        [self.tables setObject:obj forKey:key];
    }];
}

- (JADBTable *)selectTableWithName:(NSString *)tableName {
    return [self.tables objectForKey:tableName];
}

- (void)deleteTable {
    NSString *sql = [NSString stringWithFormat:@" DROP TABLE %@",self.curTableName];
    [[self.tables objectForKey:self.curTableName] executeUpateWithSql:sql okLog:[NSString stringWithFormat:@"%@表被成功删除",self.curTableName] failLog:[NSString stringWithFormat:@"%@ 表删除失败",self.curTableName]];
}

- (void)deleteTableWithName:(NSString *)name {
    NSString *sql = [NSString stringWithFormat:@" DROP TABLE %@",name];
    [[self.tables objectForKey:name] executeUpateWithSql:sql okLog:[NSString stringWithFormat:@"%@表被成功删除",name] failLog:[NSString stringWithFormat:@"%@ 表删除失败",name]];
}

- (NSArray *)allTables {
    return [self.tables allKeys];
}

- (NSMutableDictionary<NSString *,JADBTable *> *)tables {
    if (_tables == nil) {
        _tables = [NSMutableDictionary dictionary];
    }
    return _tables;
}

@end
