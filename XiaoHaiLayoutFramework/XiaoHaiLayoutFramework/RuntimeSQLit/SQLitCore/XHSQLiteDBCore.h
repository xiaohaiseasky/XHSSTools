//
//  XHSQLiteDBCore.h
//  RuntimeSQLit
//
//  Created by Admin on 16/9/23.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHSQLiteDBCore : NSObject

/**
 * 获取单例对象 XHSQLiteDBCore
 */
+(instancetype) ShareXHSQLiteDBCore;



/**
 * 打开数据库（路径应该可以自定义）
 */
-(BOOL) openDatabase;

/**
 * 关闭数据库
 */
-(BOOL) closeDatabase;

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

@end
