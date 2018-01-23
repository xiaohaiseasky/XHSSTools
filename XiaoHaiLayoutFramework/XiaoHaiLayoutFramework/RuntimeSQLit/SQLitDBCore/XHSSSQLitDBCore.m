//
//  XHSSSQLitDBCore.m
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2018/1/23.
//  Copyright © 2018年 XiaoHai. All rights reserved.
//

#import "XHSSSQLitDBCore.h"
#import "XHSSDBPathManager.h"
#import "XHSSDBCommonSettingFile.h"

@implementation XHSSSQLitDBCore {
    sqlite3* database;
    sqlite3_stmt* stmt;
    
    //BOOL _isDataBaseOpen;
    //NSMutableArray* _existedTableArr;
}

#pragma mark - 数据库操作
-(BOOL) openDatabase {
    //int openDBResult = sqlite3_open([[self getPath] UTF8String], &database);
    int openDBResult = sqlite3_open([[XHSSDBPathManager getPath] UTF8String], &database);
    
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

#pragma mark - 表操作
-(BOOL) createTable:(NSString*)createTableStr {
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



#define kIfNormalMethod NO
-(BOOL) addRecord:(NSString*)sqlStr {
    //    kJudgeSQLPara(sqlStr)
    
    const char* insertSql = [sqlStr UTF8String];
    int insertResult;
    
    // 普通方法
    if (kIfNormalMethod) {
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
    
    const char* selecteSql = [sqlStr UTF8String];
    
    int selecteResult = sqlite3_prepare_v2(database, selecteSql, -1, &stmt, nil);
    if (selecteResult != SQLITE_OK) {
        NSLog(@"查询失败: %d", selecteResult);
        return nil;
    }
    else {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            int idColumn = sqlite3_column_int(stmt, 0);
            char* nameColumn = (char *) sqlite3_column_text(stmt, 1);
            char* sexColumn = (char *) sqlite3_column_text(stmt, 2);
            NSLog(@"%d - %s - %s", idColumn, nameColumn, sexColumn);
        }

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
    
    const char* updateSql = [sqlStr UTF8String];
    int updateResult;
    
    // 普通方法
    if (kIfNormalMethod) {
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
    
    const char* deleteSql = [sqlStr UTF8String];
    int deleteResult;
    
    // 普通方法
    if (kIfNormalMethod) {
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
