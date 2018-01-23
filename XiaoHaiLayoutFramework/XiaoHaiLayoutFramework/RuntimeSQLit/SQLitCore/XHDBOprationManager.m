//
//  XHDBOprationManager.m
//  RuntimeSQLit
//
//  Created by Admin on 16/9/23.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHDBOprationManager.h"
#import "XHSQLiteDBCore.h"
#import "XHSQLSentenceGenerator.h"
#import "XHGetModleRuntimeInfo.h"
#import "XHDBCommon.h"

@implementation XHDBOprationManager
{
    BOOL _isDataBaseOpen;
    NSMutableArray* _existedTableArr;
}

-(void) setUpData {
    _isDataBaseOpen = NO;
    if (!_existedTableArr) {
        _existedTableArr = [NSMutableArray arrayWithCapacity:1];
    }
}

+(instancetype) ShareXHDBOprationManager {
    static XHDBOprationManager* manager = nil;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[[self class] alloc] init];
        [manager setUpData];
    });
    
    return manager;
}


-(BOOL) openDatabase {
    
    if (_isDataBaseOpen) {
        NSLog(@"数据库已打开");
        return YES;
    }
    
    BOOL result = [[XHSQLiteDBCore ShareXHSQLiteDBCore] openDatabase];
    if (result) {
        _isDataBaseOpen = YES;
    }
    
    return result;
}

-(BOOL) closeDatabase {
    
    if (_isDataBaseOpen) {
        BOOL result = [[XHSQLiteDBCore ShareXHSQLiteDBCore] closeDatabase];
        if (result) {
            NSLog(@"关闭数据库成功");
            _isDataBaseOpen = NO;
        }
        else {
            NSLog(@"关闭数据库失败");
        }
        return result;
    }
    
    NSLog(@"数据库还未打开");
    
    return YES;
}


-(BOOL) createTableFromModle:(id)modle {
    
    kJudgeInputModle(modle)
    
    if (![self openDatabase]) {
        return NO;
    }
    
    if ([_existedTableArr containsObject:NSStringFromClass([modle class])]) {
        NSLog(@"表 %@ 已经存在", NSStringFromClass([modle class]));
        return YES;
    }
    
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
    
    NSString* createTableStr = [XHSQLSentenceGenerator generateCreateTableSqlWithModle:modle];
    
    BOOL result = [[XHSQLiteDBCore ShareXHSQLiteDBCore] createTable:createTableStr];
    
    if (result) {
        [_existedTableArr addObject:NSStringFromClass([modle class])];
    }
    
    return result;
}




-(BOOL) addRecordWithModle:(id)modle {
    
    kJudgeInputModle(modle)
    
    if (![self createTableFromModle:modle]) {
        return NO;
    }
    
    NSString* insertSqlStr = [XHSQLSentenceGenerator generateAddRecordSqlWithModle:modle];
    
    NSLog(@"insertSqlStr = %@", insertSqlStr);
    
    return [[XHSQLiteDBCore ShareXHSQLiteDBCore] addRecord:insertSqlStr];
}

-(NSArray*) selecteRecordOfModle:(id)modle {
    
    kJudgeInputModle(modle)
    
    if (![self createTableFromModle:modle]) {
        return nil;
    }
    
    NSString* selectSqlStr = [XHSQLSentenceGenerator generateSelectRecordSqlWithModle:modle];
    
    NSLog(@"selectSqlStr = %@", selectSqlStr);
    
    NSMutableArray* selectedModleListArr = [NSMutableArray arrayWithCapacity:1];
    NSDictionary* selectedResultListDic = [[XHSQLiteDBCore ShareXHSQLiteDBCore] selecteRecord:selectSqlStr];
    Class modleClass = [modle class];
    for (NSString* key in [selectedResultListDic allKeys]) {
        id newModle = [[modleClass alloc] init];
#warning 用 Modle 的具体类型取代 id ，setValue: 的具体数据类型处理
        [newModle setValue:[selectedResultListDic objectForKey:key] forKey:key];
        [selectedModleListArr addObject:newModle];
    }
    
    return selectedModleListArr;
}

-(BOOL) updateRecordForModle:(id)modle refrenceModle:(id)refModle {
    
    kJudgeInputModle(modle)
    
    if (![self createTableFromModle:modle]) {
        return NO;
    }
    
    NSString* updateSqlStr = [XHSQLSentenceGenerator generateUpdateRecordSqlWithModle:modle refModle:refModle];
    
    NSLog(@"updateSqlStr = %@", updateSqlStr);
    
    return [[XHSQLiteDBCore ShareXHSQLiteDBCore] updateRecord:updateSqlStr];
}

-(BOOL)deleteRecordOfModle:(id)modle {
    
    kJudgeInputModle(modle)
    
    if (![self createTableFromModle:modle]) {
        return NO;
    }
    
    NSString* deleteSqlStr = [XHSQLSentenceGenerator generateDelRecordSqlWithModle:modle];
    
    NSLog(@"deleteSqlStr = %@", deleteSqlStr);
    
    return [[XHSQLiteDBCore ShareXHSQLiteDBCore] deleteRecord:deleteSqlStr];
}

@end
