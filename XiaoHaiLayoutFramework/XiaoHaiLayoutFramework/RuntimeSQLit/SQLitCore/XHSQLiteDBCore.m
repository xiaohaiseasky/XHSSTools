//
//  XHSQLiteDBCore.m
//  RuntimeSQLit
//
//  Created by Admin on 16/9/23.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHSQLiteDBCore.h"
#import "XHDBCommon.h"
#import "XHDBPathGenerator.h"
#import "XHGetModleRuntimeInfo.h"
#import "XHSQLSentenceGenerator.h"

@implementation XHSQLiteDBCore {
    sqlite3* database;
    sqlite3_stmt* stmt;
    
    //BOOL _isDataBaseOpen;
    //NSMutableArray* _existedTableArr;
}


+(instancetype) ShareXHSQLiteDBCore {
    static XHSQLiteDBCore* manager = nil;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[[self class] alloc] init];
    });
    
    return manager;
}


-(BOOL) openDatabase {
    
    //int openDBResult = sqlite3_open([[self getPath] UTF8String], &database);
    int openDBResult = sqlite3_open([[XHDBPathGenerator getPath] UTF8String], &database);
    
    if (openDBResult != SQLITE_OK) {
        NSLog(@"创建／打开数据库失败: %d", openDBResult);
        return NO;
    }
    else {
        NSLog(@"打开数据库成功");
    }
    
    return YES;
}

-(BOOL) closeDatabase {
    
    int destroyStmtRes = sqlite3_finalize(stmt);
    int closeDbRes = sqlite3_close(database);
    
    return YES;
}

-(BOOL) createTable:(NSString*)createTableStr {
    
//    kJudgeInputModle(modle)
    
//    if (![self openDatabase]) {
//        return NO;
//    }
    
//    if ([_existedTableArr containsObject:NSStringFromClass([modle class])]) {
//        NSLog(@"表 %@ 已经存在", NSStringFromClass([modle class]));
//        return YES;
//    }
    
//    NSMutableString* sqlStr = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id INTEGER PRIMARY KEY AUTOINCREMENT, ", NSStringFromClass([modle class])];
//    
//    NSArray* propertyInfoArr = [XHGetModleRuntimeInfo getPropertyListOfModle:modle];
//    NSArray* nameArr = [[XHSQLSentenceGenerator generateColumnsAndValuesStrWithArr:propertyInfoArr] objectForKey:kColumnsArrKey];
//    NSArray* valueArr = [[XHSQLSentenceGenerator generateColumnsAndValuesStrWithArr:propertyInfoArr] objectForKey:kValuesArrKey];
//    NSArray* typeArr = [[XHSQLSentenceGenerator generateColumnsAndValuesStrWithArr:propertyInfoArr] objectForKey:kTypesArrKey];
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
    
    
    
    
    char* error;
    const char* createTbSql = [createTableStr UTF8String];
    int createTbResult = sqlite3_exec(database, createTbSql, NULL, NULL, &error);
    if (createTbResult != SQLITE_OK) {
        NSLog(@"创建表失败: %s", error);
        return NO;
    }
    else {
        NSLog(@"创建表成功");
    }
    
    return YES;
}




-(BOOL) addRecord:(NSString*)sqlStr {
    
    //    kJudgeSQLPara(sqlStr)
    
    //const char* insertSql = "INSERT INTO student (name, sex) VALUES ('xiaoqiang', 'nan')";
    const char* insertSql = [sqlStr UTF8String];
    int insertResult;
    
    // 普通方法
    if (NO) {
        insertResult = sqlite3_prepare_v2(database, insertSql, -1, &stmt, nil);
        if (insertResult != SQLITE_OK) {
            NSLog(@"添加失败: %d", insertResult);
            return NO;
        }
        else {
            sqlite3_step(stmt);
        }
    }
    
    // 经典方法
    char* error;
    insertResult = sqlite3_exec(database, insertSql, NULL, NULL, &error);
    if (insertResult != SQLITE_OK) {
        NSLog(@"添加失败: %d - %s", insertResult, error);
        [self closeDatabase];
        return NO;
    }
    else {
        NSLog(@"添加数据成功\n\n");
    }
    
    return YES;
}

