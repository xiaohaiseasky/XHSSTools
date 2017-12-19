//
//  XHSSLayoutManager.m
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/10/16.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import "XHSSLayoutManager.h"

#import "UIView+XHSSFrameTools.h"

@interface XHSSLayoutManager ()

// 视图的 尺寸属性值
@property (nonatomic, assign) CGFloat topValue;
@property (nonatomic, assign) CGFloat leftValue;
@property (nonatomic, assign) CGFloat bottomValue;
@property (nonatomic, assign) CGFloat rightValue;
@property (nonatomic, assign) CGFloat widthValue;
@property (nonatomic, assign) CGFloat heightValue;

@property (nonatomic, assign) CGPoint originValue;
@property (nonatomic, assign) CGPoint centerValue;
@property (nonatomic, assign) CGSize boundsValue;

// 可存储的四种数据类型
@property (nonatomic, assign) CGFloat floatValue;
@property (nonatomic, assign) CGPoint pointValue;
@property (nonatomic, assign) CGSize sizeValue;
@property (nonatomic, assign) CGRect rectValue;

// 当前存储数据的类型
@property (nonatomic, assign) XHSSSaveValueType valueType;

// 设置适配比率相关
@property (nonatomic, assign) CGFloat adaptationRate;
@property (nonatomic, assign) CGFloat baseScreenWidth;
#define kXHSSCurrentScreenWidth [UIScreen mainScreen].bounds.size.width;

// 连续调用 uiview 的 尺寸属性时，保存操作的数组
@property (nonatomic, strong) NSMutableArray *oprationStack;

@end


#define kManager [XHSSLayoutManager shareManager]
static XHSSLayoutManager *manager;
static dispatch_once_t onceToken;

@implementation XHSSLayoutManager

+ (instancetype)shareManager {
    dispatch_once(&onceToken, ^{
        manager = [[[XHSSLayoutManager class] alloc] init];
        [manager initOprationStack];
    });
    return manager;
}

#pragma mark - ==========PRIVATE METHOD==========
// 初始化栈结构
- (void)initOprationStack {
    _oprationStack = [NSMutableArray array];
}

//入栈
- (void)pushStack:(NSArray *)item {
    [_oprationStack addObject:item];
}

// 出栈
- (NSArray *)popStack {
    NSArray *item = [_oprationStack lastObject];
    [_oprationStack removeLastObject];
    return item;
}

// 封装一个枚举类型到 NSValue
- (NSValue *)valueWithEnum:(XHSSSaveValueType)typeEnum {
    return [NSValue value:&typeEnum withObjCType:@encode(XHSSSaveValueType)];
}

///
- (CGFloat)adaptationRateWithScreenWidth:(CGFloat)screeWidth {
    return [UIScreen mainScreen].bounds.size.width/screeWidth;
}

/**
 获取按屏幕比例适配的 比率
 
 @return            :   比率
 */
- (CGFloat)adaptionRate {
    return self.adaptationRate;
}

/**
 设置完全适配情况下的基础屏幕尺寸, 如果不设置则当前适配为固定坐标适配
 
 @param screenWidth :   当前布局所在的屏幕宽度
 */
- (void)setAdaptionBaseScreenWidth:(CGFloat)screenWidth {
    _baseScreenWidth = screenWidth;
    _adaptationRate = [self adaptationRateWithScreenWidth:screenWidth];
}

/**
 验证当前操作的数据类型是否合法
 
 @param valueType   :   当前操作的数据类型
 @return            :   验证结果
 */
- (BOOL)verifyValueType:(XHSSSaveValueType)valueType {
    if ([XHSSLayoutManager shareManager].valueType != valueType) {
        return NO;
    }
    return YES;
}

#pragma mark - ==========PUBLIC API INTERFACE==========
#pragma mark - ==========newVersion==========
- (void)addFloatValue:(CGFloat)floatValue forValueType:(XHSSSaveValueType)valueType {
    [kManager pushStack:@[@(floatValue), [kManager valueWithEnum:valueType]]];
}
- (CGFloat)floatValueForValueType:(XHSSSaveValueType)valueType {
    return [(NSNumber *)[[kManager popStack] firstObject] floatValue];
}

