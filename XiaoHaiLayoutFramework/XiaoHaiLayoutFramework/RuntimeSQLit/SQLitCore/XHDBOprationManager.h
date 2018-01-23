//
//  XHDBOprationManager.h
//  RuntimeSQLit
//
//  Created by Admin on 16/9/23.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHDBOprationManager : NSObject

/**
 * 获取单例对象 XHDBOprationManager
 */
+(instancetype) ShareXHDBOprationManager;


/**
 * 添加 modle 对应的一条记录
 */
-(BOOL) addRecordWithModle:(id)modle;

/**
 * 查询所有以modle 对应的属性为条件的记录
 */
-(NSArray*) selecteRecordOfModle:(id)modle;

/**
 * 更新所有以refModle 对应的属性为条件的记录 的状态为modle 的对应属性的值
 */
-(BOOL) updateRecordForModle:(id)modle refrenceModle:(id)refModle;

/**
 * 删除所有以modle 对应属性为条件的记录
 */
-(BOOL)deleteRecordOfModle:(id)modle;

@end
