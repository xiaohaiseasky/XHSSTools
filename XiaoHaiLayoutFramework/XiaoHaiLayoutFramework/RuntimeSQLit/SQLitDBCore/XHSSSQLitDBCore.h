//
//  XHSSSQLitDBCore.h
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2018/1/23.
//  Copyright © 2018年 XiaoHai. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface XHSSSQLitDBCore : NSObject

#pragma mark - 数据库操作
/**
 * 打开数据库（路径应该可以自定义）
 */
-(BOOL) openDatabase;

/**
 * 关闭数据库
 */
-(BOOL) closeDatabase;

#pragma mark - 表操作
/**
 * 创建表
 */
-(BOOL) createTable:(NSString*)createTableStr;

/**
 * 添加纪录
 */
-(BOOL) addRecord:(NSString*)sqlStr;

/**
 * 查询纪录
 */
-(NSDictionary*) selecteRecord:(NSString*)sqlStr;

/**
 * 更新记录
 */
-(BOOL) updateRecord:(NSString*)sqlStr;

/**
 * 删除记录
 */
-(BOOL)deleteRecord:(NSString*)sqlStr;

#pragma mark - 生成SQL语句

#pragma mark -

#pragma mark -

#pragma mark -

#pragma mark -

@end
