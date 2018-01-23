//
//  XHDataTypeClassify.h
//  RuntimeSQLit
//
//  Created by Admin on 16/9/23.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHDataTypeClassify : NSObject

/**
 * 判断数据是否来自 Foundation 框架
 */
+(BOOL) isClassFromFoundation:(Class)c;

@end
