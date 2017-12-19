//
//  XHSSLayoutManager.h
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/10/16.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XHSSSaveValueType) {
    XHSSSaveValueTypeTop,
    XHSSSaveValueTypeLeft,
    XHSSSaveValueTypeBottom,
    XHSSSaveValueTypeRight,
    XHSSSaveValueTypeWidth,
    XHSSSaveValueTypeHeight,
    
    XHSSSaveValueTypeOrigin,
    XHSSSaveValueTypeCenter,
    
    XHSSSaveValueTypeBounds
};

@interface XHSSLayoutManager : NSObject

/**
 单例函数

 @return    :   返回的单例对象
 */
+ (instancetype)shareManager;


/**
 获取按屏幕比例适配的 比率

 @return            :   比率
 */
- (CGFloat)adaptionRate;

/**
 设置完全适配情况下的基础屏幕尺寸, 如果不设置则当前适配为固定坐标适配

 @param screenWidth :   当前布局所在的屏幕宽度
 */
- (void)setAdaptionBaseScreenWidth:(CGFloat)screenWidth;

/**
 验证当前操作的数据类型是否合法

 @param valueType   :   当前操作的数据类型
 @return            :   验证结果
 */
- (BOOL)verifyValueType:(XHSSSaveValueType)valueType;

#pragma mark - newVersion
- (void)addFloatValue:(CGFloat)floatValue forValueType:(XHSSSaveValueType)valueType;
- (CGFloat)floatValueForValueType:(XHSSSaveValueType)valueType;

- (void)addPointValue:(CGFloat)pointValue forValueType:(XHSSSaveValueType)valueType;
- (CGPoint)pointValueForValueType:(XHSSSaveValueType)valueType;

- (void)addSizeValue:(CGFloat)sizeValue forValueType:(XHSSSaveValueType)valueType;
- (CGSize)sizeValueForValueType:(XHSSSaveValueType)valueType;

- (NSArray *)valueWithType;

- (void)popStackEmptyWithItemAction:(void(^)(NSArray *stackItem))oneOpration;

#pragma mark - preVersion
/**
 以特定的类型描述存储一个 float 值

 @param floatValue  :   要存储的 float 值
 @param valueType   :   float 值表示的类型
 */
- (void)saveFloatValue:(CGFloat)floatValue withValueType:(XHSSSaveValueType)valueType;

/**
 以特定的类型描述获取一个 float 值

 @param valueType   :   要获取的 float 值表示的类型
 @return            :   获取到的 float 值
 */
- (CGFloat)floatValueWithValueType:(XHSSSaveValueType)valueType;



/**
 以特定的类型描述存储一个 CGPoint 值

 @param pointValue   :   要存储的 CGPoint 值
 @param valueType    :   CGPoint 值表示的类型
 */
- (void)savePointValue:(CGPoint)pointValue withValueType:(XHSSSaveValueType)valueType;

/**
 以特定的类型描述获取一个 CGPoint 值

 @param valueType    :   要获取的 CGPoint 值表示的类型
 @return             :   获取到的 CGPoint 值
 */
- (CGPoint)pointValueWithValueType:(XHSSSaveValueType)valueType;



/**
 以特定的类型描述存储一个 CGSize 值

 @param sizeValue    :   要存储的 CGSize 值
 @param valueType    :   CGSize 值表示的类型
 */
- (void)saveSizeValue:(CGSize)sizeValue withValueType:(XHSSSaveValueType)valueType;

/**
 以特定的类型描述获取一个 CGSize 值

 @param valueType     :   要获取的 CGSize 值表示的类型
 @return              :   获取到的 CGSize 值
 */
- (CGSize)sizeValueWithValueType:(XHSSSaveValueType)valueType;


@end
