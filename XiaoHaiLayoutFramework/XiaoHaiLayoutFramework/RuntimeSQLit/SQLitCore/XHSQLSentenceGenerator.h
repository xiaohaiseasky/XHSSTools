//
//  XHSQLSentenceGenerator.h
//  RuntimeSQLit
//
//  Created by Admin on 16/9/23.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHSQLSentenceGenerator : NSObject

/**
 * 生成创建表的 SQL 语句
 */
+(NSString*) generateCreateTableSqlWithModle:(id)modle;


/**
 * 生成添加记录的 SQL 语句
 */
+(NSString*) generateAddRecordSqlWithModle:(id)modle;

/**
 * 生成删除记录的 SQL 语句
 */
+(NSString*) generateDelRecordSqlWithModle:(id)modle;

/**
 * 生成修改记录的 SQL 语句
 */
+(NSString*) generateUpdateRecordSqlWithModle:(id)modle refModle:(id)refModle;

/**
 * 生成查询记录的 SQL 语句
 */
+(NSString*)generateSelectRecordSqlWithModle:(id)modle;


/**
 * 插入 形式 字符串
 */
+(NSDictionary*) generateColumnsAndValuesStrWithArr:(NSArray*)array;

/**
 * 更新 形式 字符串
 */
+(NSString*)generateColumnAndValuePairsStrWithArr:(NSArray*)array;

/**
 * where 条件语句 字符串
 */
+(NSString*)generateWhereCondationComponentStrWithArr:(NSArray*)array;

@end
