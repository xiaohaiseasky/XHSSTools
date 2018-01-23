//
//  SQLiteDBManager.m
//  RuntimeSQLit
//
//  Created by Admin on 16/9/21.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "SQLiteDBManager.h"

//#import <sqlite3.h>
//#import <objc/runtime.h>
////#import <objc/message.h>
//#import <CoreData/CoreData.h>
//
//
//
//
//#ifdef DEBUG
//#define CustomLog(...)       NSLog(@"%s [line: %d]", __PRETTY_FUNCTION__, __LINE__, __VA_ARGS__);
//#else
//#define CustomLog(...)
//#endif
//
//#define kJudgeSQLPara(sqlStr)       if (sqlStr == nil || sqlStr.length <= 0) {\
//                                        NSLog(@"sql 语句为空");\
//                                        return NO;\
//                                    }
//
//#define kJudgeInputModle(modle)     if (!modle) {\
//                                        NSLog(@"参考模型 为空");\
//                                        return nil;\
//                                    }
//
//#define kJudgeProperty(property)    if (!property) {\
//                                        NSLog(@"属性 为空");\
//                                        return nil;\
//                                    }
//
//#define lJudgePropertyTypeDes(propertyTypeDes)    if (propertyTypeDes == nil) {\
//                                                      NSLog(@"属性类型描述 为空");\
//                                                      return XHPropertyBaseTypeNull;\
//                                                  }
//
//
//
//
//
//
//#define kColumnsStrKey   @"columnsStr"
//#define kValuesStrKey    @"valuesStr"
//#define kTypesStrKey     @"typesStr"
//#define kColumnsArrKey   @"columnsArr"
//#define kValuesArrKey    @"valuesArr"
//#define kTypesArrKey     @"typesArr"
//
//#define kPropertyName    @"propertyName"
//#define kPropertyType    @"propertyType"
//#define kPropertyValue   @"propertyValue"
//
//
//
//
//
//typedef enum {
//    DbOperateTypeAdd        = 1,
//    DbOperateTypeDelete     = 2,
//    DbOperateTypeUpdate     =3,
//    DbOperateTypeSelect     = 4,
//}DbOperateType;
//
//typedef NS_ENUM(NSInteger, XHPropertyType) {
//    XHPropertyTypeShort     = 1,
//    XHPropertyTypeInt       = 2,
//    XHPropertyTypeLong      = 3,
//    XHPropertyTypeLongLong  = 4,
//    XHPropertyTypeFloat     = 5,
//    XHPropertyTypeDouble    = 6,
//    XHPropertyTypeChar      = 7,
//    XHPropertyTypeBool      = 8,
//};
//
//typedef NS_ENUM(NSInteger, XHPropertyBaseType) {
//    XHPropertyBaseTypeNull              = 1,
//    XHPropertyBaseTypeBOOL              = 1 << 1,
//    XHPropertyBaseTypeNumber            = 1 << 2,
//    XHPropertyBaseTypeId                = 1 << 3,
//    XHPropertyBaseTypeClass             = 1 << 4,
//    XHPropertyBaseTypeFromFoundation    = 1 << 5,
//    XHPropertyBaseTypeKVCDisabled       = 1 << 6,
//};




