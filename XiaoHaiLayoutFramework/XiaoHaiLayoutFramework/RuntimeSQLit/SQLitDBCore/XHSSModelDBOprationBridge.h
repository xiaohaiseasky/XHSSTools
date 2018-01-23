//
//  XHSSModelDBOprationBridge.h
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2018/1/23.
//  Copyright © 2018年 XiaoHai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHSSModelDBOprationBridge : NSObject

#pragma mark - 表操作
/**
 * 创建表
 */
-(BOOL) createTable:(id)refModel;

/**
 * 添加纪录
 */
/// *** 添加一条记录 ***
-(BOOL) addRecord:(id)dataModel;
/// *** 添加多条记录 ***
-(BOOL) addRecords:(NSArray*)dataModelArr;

/**
 * 查询纪录
 */
-(NSDictionary*) selecteRecord:(id)refModel;

/**
 * 更新记录
 */
-(BOOL) updateRecord:(id)dataModel condition:(id)refModel;

/**
 * 删除记录
 */
-(BOOL) deleteRecord:(id)refModel;

@end