-(NSDictionary*) selecteRecord:(NSString*)sqlStr {
    
    //    kJudgeSQLPara(sqlStr)
    
    //const char* selecteSql = "SELECT * FROM student WHERE sex = 'nan'";
    const char* selecteSql = [sqlStr UTF8String];
    
    int selecteResult = sqlite3_prepare_v2(database, selecteSql, -1, &stmt, nil);
    if (selecteResult != SQLITE_OK) {
        NSLog(@"查询失败: %d", selecteResult);
        return nil;
    }
    else {
        //        while (sqlite3_step(stmt) == SQLITE_ROW) {
        //            int idColumn = sqlite3_column_int(stmt, 0);
        //            char* nameColumn = (char *) sqlite3_column_text(stmt, 1);
        //            char* sexColumn = (char *) sqlite3_column_text(stmt, 2);
        //            NSLog(@"%d - %s - %s", idColumn, nameColumn, sexColumn);
        //        }
        
        NSLog(@"查询数据成功\n\n");
        
        NSMutableDictionary* resultListDic = [NSMutableDictionary dictionaryWithCapacity:1];
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            int columnCount = sqlite3_column_count(stmt);
            for (int i = 1; i < columnCount; i++) {
                const char* columnName = sqlite3_column_name(stmt, i);   //取得列名
                const unsigned char* columnValue = sqlite3_column_text(stmt, i);       //取得某列的值
#warning  数据类型需要区分
                [resultListDic setObject:[NSString stringWithUTF8String:(const char*)columnValue] forKey:[NSString stringWithUTF8String:columnName]];
            }
        }
        //        sqlite3_finalize(stmt);
        return resultListDic;
    }
    
    return nil;
}

-(BOOL) updateRecord:(NSString*)sqlStr {
    
    //    kJudgeSQLPara(sqlStr)
    
    //const char* updateSql = "UPDATE student SET name = 'fengniao' WHERE name = 'xiaoqiang'";
    const char* updateSql = [sqlStr UTF8String];
    int updateResult;
    
    // 普通方法
    if (NO) {
        updateResult = sqlite3_prepare_v2(database, updateSql, -1, &stmt, nil);
        if (updateResult != SQLITE_OK) {
            NSLog(@"修改数据失败: %d", updateResult);
            return NO;
        }
        else {
            sqlite3_step(stmt);
        }
    }
    
    // 经典方法
    char* error;
    updateResult = sqlite3_exec(database, updateSql, NULL, NULL, &error);
    if (updateResult != SQLITE_OK) {
        NSLog(@"修改数据失败: %d - %s", updateResult, error);
        return NO;
    }
    else {
        NSLog(@"修改数据成功\n\n");
    }
    
    return  YES;
}

-(BOOL)deleteRecord:(NSString*)sqlStr {
    
    //    kJudgeSQLPara(sqlStr)
    
    //const char* deleteSql = "DELETE FROM student WHERE name = 'fengniao'";
    const char* deleteSql = [sqlStr UTF8String];
    int deleteResult;
    
    // 普通方法
    if (NO) {
        deleteResult = sqlite3_prepare_v2(database, deleteSql, -1, &stmt, nil);
        if (deleteResult != SQLITE_OK) {
            NSLog(@"删除失败: %d", deleteResult);
            return NO;
        }
        else {
            sqlite3_step(stmt);
        }
    }
    
    // 经典方法
    char* error;
    deleteResult = sqlite3_exec(database, deleteSql, NULL, NULL, &error);
    if (deleteResult != SQLITE_OK) {
        NSLog(@"删除失败: %d - %s", deleteResult, error);
        return NO;
    }
    else {
        NSLog(@"删除数据成功\n\n");
    }
    
    return YES;
}

@end
