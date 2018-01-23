//
//  XHSQLSentenceGenerator.m
//  RuntimeSQLit
//
//  Created by Admin on 16/9/23.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHSQLSentenceGenerator.h"
#import "XHGetModleRuntimeInfo.h"
#import "XHDBCommon.h"

@implementation XHSQLSentenceGenerator

/**
 * 生成创建表的 SQL 语句
 */
+(NSString*) generateCreateTableSqlWithModle:(id)modle {
    
    NSMutableString* sqlStr = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id INTEGER PRIMARY KEY AUTOINCREMENT, ", NSStringFromClass([modle class])];
    
    NSArray* propertyInfoArr = [XHGetModleRuntimeInfo getPropertyListOfModle:modle];
    NSArray* nameArr = [[XHSQLSentenceGenerator generateColumnsAndValuesStrWithArr:propertyInfoArr] objectForKey:kColumnsArrKey];
    NSArray* valueArr = [[XHSQLSentenceGenerator generateColumnsAndValuesStrWithArr:propertyInfoArr] objectForKey:kValuesArrKey];
    NSArray* typeArr = [[XHSQLSentenceGenerator generateColumnsAndValuesStrWithArr:propertyInfoArr] objectForKey:kTypesArrKey];
#warning  处理属性时需要 处理属性值为 nil 的时候 导致的数组元素不对应的问题
    for (int i = 0; i < nameArr.count; ++i) {
        NSString* name = [nameArr objectAtIndex:i];
        id value = [valueArr objectAtIndex:i];
        XHPropertyBaseType type = [[typeArr objectAtIndex:i] integerValue];
        
        // name CHAR, sex CHAR)
        NSString* sqlComponentStr;
        if (type & XHPropertyBaseTypeNumber) {
            sqlComponentStr = [NSString stringWithFormat:@"%@ CHAR, ", name];
        }
        else if (type & XHPropertyBaseTypeClass) {
            if ([[value class] isKindOfClass:[NSNumber class]]) {
                sqlComponentStr = [NSString stringWithFormat:@"%@ CHAR, ", name];
            }
            else {// if ([[value class] isKindOfClass:[NSString class]]) {
                sqlComponentStr = [NSString stringWithFormat:@"%@ CHAR, ", name];
            }
#warning  其他类型未做处理
        }
        
        if (!sqlComponentStr) {
            continue;
        }
        
        [sqlStr appendString:sqlComponentStr];
    }
    NSString* createTableStr = [sqlStr stringByReplacingCharactersInRange:NSMakeRange(sqlStr.length-2, 2) withString:@")"];
    
    return createTableStr;
}


/**
 * 生成添加记录的 SQL 语句
 */
+(NSString*) generateAddRecordSqlWithModle:(id)modle {
    
    NSArray* propertyInfoArr = [XHGetModleRuntimeInfo getPropertyListOfModle:modle];
    
    NSDictionary* resultDic = [self generateColumnsAndValuesStrWithArr:propertyInfoArr];
    
    NSString* insertSqlStr = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES ('%@')", NSStringFromClass([modle class]), [resultDic objectForKey:kColumnsStrKey], [resultDic objectForKey:kValuesStrKey]];
    
    return insertSqlStr;
}

/**
 * 生成删除记录的 SQL 语句
 */
+(NSString*) generateDelRecordSqlWithModle:(id)modle {
    
    NSArray* propertyInfoArr = [XHGetModleRuntimeInfo getPropertyListOfModle:modle];
    
    NSString* noWhereComponentStr = [NSString stringWithFormat:@"DELETE FROM %@", NSStringFromClass([modle class])];
    
    NSString* whereComponentStr = [self generateWhereCondationComponentStrWithArr:propertyInfoArr];
    
    NSMutableString* deleteSqlStr = [NSMutableString stringWithString:noWhereComponentStr];
    
    if (whereComponentStr != nil && whereComponentStr.length > 0) {
        [deleteSqlStr appendFormat:@" WHERE %@", whereComponentStr];
    }
    
    return deleteSqlStr;
}

/**
 * 生成修改记录的 SQL 语句
 */
