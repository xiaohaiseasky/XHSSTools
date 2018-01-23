//
//  XHSSDataTypeClassify.h
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2018/1/23.
//  Copyright © 2018年 XiaoHai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHSSDataTypeClassify : NSObject

/**
 * 判断数据是否来自 Foundation 框架
 */
+(BOOL) isClassFromFoundation:(Class)c;

@end