- (void)addPointValue:(CGFloat)pointValue forValueType:(XHSSSaveValueType)valueType {
    [kManager pushStack:@[@(pointValue), @(valueType)]];
}
- (CGPoint)pointValueForValueType:(XHSSSaveValueType)valueType {
    return [(NSValue *)[[kManager popStack] firstObject] CGPointValue];
}

- (void)addSizeValue:(CGFloat)sizeValue forValueType:(XHSSSaveValueType)valueType {
    [kManager pushStack:@[@(sizeValue), @(valueType)]];
}
- (CGSize)sizeValueForValueType:(XHSSSaveValueType)valueType {
    return [(NSValue *)[[kManager popStack] firstObject] CGSizeValue];
}

- (NSArray *)valueWithType {
    return [kManager popStack];
}

- (void)popStackEmptyWithItemAction:(void(^)(NSArray *stackItem))oneOpration {
    while (self.oprationStack.count > 0) {
        NSArray *item = [self valueWithType];
        if (oneOpration) {
            oneOpration(item);
        }
    }
}

#pragma mark - ==========preVersion==========
/**
 以特定的类型描述存储一个 float 值
 
 @param floatValue  :   要存储的 float 值
 @param valueType   :   float 值表示的类型
 */
- (void)saveFloatValue:(CGFloat)floatValue withValueType:(XHSSSaveValueType)valueType {
    [XHSSLayoutManager shareManager].floatValue = floatValue;
    [XHSSLayoutManager shareManager].valueType = valueType;
}

/**
 以特定的类型描述获取一个 float 值
 
 @param valueType   :   要获取的 float 值表示的类型
 @return            :   获取到的 float 值
 */
- (CGFloat)floatValueWithValueType:(XHSSSaveValueType)valueType {
#warning valueType
    if (valueType != [XHSSLayoutManager shareManager].valueType) {
        return 0;
    }
    return [XHSSLayoutManager shareManager].floatValue;
}



/**
 以特定的类型描述存储一个 CGPoint 值
 
 @param pointValue   :   要存储的 CGPoint 值
 @param valueType    :   CGPoint 值表示的类型
 */
- (void)savePointValue:(CGPoint)pointValue withValueType:(XHSSSaveValueType)valueType {
    [XHSSLayoutManager shareManager].pointValue = pointValue;
    [XHSSLayoutManager shareManager].valueType = valueType;
}

/**
 以特定的类型描述获取一个 CGPoint 值
 
 @param valueType    :   要获取的 CGPoint 值表示的类型
 @return             :   获取到的 CGPoint 值
 */
- (CGPoint)pointValueWithValueType:(XHSSSaveValueType)valueType {
#warning valueType
    if (valueType != [XHSSLayoutManager shareManager].valueType) {
        return CGPointZero;
    }
    return [XHSSLayoutManager shareManager].pointValue;
}



/**
 以特定的类型描述存储一个 CGSize 值
 
 @param sizeValue    :   要存储的 CGSize 值
 @param valueType    :   CGSize 值表示的类型
 */
- (void)saveSizeValue:(CGSize)sizeValue withValueType:(XHSSSaveValueType)valueType {
    [XHSSLayoutManager shareManager].sizeValue = sizeValue;
    [XHSSLayoutManager shareManager].valueType = valueType;
}

/**
 以特定的类型描述获取一个 CGSize 值
 
 @param valueType     :   要获取的 CGSize 值表示的类型
 @return              :   获取到的 CGSize 值
 */
- (CGSize)sizeValueWithValueType:(XHSSSaveValueType)valueType {
#warning valueType
    if (valueType != [XHSSLayoutManager shareManager].valueType) {
        return CGSizeZero;
    }
    return [XHSSLayoutManager shareManager].sizeValue;
}

@end