@implementation SQLiteDBManager
//{
//    sqlite3* database;
//    sqlite3_stmt* stmt;
//}
//
///**
// * 1. 模型属性值的类型区分
// * 2. 存入数据库的所有字段，除自动生成的id 外，都用 CHAR 类型
// * 3. 模型嵌套的情况
// * 4. 数据库基本数据类型，OC基本数据类型 的区分
// */
//
//////////////////////////////////////////////////////////////////////////////////////
/////                            属性类型处理
//////////////////////////////////////////////////////////////////////////////////////
//
///**
// *  成员变量类型（属性类型）
// */
//NSString *const MJPropertyTypeInt = @"i";
//NSString *const MJPropertyTypeShort = @"s";
//NSString *const MJPropertyTypeFloat = @"f";
//NSString *const MJPropertyTypeDouble = @"d";
//NSString *const MJPropertyTypeLong = @"l";
//NSString *const MJPropertyTypeLongLong = @"q";
//NSString *const MJPropertyTypeChar = @"c";
//NSString *const MJPropertyTypeBOOL1 = @"c";
//NSString *const MJPropertyTypeBOOL2 = @"b";
//NSString *const MJPropertyTypePointer = @"*";
//
//NSString *const MJPropertyTypeIvar = @"^{objc_ivar=}";
//NSString *const MJPropertyTypeMethod = @"^{objc_method=}";
//NSString *const MJPropertyTypeBlock = @"@?";
//NSString *const MJPropertyTypeClass = @"#";
//NSString *const MJPropertyTypeSEL = @":";
//NSString *const MJPropertyTypeId = @"@";
//
//
//////////////////////////////////////////////////////////////////////////////////////
/////                        是否是Foundation 框架中的类型
//////////////////////////////////////////////////////////////////////////////////////
//
//static NSSet *foundationClasses_;
//
//- (NSSet *)foundationClasses
//{
//    if (foundationClasses_ == nil) {
//        // 集合中没有NSObject，因为几乎所有的类都是继承自NSObject，具体是不是NSObject需要特殊判断
//        foundationClasses_ = [NSSet setWithObjects:
//                              [NSURL class],
//                              [NSDate class],
//                              [NSValue class],
//                              [NSData class],
//                              [NSError class],
//                              [NSArray class],
//                              [NSDictionary class],
//                              [NSString class],
//                              [NSAttributedString class], nil];
//    }
//    return foundationClasses_;
//}
//
//- (BOOL)isClassFromFoundation:(Class)c
//{
//    if (c == [NSObject class] || c == [NSManagedObject class]) return YES;
//    
//    __block BOOL result = NO;
//    [[self foundationClasses] enumerateObjectsUsingBlock:^(Class foundationClass, BOOL *stop) {
//        if ([c isSubclassOfClass:foundationClass]) {
//            result = YES;
//            *stop = YES;
//        }
//    }];
//    return result;
//}
//
//
//////////////////////////////////////////////////////////////////////////////////////
/////                         Runtime 属性处理
//////////////////////////////////////////////////////////////////////////////////////
//
///**
// * 获取属性信息
// */
//-(NSDictionary*) getPropertyInfo:(objc_property_t)property forModle:(id)modle {
//    
//    kJudgeProperty(property)
//    
//    NSMutableDictionary* propertyInfoDic = [NSMutableDictionary dictionaryWithCapacity:1];
//    
//    /// 属性名字 bookName
//    const char* cPropertyName = property_getName(property);
//    NSString* propertyName = [NSString stringWithUTF8String:cPropertyName];
//    
//    /// 属性特征／类型 T@"NSString",&,N,V_bookName
//    const char* cPropertyAtt = property_getAttributes(property);
//    NSString* propertyAtt = [NSString stringWithUTF8String:cPropertyAtt];
//    NSInteger dotLocation = [propertyAtt rangeOfString:@","].location;
//    NSString* propertyTypeDesStr = nil;
//    NSInteger loc = 1;
//    if (dotLocation == NSNotFound) {
//        propertyTypeDesStr = [propertyAtt substringFromIndex:loc];
//    }
//    else {
//        propertyTypeDesStr = [propertyAtt substringWithRange:NSMakeRange(loc, dotLocation - loc)];
//    }
//    /// 由类型字符串取得 类型
//    XHPropertyBaseType baseType = [self getPropertyTypeByPropertyTypeDes:propertyTypeDesStr];
//    
//    /// 属性值
//    id propertyValue = [modle valueForKey:propertyName];
//    
//#warning 注意 setObject 为非对象类型时候 导致错误
//    if (propertyName != nil && propertyName.length != 0) {
//        [propertyInfoDic setObject:propertyName forKey:kPropertyName];
//    }
//    else {
//        [propertyInfoDic setObject:@"" forKey:kPropertyName];
//    }
//    
//    if (!baseType) {
//        [propertyInfoDic setObject:@(baseType) forKey:kPropertyType];
//    }
//    else {
//        [propertyInfoDic setObject:@(baseType) forKey:kPropertyType];
//    }
//    
//    if (propertyValue != nil && [[propertyValue class] isKindOfClass:[NSObject class]]) {
//        [propertyInfoDic setObject:propertyValue forKey:kPropertyValue];
//    }
//    else {
//        if (propertyValue == nil) {
//            [propertyInfoDic setObject:[NSNull null] forKey:kPropertyValue];
//        }
//        else {
//            //[propertyInfoDic setObject:propertyValue forKey:kPropertyValue];
//        }
//    }
//    
//    return propertyInfoDic;
//}
//
///**
// * 获取属性类型
// */
//-(XHPropertyBaseType) getPropertyTypeByPropertyTypeDes:(NSString*)propertyTypeDes {
//    
//    lJudgePropertyTypeDes(propertyTypeDes);
//    
//    XHPropertyBaseType baseType = XHPropertyBaseTypeNull;
//    
//    if ([propertyTypeDes isEqualToString:MJPropertyTypeId]) {
//        baseType = XHPropertyBaseTypeId;
//    } else if (propertyTypeDes.length == 0) {
//        baseType = XHPropertyBaseTypeKVCDisabled;
//    } else if (propertyTypeDes.length > 3 && [propertyTypeDes hasPrefix:@"@\""]) {
//        // 去掉@"和"，截取中间的类型名称
//        NSString* typeStr = [propertyTypeDes substringWithRange:NSMakeRange(2, propertyTypeDes.length - 3)];
//        Class typeClass = NSClassFromString(typeStr);
//        baseType = XHPropertyBaseTypeClass;
//        if ([self isClassFromFoundation:typeClass]) {
//            baseType |= XHPropertyBaseTypeFromFoundation;
//        }
//        if ([typeClass isSubclassOfClass:[NSNumber class]]) {
//            baseType |= XHPropertyBaseTypeNumber;
//        }
//        
//    } else if ([propertyTypeDes isEqualToString:MJPropertyTypeSEL] ||
//               [propertyTypeDes isEqualToString:MJPropertyTypeIvar] ||
//               [propertyTypeDes isEqualToString:MJPropertyTypeMethod]) {
//        baseType = XHPropertyBaseTypeKVCDisabled;
//    }
//    
//    // 是否为数字类型
//    NSString *lowerCode = propertyTypeDes.lowercaseString;
//    NSArray *numberTypes = @[MJPropertyTypeInt, MJPropertyTypeShort, MJPropertyTypeBOOL1, MJPropertyTypeBOOL2, MJPropertyTypeFloat, MJPropertyTypeDouble, MJPropertyTypeLong, MJPropertyTypeLongLong, MJPropertyTypeChar];
//    if ([numberTypes containsObject:lowerCode]) {
//        baseType |= XHPropertyBaseTypeNumber;
//        
//        if ([lowerCode isEqualToString:MJPropertyTypeBOOL1] || [lowerCode isEqualToString:MJPropertyTypeBOOL2]) {
//            baseType |= XHPropertyBaseTypeBOOL;
//        }
//    }
//    
//    return baseType;
//}
//
//////////////////////////////////////////////////////////////////////////////////////
/////                            Tool
//////////////////////////////////////////////////////////////////////////////////////
//
//+(instancetype) ShareSQLiteDBManager {
//    static SQLiteDBManager* manager = nil;
//    
//    static dispatch_once_t once;
//    dispatch_once(&once, ^{
//        manager = [[[self class] alloc] init];
//    });
//    
//    return manager;
//}
//
//-(NSString*) getPath {
//    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//    NSString* dbPath = [path stringByAppendingPathComponent:@"TestDatabase.db"];
//    return dbPath;
//}
//
//
//////////////////////////////////////////////////////////////////////////////////////
/////                            Core
//////////////////////////////////////////////////////////////////////////////////////
//
//-(BOOL) openDatabase {
//    int openDBResult = sqlite3_open([[self getPath] UTF8String], &database);
//    if (openDBResult != SQLITE_OK) {
//        NSLog(@"创建／打开数据库失败: %d", openDBResult);
//        return NO;
//    }
//    else {
//        NSLog(@"打开数据库成功");
//    }
//    
//    return YES;
//}
//
//-(BOOL) closeDatabase {
//    
//    int destroyStmtRes = sqlite3_finalize(stmt);
//    int closeDbRes = sqlite3_close(database);
//    
//    return YES;
//}
//
//-(BOOL) createTable:(id)modle {
//    
//    kJudgeInputModle(modle)
//    
//    if (![self openDatabase]) {
//        return NO;
//    }
//    
//    NSMutableString* sqlStr = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id INTEGER PRIMARY KEY AUTOINCREMENT, ", NSStringFromClass([modle class])];
//    
//    NSArray* propertyInfoArr = [self getPropertyListOfModle:modle];
//    NSArray* nameArr = [[self generateColumnsAndValuesStrWithArr:propertyInfoArr] objectForKey:kColumnsArrKey];
//    NSArray* valueArr = [[self generateColumnsAndValuesStrWithArr:propertyInfoArr] objectForKey:kValuesArrKey];
//    NSArray* typeArr = [[self generateColumnsAndValuesStrWithArr:propertyInfoArr] objectForKey:kTypesArrKey];
//#warning  处理属性时需要 处理属性值为 nil 的时候 导致的数组元素不对应的问题
//    for (int i = 0; i < nameArr.count; ++i) {
//        NSString* name = [nameArr objectAtIndex:i];
//        id value = [valueArr objectAtIndex:i];
//        XHPropertyBaseType type = [[typeArr objectAtIndex:i] integerValue];
//        
//        // name CHAR, sex CHAR)
//        NSString* sqlComponentStr;
//        if (type & XHPropertyBaseTypeNumber) {
//            sqlComponentStr = [NSString stringWithFormat:@"%@ CHAR, ", name];
//        }
//        else if (type & XHPropertyBaseTypeClass) {
//            if ([[value class] isKindOfClass:[NSNumber class]]) {
//                sqlComponentStr = [NSString stringWithFormat:@"%@ CHAR, ", name];
//            }
//            else {// if ([[value class] isKindOfClass:[NSString class]]) {
//                sqlComponentStr = [NSString stringWithFormat:@"%@ CHAR, ", name];
//            }
//#warning  其他类型未做处理
//        }
//        
//        if (!sqlComponentStr) {
//            continue;
//        }
//        
//        [sqlStr appendString:sqlComponentStr];
//    }
//    NSString* createTableStr = [sqlStr stringByReplacingCharactersInRange:NSMakeRange(sqlStr.length-2, 2) withString:@")"];
//    
//    
//    
//    
//    char* error;
//    const char* createTbSql = [createTableStr UTF8String];
//    int createTbResult = sqlite3_exec(database, createTbSql, NULL, NULL, &error);
//    if (createTbResult != SQLITE_OK) {
//        NSLog(@"创建表失败: %s", error);
//        return NO;
//    }
//    else {
//        NSLog(@"创建表成功／表格已经存在");
//    }
//    
//    return YES;
//}
//
//
//
//
//-(BOOL) addRecord:(NSString*)sqlStr {
//    
////    kJudgeSQLPara(sqlStr)
//    
//    //const char* insertSql = "INSERT INTO student (name, sex) VALUES ('xiaoqiang', 'nan')";
//    const char* insertSql = [sqlStr UTF8String];
//    int insertResult;
//    
//    // 普通方法
//    if (NO) {
//        insertResult = sqlite3_prepare_v2(database, insertSql, -1, &stmt, nil);
//        if (insertResult != SQLITE_OK) {
//            NSLog(@"添加失败: %d", insertResult);
//            return NO;
//        }
//        else {
//            sqlite3_step(stmt);
//        }
//    }
//    
//    // 经典方法
//    char* error;
//    insertResult = sqlite3_exec(database, insertSql, NULL, NULL, &error);
//    if (insertResult != SQLITE_OK) {
//        NSLog(@"添加失败: %d - %s", insertResult, error);
//        [self closeDatabase];
//        return NO;
//    }
//    else {
//        NSLog(@"添加数据成功\n\n");
//    }
//    
//    return YES;
//}
//
//-(NSDictionary*) selecteRecord:(NSString*)sqlStr {
//    
////    kJudgeSQLPara(sqlStr)
//    
//    //const char* selecteSql = "SELECT * FROM student WHERE sex = 'nan'";
//    const char* selecteSql = [sqlStr UTF8String];
//    
//    int selecteResult = sqlite3_prepare_v2(database, selecteSql, -1, &stmt, nil);
//    if (selecteResult != SQLITE_OK) {
//        NSLog(@"查询失败: %d", selecteResult);
//        return nil;
//    }
//    else {
////        while (sqlite3_step(stmt) == SQLITE_ROW) {
////            int idColumn = sqlite3_column_int(stmt, 0);
////            char* nameColumn = (char *) sqlite3_column_text(stmt, 1);
////            char* sexColumn = (char *) sqlite3_column_text(stmt, 2);
////            NSLog(@"%d - %s - %s", idColumn, nameColumn, sexColumn);
////        }
//        
//        NSLog(@"查询数据成功\n\n");
//        
//        NSMutableDictionary* resultListDic = [NSMutableDictionary dictionaryWithCapacity:1];
//        while (sqlite3_step(stmt) == SQLITE_ROW) {
//            int columnCount = sqlite3_column_count(stmt);
//            for (int i = 1; i < columnCount; i++) {
//                const char* columnName = sqlite3_column_name(stmt, i);   //取得列名
//                const unsigned char* columnValue = sqlite3_column_text(stmt, i);       //取得某列的值
//#warning  数据类型需要区分
//                [resultListDic setObject:[NSString stringWithUTF8String:(const char*)columnValue] forKey:[NSString stringWithUTF8String:columnName]];
//            }
//        }
////        sqlite3_finalize(stmt);
//        return resultListDic;
//    }
//    
//    return nil;
//}
//
//-(BOOL) updateRecord:(NSString*)sqlStr {
//    
////    kJudgeSQLPara(sqlStr)
//    
//    //const char* updateSql = "UPDATE student SET name = 'fengniao' WHERE name = 'xiaoqiang'";
//    const char* updateSql = [sqlStr UTF8String];
//    int updateResult;
//    
//    // 普通方法
//    if (NO) {
//        updateResult = sqlite3_prepare_v2(database, updateSql, -1, &stmt, nil);
//        if (updateResult != SQLITE_OK) {
//            NSLog(@"修改数据失败: %d", updateResult);
//            return NO;
//        }
//        else {
//            sqlite3_step(stmt);
//        }
//    }
//    
//    // 经典方法
//    char* error;
//    updateResult = sqlite3_exec(database, updateSql, NULL, NULL, &error);
//    if (updateResult != SQLITE_OK) {
//        NSLog(@"修改数据失败: %d - %s", updateResult, error);
//        return NO;
//    }
//    else {
//        NSLog(@"修改数据成功\n\n");
//    }
//    
//    return  YES;
//}
//
//-(BOOL)deleteRecord:(NSString*)sqlStr {
//    
////    kJudgeSQLPara(sqlStr)
//    
//    //const char* deleteSql = "DELETE FROM student WHERE name = 'fengniao'";
//    const char* deleteSql = [sqlStr UTF8String];
//    int deleteResult;
//    
//    // 普通方法
//    if (NO) {
//        deleteResult = sqlite3_prepare_v2(database, deleteSql, -1, &stmt, nil);
//        if (deleteResult != SQLITE_OK) {
//            NSLog(@"删除失败: %d", deleteResult);
//            return NO;
//        }
//        else {
//            sqlite3_step(stmt);
//        }
//    }
//    
//    // 经典方法
//    char* error;
//    deleteResult = sqlite3_exec(database, deleteSql, NULL, NULL, &error);
//    if (deleteResult != SQLITE_OK) {
//        NSLog(@"删除失败: %d - %s", deleteResult, error);
//        return NO;
//    }
//    else {
//        NSLog(@"删除数据成功\n\n");
//    }
//    
//    return YES;
//}
//
//
//////////////////////////////////////////////////////////////////////////////////////
/////                     Generate sql from modle
//////////////////////////////////////////////////////////////////////////////////////
//
//-(BOOL) addRecordWithModle:(id)modle {
//    
//    kJudgeInputModle(modle)
//    
//    if (![self createTable:modle]) {
//        return NO;
//    }
//    
//    NSArray* propertyInfoArr = [self getPropertyListOfModle:modle];
//    
//    NSDictionary* resultDic = [self generateColumnsAndValuesStrWithArr:propertyInfoArr];
//    
//    NSString* insertSqlStr = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES ('%@')", NSStringFromClass([modle class]), [resultDic objectForKey:kColumnsStrKey], [resultDic objectForKey:kValuesStrKey]];
//    
//    //char insertSql[1000];
//    //sprintf(insertSql, "INSERT INTO %s (%s) VALUES ('%s')",[NSStringFromClass([modle class]) UTF8String], [[resultDic objectForKey:kColumnsStrKey] UTF8String], [[resultDic objectForKey:kValuesStrKey] UTF8String]);
//
//    NSLog(@"insertSqlStr = %@", insertSqlStr);
//    
//    return [self addRecord:insertSqlStr];
//}
//
//-(NSArray*) selecteRecordOfModle:(id)modle {
//    
//    kJudgeInputModle(modle)
//    
//    if (![self createTable:modle]) {
//        return nil;
//    }
//    
//    /// SELECT * FROM student WHERE sex = 'nan'
//    NSString* noWhereComponentStr = [NSString stringWithFormat:@"SELECT * FROM %@", NSStringFromClass([modle class])];
//    
//    NSArray* propertyInfoArr = [self getPropertyListOfModle:modle];
//    
//    NSString* whereComponentStr = [self generateWhereCondationComponentStrWithArr:propertyInfoArr];
//    
//    NSMutableString* selectSqlStr = [NSMutableString stringWithString:noWhereComponentStr];
//    if (whereComponentStr != nil && whereComponentStr.length > 0) {
//        [selectSqlStr appendFormat:@" WHERE %@", whereComponentStr];
//    }
//    
//    NSLog(@"selectSqlStr = %@", selectSqlStr);
//    
//    NSMutableArray* selectedModleListArr = [NSMutableArray arrayWithCapacity:1];
//    NSDictionary* selectedResultListDic = [self selecteRecord:selectSqlStr];
//    Class modleClass = [modle class];
//    for (NSString* key in [selectedResultListDic allKeys]) {
//        id newModle = [[modleClass alloc] init];
//#warning 用 Modle 的具体类型取代 id ，setValue: 的具体数据类型处理
//        [newModle setValue:[selectedResultListDic objectForKey:key] forKey:key];
//        [selectedModleListArr addObject:newModle];
//    }
//    
//    return selectedModleListArr;
//}
//
//-(BOOL) updateRecordForModle:(id)modle refrenceModle:(id)refModle {
//    
//    kJudgeInputModle(modle)
//    
//    if (![self createTable:modle]) {
//        return NO;
//    }
//    
//    NSArray* propertyInfoArr = [self getPropertyListOfModle:modle];
//    
//    NSString* updateComponentStr = [self generateColumnAndValuePairsStrWithArr:propertyInfoArr];
//   
//    NSString* noWhereComponentStr = [NSString stringWithFormat:@"UPDATE %@ SET %@", NSStringFromClass([modle class]), updateComponentStr];
//    
//    
//    NSArray* refModlePropertyInfoArr = [self getPropertyListOfModle:refModle];
//    
//    NSString* whereComponentStr = [self generateWhereCondationComponentStrWithArr:refModlePropertyInfoArr];
//    
//    NSMutableString* updateSqlStr = [NSMutableString stringWithString:noWhereComponentStr];
//    if (whereComponentStr != nil && whereComponentStr.length > 0) {
//        [updateSqlStr appendFormat:@" WHERE %@", whereComponentStr];
//    }
//    
//    NSLog(@"updateSqlStr = %@", updateSqlStr);
//    
//    return [self updateRecord:updateSqlStr];
//}
//
//-(BOOL)deleteRecordOfModle:(id)modle {
//    
//    kJudgeInputModle(modle)
//    
//    if (![self createTable:modle]) {
//        return NO;
//    }
//    
//    NSArray* propertyInfoArr = [self getPropertyListOfModle:modle];
//    
//    NSString* noWhereComponentStr = [NSString stringWithFormat:@"DELETE FROM %@", NSStringFromClass([modle class])];
//    
//    NSString* whereComponentStr = [self generateWhereCondationComponentStrWithArr:propertyInfoArr];
//    
//    NSMutableString* deleteSqlStr = [NSMutableString stringWithString:noWhereComponentStr];
//    if (whereComponentStr != nil && whereComponentStr.length > 0) {
//        [deleteSqlStr appendFormat:@" WHERE %@", whereComponentStr];
//    }
//    
//    NSLog(@"deleteSqlStr = %@", deleteSqlStr);
//    
//    return [self deleteRecord:deleteSqlStr];
//}
//
//
//////////////////////////////////////////////////////////////////////////////////////
/////                                 Runtime
//////////////////////////////////////////////////////////////////////////////////////
//
//-(NSArray*)getPropertyListOfModle:(id)modle {
//    
//    NSMutableArray* propertyInfoArr = [NSMutableArray arrayWithCapacity:1];
//    
//    unsigned int count;
//    objc_property_t* propertyList = class_copyPropertyList([modle class], &count);
//    for (unsigned int i = 0; i < count; ++i) {
//        objc_property_t aProperty = propertyList[i];
//        
//        [propertyInfoArr addObject:[self getPropertyInfo:aProperty forModle:modle]];
//    }
//    
//    return propertyInfoArr;
//}
//
//
//////////////////////////////////////////////////////////////////////////////////////
/////                                 Tool box
//////////////////////////////////////////////////////////////////////////////////////
//#warning Now is nouse
//-(NSDictionary*) generateColumnsAndValuesStrWithDic:(NSDictionary*)dic {
//    NSMutableDictionary* resDic = [NSMutableDictionary dictionaryWithCapacity:1];
//    
//    NSMutableArray* columnsArr = [NSMutableArray arrayWithCapacity:1];
//    NSMutableArray* valuesArr = [NSMutableArray arrayWithCapacity:1];
//    for (NSString* key in [dic allKeys]) {
//        [columnsArr addObject:key];
//        [valuesArr addObject:[[dic objectForKey:key] stringValue]];
//    }
//    NSString* columnsStr = [columnsArr componentsJoinedByString:@", "];
//    NSString* valuesStr = [valuesArr componentsJoinedByString:@"', '"];
//    
//    [resDic setObject:columnsStr forKey:kColumnsStrKey];
//    [resDic setObject:valuesStr forKey:kValuesStrKey];
//    
//    return resDic;
//}
//
//#warning Now is nouse
//-(NSString*)generateColumnAndValuePairsStrWithDic:(NSDictionary*)dic {
//    NSMutableString* resStr = [NSMutableString string];
//    
//    for (NSString* key in [dic allKeys]) {
//        [resStr appendFormat:@"%@ = '%@', ", key, [[dic objectForKey:key] stringValue]];
//    }
//    
//    return [resStr substringToIndex:resStr.length-2];
//}
//
//
///**
// * 插入 形式 字符串
// */
//-(NSDictionary*) generateColumnsAndValuesStrWithArr:(NSArray*)array {
//    
//    NSMutableDictionary* resDic = [NSMutableDictionary dictionaryWithCapacity:1];
//    
//    NSMutableArray* propertyNameArr = [NSMutableArray arrayWithCapacity:1];
//    NSMutableArray* propertyValueArr = [NSMutableArray arrayWithCapacity:1];
//    NSMutableArray* propertyTypeArr = [NSMutableArray arrayWithCapacity:1];
//    
//    for (NSDictionary* dic in array) {
//        [propertyNameArr addObject:[dic objectForKey:kPropertyName]];
//        [propertyValueArr addObject:[dic objectForKey:kPropertyValue]];
//        [propertyTypeArr addObject:[dic objectForKey:kPropertyType]];
//    }
//    
//    NSString* columnsStr = [propertyNameArr componentsJoinedByString:@", "];
//#warning  属性字段为 数字 ／ 字符串 时候 对 "'" 的处理
//    NSString* valuesStr = [propertyValueArr componentsJoinedByString:@"', '"];
//    
//    [resDic setObject:columnsStr forKey:kColumnsStrKey];
//    [resDic setObject:valuesStr forKey:kValuesStrKey];
//    
//    [resDic setObject:propertyNameArr forKey:kColumnsArrKey];
//    [resDic setObject:propertyValueArr forKey:kValuesArrKey];
//    [resDic setObject:propertyTypeArr forKey:kTypesArrKey];
//    
//    return resDic;
//}
//
///**
// * 更新 形式 字符串
// */
//-(NSString*)generateColumnAndValuePairsStrWithArr:(NSArray*)array {
//    
//    NSMutableString* resStr = [NSMutableString string];
//    
//    for (NSDictionary* dic in array) {
//        [resStr appendFormat:@"%@ = '%@', ", [dic objectForKey:kPropertyName], [dic objectForKey:kPropertyValue]];
//    }
//    
//    return [resStr substringToIndex:resStr.length-2];
//}
//
///**
// * where 条件语句 字符串
// */
//-(NSString*)generateWhereCondationComponentStrWithArr:(NSArray*)array {
//    
//    NSMutableString* resStr = [NSMutableString string];
//#warning  参数为空时候的处理
//    for (NSDictionary* dic in array) {
//        [resStr appendFormat:@"%@ = '%@' AND ", [dic objectForKey:kPropertyName], [dic objectForKey:kPropertyValue]];
//    }
//    
//    return [resStr substringToIndex:resStr.length-5];
//}

@end