+(NSString*) generateUpdateRecordSqlWithModle:(id)modle refModle:(id)refModle {
    
    NSArray* propertyInfoArr = [XHGetModleRuntimeInfo getPropertyListOfModle:modle];
    
    NSString* updateComponentStr = [self generateColumnAndValuePairsStrWithArr:propertyInfoArr];
    
    NSString* noWhereComponentStr = [NSString stringWithFormat:@"UPDATE %@ SET %@", NSStringFromClass([modle class]), updateComponentStr];
    
    
    NSArray* refModlePropertyInfoArr = [XHGetModleRuntimeInfo getPropertyListOfModle:refModle];
    
    NSString* whereComponentStr = [self generateWhereCondationComponentStrWithArr:refModlePropertyInfoArr];
    
    NSMutableString* updateSqlStr = [NSMutableString stringWithString:noWhereComponentStr];
    
    if (whereComponentStr != nil && whereComponentStr.length > 0) {
        [updateSqlStr appendFormat:@" WHERE %@", whereComponentStr];
    }
    
    return updateSqlStr;
}

/**
 * 生成查询记录的 SQL 语句
 */
+(NSString*)generateSelectRecordSqlWithModle:(id)modle {
    
    NSString* noWhereComponentStr = [NSString stringWithFormat:@"SELECT * FROM %@", NSStringFromClass([modle class])];
    
    NSArray* propertyInfoArr = [XHGetModleRuntimeInfo getPropertyListOfModle:modle];
    
    NSString* whereComponentStr = [self generateWhereCondationComponentStrWithArr:propertyInfoArr];
    
    NSMutableString* selectSqlStr = [NSMutableString stringWithString:noWhereComponentStr];
    
    if (whereComponentStr != nil && whereComponentStr.length > 0) {
        [selectSqlStr appendFormat:@" WHERE %@", whereComponentStr];
    }
    
    return selectSqlStr;
}


/**
 * 插入 形式 字符串
 */
+(NSDictionary*) generateColumnsAndValuesStrWithArr:(NSArray*)array {
    
    NSMutableDictionary* resDic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSMutableArray* propertyNameArr = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray* propertyValueArr = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray* propertyTypeArr = [NSMutableArray arrayWithCapacity:1];
    
    for (NSDictionary* dic in array) {
        [propertyNameArr addObject:[dic objectForKey:kPropertyName]];
        [propertyValueArr addObject:[dic objectForKey:kPropertyValue]];
        [propertyTypeArr addObject:[dic objectForKey:kPropertyType]];
    }
    
    NSString* columnsStr = [propertyNameArr componentsJoinedByString:@", "];
#warning  属性字段为 数字 ／ 字符串 时候 对 "'" 的处理
    NSString* valuesStr = [propertyValueArr componentsJoinedByString:@"', '"];
    
    [resDic setObject:columnsStr forKey:kColumnsStrKey];
    [resDic setObject:valuesStr forKey:kValuesStrKey];
    
    [resDic setObject:propertyNameArr forKey:kColumnsArrKey];
    [resDic setObject:propertyValueArr forKey:kValuesArrKey];
    [resDic setObject:propertyTypeArr forKey:kTypesArrKey];
    
    return resDic;
}

/**
 * 更新 形式 字符串
 */
+(NSString*)generateColumnAndValuePairsStrWithArr:(NSArray*)array {
    
    NSMutableString* resStr = [NSMutableString string];
    
    for (NSDictionary* dic in array) {
        [resStr appendFormat:@"%@ = '%@', ", [dic objectForKey:kPropertyName], [dic objectForKey:kPropertyValue]];
    }
    
    return [resStr substringToIndex:resStr.length-2];
}

/**
 * where 条件语句 字符串
 */
+(NSString*)generateWhereCondationComponentStrWithArr:(NSArray*)array {
    
    NSMutableString* resStr = [NSMutableString string];
#warning  参数为空时候的处理
    for (NSDictionary* dic in array) {
        [resStr appendFormat:@"%@ = '%@' AND ", [dic objectForKey:kPropertyName], [dic objectForKey:kPropertyValue]];
    }
    
    return [resStr substringToIndex:resStr.length-5];
}

@end
