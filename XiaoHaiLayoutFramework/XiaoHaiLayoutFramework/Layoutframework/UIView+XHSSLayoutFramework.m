//
//  UIView+XHSSLayoutFramework.m
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/10/17.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//


#import "UIView+XHSSLayoutFramework.h"
#import "XHSSLayoutManager.h"

typedef NS_ENUM(NSUInteger, XHSSOprateBackStackType) {
    XHSSOprateBackStackTypeAddByNum,
    XHSSOprateBackStackTypeSubByNum,
    XHSSOprateBackStackTypeEqualToNum,
    XHSSOprateBackStackTypeAddByView,
    XHSSOprateBackStackTypeSubByView,
    XHSSOprateBackStackTypeEqualToView,
};

typedef NS_ENUM(NSUInteger, XHSSValueType) {
    XHSSValueTypeFloat,
    XHSSValueTypePoint,
    XHSSValueTypeSize,
    XHSSValueTypeRect,
    XHSSValueTypeView,
};


@implementation UIView (XHSSLayoutFramework)

#pragma mark - macro
#define kXHSSScreenFitRate  [[XHSSLayoutManager shareManager] adaptionRate]

#pragma mark - ==============参考视图===============
//===========================================================
//===========================================================
//====    　参考视图
//===========================================================
//===========================================================

#pragma mark - top
/**
 保存 self 的 top 以备后续使用
 */
- (UIView*(^)(CGFloat topDistance))topDistance {
    return ^(CGFloat topDistance) {
        [[XHSSLayoutManager shareManager] saveFloatValue:topDistance withValueType:XHSSSaveValueTypeTop];
        return self;
    };
}


/**
 设置上边距时，上侧的参考视图
 */
- (UIView*(^)(UIView *topRefView))toTopRefView {
    return ^(UIView *topRefView) {
        
        if ([self verifyCurrentOprateValueType:XHSSSaveValueTypeTop]) {
            self.y = topRefView.maxY + [[XHSSLayoutManager shareManager] floatValueWithValueType:XHSSSaveValueTypeTop];
        }
        
        return self;
    };
}

- (UIView*(^)(UIView *topRefView))toTopRefViewScreenFit {
    return ^(UIView *topRefView) {
        
        if ([self verifyCurrentOprateValueType:XHSSSaveValueTypeTop]) {
            self.y = topRefView.maxY + [[XHSSLayoutManager shareManager] floatValueWithValueType:XHSSSaveValueTypeTop]*kXHSSScreenFitRate;
        }
        
        return self;
    };
}

#pragma mark - left
/**
 保存 self 的 left 以备后续使用
 */
- (UIView*(^)(CGFloat leftDistance))leftDistance {
    return ^(CGFloat leftDistance) {
        [[XHSSLayoutManager shareManager] saveFloatValue:leftDistance withValueType:XHSSSaveValueTypeLeft];
        return self;
    };
}

/**
 设置左边距时，左侧的参考视图
 */
- (UIView*(^)(UIView *leftRefView))toLeftRefView {
    return ^(UIView *leftRefView) {
        
        if ([self verifyCurrentOprateValueType:XHSSSaveValueTypeLeft]) {
            self.x = leftRefView.maxX + [[XHSSLayoutManager shareManager] floatValueWithValueType:XHSSSaveValueTypeLeft];
        }
        
        return self;
    };
}

- (UIView*(^)(UIView *leftRefView))toLeftRefViewScreenFit {
    return ^(UIView *leftRefView) {
        
        if ([self verifyCurrentOprateValueType:XHSSSaveValueTypeLeft]) {
            self.x = leftRefView.maxX + [[XHSSLayoutManager shareManager] floatValueWithValueType:XHSSSaveValueTypeLeft]*kXHSSScreenFitRate;
        }
        
        return self;
    };
}

#pragma mark - bottom
/**
 保存 self 的 bottom 以备后续使用
 */
- (UIView*(^)(CGFloat bottomDistance))bottomDistance {
    return ^(CGFloat bottomDistance) {
        [[XHSSLayoutManager shareManager] saveFloatValue:bottomDistance withValueType:XHSSSaveValueTypeBottom];
        return self;
    };
}

/**
 设置下边距时，下侧的参考视图
 */
- (UIView*(^)(UIView *bottomRefView))toBottomRefView {
    return ^(UIView *bottomRefView) {
        
        if ([self verifyCurrentOprateValueType:XHSSSaveValueTypeBottom]) {
            self.maxY = bottomRefView.y - [[XHSSLayoutManager shareManager] floatValueWithValueType:XHSSSaveValueTypeBottom];
        }
        
        return self;
    };
}

- (UIView*(^)(UIView *bottomRefView))toBottomRefViewScreenFit {
    return ^(UIView *bottomRefView) {
        
        if ([self verifyCurrentOprateValueType:XHSSSaveValueTypeBottom]) {
            self.maxY = bottomRefView.y - [[XHSSLayoutManager shareManager] floatValueWithValueType:XHSSSaveValueTypeBottom]*kXHSSScreenFitRate;
        }
        
        return self;
    };
}

#pragma mark - right
/**
 保存 self 的 right 以备后续使用
 */
- (UIView*(^)(CGFloat rightDistance))rightDistance {
    return ^(CGFloat rightDistance) {
        [[XHSSLayoutManager shareManager] saveFloatValue:rightDistance withValueType:XHSSSaveValueTypeRight];
        return self;
    };
}

/**
 设置右边距时，右侧的参考视图
 */
- (UIView*(^)(UIView *rightRefView))toRightRefView {
    return ^(UIView *rightRefView) {
        
        if ([self verifyCurrentOprateValueType:XHSSSaveValueTypeRight]) {
            self.maxX = rightRefView.x - [[XHSSLayoutManager shareManager] floatValueWithValueType:XHSSSaveValueTypeRight];
        }
        
        return self;
    };
}

- (UIView*(^)(UIView *rightRefView))toRightRefViewScreenFit {
    return ^(UIView *rightRefView) {
        
        if ([self verifyCurrentOprateValueType:XHSSSaveValueTypeRight]) {
            self.maxX = rightRefView.x - [[XHSSLayoutManager shareManager] floatValueWithValueType:XHSSSaveValueTypeRight]*kXHSSScreenFitRate;
        }
        
        return self;
    };
}

#warning 以下函数的 refView.function 会调用到本文件的 function 方法
#pragma mark - width
/**
 保存 self 的 width 以备后续使用
 */
- (UIView*(^)(CGFloat widthValue))laWidth {
    return ^(CGFloat widthValue) {
        [[XHSSLayoutManager shareManager] saveFloatValue:widthValue withValueType:XHSSSaveValueTypeWidth];
        return self;
    };
}

/**
 设置 width 时的参考视图
 */
- (UIView*(^)(UIView *refView))equalToRefViewWidth {
    return ^(UIView *refView) {
        
        if ([self verifyCurrentOprateValueType:XHSSSaveValueTypeWidth]) {
            self.width = refView.width;
#warning saved width is unused
            // [[XHSSLayoutManager shareManager] floatValueWithValueType:XHSSSaveValueTypeWidth];
        }
        
        return self;
    };
}

#pragma mark - height
/**
 保存 self 的 height 以备后续使用
 */
- (UIView*(^)(CGFloat heightValue))laHeight {
    return ^(CGFloat heightValue) {
        [[XHSSLayoutManager shareManager] saveFloatValue:heightValue withValueType:XHSSSaveValueTypeHeight];
        return self;
    };
}

/**
 设置 height 时的参考视图
 */
- (UIView*(^)(UIView *refView))equalToRefViewHeight {
    return ^(UIView *refView) {
        
        if ([self verifyCurrentOprateValueType:XHSSSaveValueTypeHeight]) {
            self.height = refView.height;
#warning saved height is unused
            // [[XHSSLayoutManager shareManager] floatValueWithValueType:XHSSSaveValueTypeHeight];
        }
        
        return self;
    };
}

#pragma mark - center
/**
 保存 self 的 center 以备后续使用
 */
- (UIView*(^)(CGPoint centerValue))laCenter {
    return ^(CGPoint centerValue) {
        [[XHSSLayoutManager shareManager] savePointValue:centerValue withValueType:XHSSSaveValueTypeCenter];
        return self;
    };
}

/**
 设置 center 时的参考视图
 */
- (UIView*(^)(UIView *refView))equalToRefViewCenter {
    return ^(UIView *refView) {
        
        if ([self verifyCurrentOprateValueType:XHSSSaveValueTypeCenter]) {
            self.selCenter = refView.center;
#warning saved center is unused
            // [[XHSSLayoutManager shareManager] floatValueWithValueType:XHSSSaveValueTypeCenter];
        }
        
        return self;
    };
}

#pragma mark - origin
/**
 保存 self 的 origin 以备后续使用
 */
- (UIView*(^)(CGPoint orignValue))laOrign {
    return ^(CGPoint orignValue) {
        [[XHSSLayoutManager shareManager] savePointValue:orignValue withValueType:XHSSSaveValueTypeOrigin];
        return self;
    };
}

/**
 设置 origin 时的参考视图
 */
- (UIView*(^)(UIView *refView))equalToRefViewOrigin {
    return ^(UIView *refView) {
        
        if ([self verifyCurrentOprateValueType:XHSSSaveValueTypeOrigin]) {
            self.selOrigin = refView.frame.origin;
#warning saved origin is unused
            // [[XHSSLayoutManager shareManager] floatValueWithValueType:XHSSSaveValueTypeOrigin];
        }
        
        return self;
    };
}

#pragma mark - bounds
/**
 保存 self 的 bounds 以备后续使用
 */
- (UIView*(^)(CGSize boundsValue))laBounds {
    return ^(CGSize boundsValue) {
        [[XHSSLayoutManager shareManager] saveSizeValue:boundsValue withValueType:XHSSSaveValueTypeBounds];
        return self;
    };
}

/**
 设置 bounds 时的参考视图
 */
- (UIView*(^)(UIView *refView))equalToRefViewBounds {
    return ^(UIView *refView) {
        
        if ([self verifyCurrentOprateValueType:XHSSSaveValueTypeBounds]) {
            self.selBounds = refView.bounds.size;
#warning saved bounds is unused
            // [[XHSSLayoutManager shareManager] floatValueWithValueType:XHSSSaveValueTypeBounds];
        }
        
        return self;
    };
}


#pragma mark - ==============固定数值===============
//===========================================================
//===========================================================
//====    固定数值
//===========================================================
//===========================================================

/**
 left
 默认只适配 左边到父视图的距离
 */
- (UIView*(^)(CGFloat leftValue))leftEqualToNum {
    return ^(CGFloat leftValue) {
        self.x = leftValue;
        return self;
    };
}

- (UIView*(^)(CGFloat leftValue))leftEqualToNumScreenFit {
    return ^(CGFloat leftValue) {
        self.x = leftValue*kXHSSScreenFitRate;
        return self;
    };
}


/**
 right
 默认只适配 右边到父视图的距离
 */
- (UIView*(^)(CGFloat rightValue))rightEqualToNum {
    return ^(CGFloat rightValue) {
        self.maxX = self.superview.width - rightValue;
        return self;
    };
}

- (UIView*(^)(CGFloat rightValue))rightEqualToNumScreenFit {
    return ^(CGFloat rightValue) {
        self.maxX = self.superview.width - rightValue*kXHSSScreenFitRate;
        return self;
    };
}

/**
 top
 默认只适配 上边到父视图的距离
 */
- (UIView*(^)(CGFloat topValue))topEqualToNum {
    return ^(CGFloat topValue) {
        self.y = topValue;
        return self;
    };
}

- (UIView*(^)(CGFloat topValue))topEqualToNumScreenFit {
    return ^(CGFloat topValue) {
        CGFloat r = kXHSSScreenFitRate;
        self.y = topValue*kXHSSScreenFitRate;
        return self;
    };
}

/**
 bottom
 默认只适配 底边到父视图的距离
 */
- (UIView*(^)(CGFloat bottomValue))bottomEqualToNum {
    return ^(CGFloat bottomValue) {
        self.maxY = self.superview.height - bottomValue;
        return self;
    };
}

- (UIView*(^)(CGFloat bottomValue))bottomEqualToNumScreenFit {
    return ^(CGFloat bottomValue) {
        self.maxY = self.superview.height - bottomValue*kXHSSScreenFitRate;
        return self;
    };
}

/**
 width
 适配宽度到具体数值
 */
- (UIView*(^)(CGFloat widthValue))widthEqualToNum {
    return ^(CGFloat widthValue) {
        self.width = widthValue;
        return self;
    };
}

- (UIView*(^)(CGFloat widthValue))widthEqualToNumScreenFit {
    return ^(CGFloat widthValue) {
        self.width = widthValue*kXHSSScreenFitRate;
        return self;
    };
}

/**
 height
 适配高度到具体数值
 */
- (UIView*(^)(CGFloat heightValue))heightEqualToNum {
    return ^(CGFloat heightValue) {
        self.height = heightValue;
        return self;
    };
}

- (UIView*(^)(CGFloat heightValue))heightEqualToNumScreenFit {
    return ^(CGFloat heightValue) {
        self.height = heightValue*kXHSSScreenFitRate;
        return self;
    };
}

/**
 center
 适配中心点到具体位置
 */
- (UIView*(^)(CGPoint centerValue))centerEqualToNum {
    return ^(CGPoint centerValue) {
        self.selCenter = centerValue;
        return self;
    };
}

- (UIView*(^)(CGPoint centerValue))centerEqualToNumScreenFit {
    return ^(CGPoint centerValue) {
        self.selCenter = CGPointMake(centerValue.x*kXHSSScreenFitRate, centerValue.y*kXHSSScreenFitRate);
        return self;
    };
}


/**
 origin
 适配原点到具体位置
 */
- (UIView*(^)(CGPoint originValue))originEqualToNum {
    return ^(CGPoint originValue) {
        self.selOrigin = originValue;
        return self;
    };
}

- (UIView*(^)(CGPoint originValue))originEqualToNumScreenFit {
    return ^(CGPoint originValue) {
        self.selOrigin = CGPointMake(originValue.x*kXHSSScreenFitRate, originValue.y*kXHSSScreenFitRate);
        return self;
    };
}


/**
  bounds
  适配边框到具体尺寸
 */
- (UIView*(^)(CGSize sizeValue))sizeEqualToNum {
    return ^(CGSize sizeValue) {
        CGRect oldBounds = self.bounds;
        oldBounds.size = sizeValue;
        self.bounds = oldBounds;
        return self;
    };
}

- (UIView*(^)(CGSize sizeValue))sizeEqualToNumScreenFit {
    return ^(CGSize sizeValue) {
        CGRect oldBounds = self.bounds;
        oldBounds.size = CGSizeMake(sizeValue.width*kXHSSScreenFitRate, sizeValue.height*kXHSSScreenFitRate);
        self.bounds = oldBounds;
        return self;
    };
}

#pragma mark - ==============视图相等==============
//===========================================================
//===========================================================
//====    　视图相等
//===========================================================
//===========================================================

/**
 top
 */
- (UIView*(^)(UIView  *refView))topEqualToView {
    return ^(UIView  *refView) {
        self.y = refView.y;
        return self;
    };
}

/**
 left
 */
- (UIView*(^)(UIView  *refView))leftEqualToView {
    return ^(UIView  *refView) {
        self.x = refView.x;
        return self;
    };
}

/**
 bottom
 */
- (UIView*(^)(UIView  *refView))bottomEqualToView {
    return ^(UIView  *refView) {
        self.maxY = refView.maxY;
        return self;
    };
}

/**
 right
 */
- (UIView*(^)(UIView  *refView))rightEqualToView {
    return ^(UIView  *refView) {
        self.maxX = refView.maxX;
        return self;
    };
}

/**
 width
 */
- (UIView*(^)(UIView  *refView))widthEqualToView {
    return ^(UIView  *refView) {
        self.width = refView.width;
        return self;
    };
}

/**
 height
 */
- (UIView*(^)(UIView  *refView))heightEqualToView {
    return ^(UIView  *refView) {
        self.height = refView.height;
        return self;
    };
}

/**
 center
 */
- (UIView*(^)(UIView  *refView))centerEqualToView {
    return ^(UIView  *refView) {
        self.selCenter = refView.center;
        return self;
    };
}

/**
 center point
 */
- (UIView*(^)(UIView  *refView))centerEqualToViewCenterPoint {
    return ^(UIView  *refView) {
        self.selCenter = CGPointMake(refView.frame.size.width/2.0, refView.frame.size.height/2.0);
        return self;
    };
}

/**
 origin
 */
- (UIView*(^)(UIView  *refView))originEqualToView {
    return ^(UIView  *refView) {
        self.selOrigin = refView.frame.origin;
        return self;
    };
}

/**
 size
 */
- (UIView*(^)(UIView  *refView))sizeEqualToView {
    return ^(UIView  *refView) {
        CGRect oldBounds = self.bounds;
        oldBounds.size = refView.bounds.size;
        self.bounds = oldBounds;
        return self;
    };
}

#pragma mark - ==============支持连续尺寸属性调用==============
//===========================================================
//===========================================================
//====    　支持连续尺寸属性调用
//===========================================================
//===========================================================


/**
 top
 */
- (UIView*(^)(void))top {
    return ^(void) {
        [[XHSSLayoutManager shareManager] addFloatValue:self.x forValueType:XHSSSaveValueTypeTop];
        return self;
    };
}

/**
 left
 */
- (UIView*(^)(void))left {
    return ^(void) {
        [[XHSSLayoutManager shareManager] addFloatValue:self.x forValueType:XHSSSaveValueTypeLeft];
        return self;
    };
}

#warning search maxX maxY
/**
 bottom
 */
- (UIView*(^)(void))bottom {
    return ^(void) {
        [[XHSSLayoutManager shareManager] addFloatValue:self.superview.height-self.maxY forValueType:XHSSSaveValueTypeBottom];
        return self;
    };
}

/**
 right
 */
- (UIView*(^)(void))right {
    return ^(void) {
        [[XHSSLayoutManager shareManager] addFloatValue:self.superview.width-self.maxX forValueType:XHSSSaveValueTypeLeft];
        return self;
    };
}

/**
 width
 */
- (UIView*(^)(void))width {
    return ^(void) {
        [[XHSSLayoutManager shareManager] addFloatValue:self.width forValueType:XHSSSaveValueTypeWidth];
        return self;
    };
}

/**
 height
 */
- (UIView*(^)(void))height {
    return ^(void) {
        [[XHSSLayoutManager shareManager] addFloatValue:self.height forValueType:XHSSSaveValueTypeHeight];
        return self;
    };
}

/**
 addByNum
 在原有尺寸数据的基础上增加一个 固定数值
 */
- (UIView*(^)(CGFloat floatValue))addByNum {
    return ^(CGFloat floatValue) {
        [self oprateBackFormStack:@(floatValue) oprateType:XHSSOprateBackStackTypeAddByNum refView:self];
        return self;
    };
}

/**
 subByNum
 在原有尺寸数据的基础上减少一个 固定数值
 */
- (UIView*(^)(CGFloat floatValue))subByNum {
    return ^(CGFloat floatValue) {
        [self oprateBackFormStack:@(floatValue) oprateType:XHSSOprateBackStackTypeSubByNum refView:self];
        return self;
    };
}

/**
 equalToNum
 设置现有尺寸为一个新的 固定数值
 */
- (UIView*(^)(CGFloat floatValue))equalToNum {
    return ^(CGFloat floatValue) {
        [self oprateBackFormStack:@(floatValue) oprateType:XHSSOprateBackStackTypeEqualToNum refView:self];
        return self;
    };
}

#warning 以下三个方法计算逻辑不对！！！！！！！！！！！！！！！
/**
 addByView
 设置现有尺寸为 在某个参照视图相应尺寸属性基础上 增加 一个固定数值
 */
- (UIView*(^)(UIView *refView, CGFloat addNum))addByView {
    return ^(UIView *refView, CGFloat addNum) {
        [self oprateBackFormStack:@(addNum) oprateType:XHSSOprateBackStackTypeAddByView refView:refView];
        return self;
    };
}

/**
 subByView
 设置现有尺寸为 在某个参照视图相应尺寸属性基础上 减少 一个固定数值
 */
- (UIView*(^)(UIView *refView, CGFloat subNum))subByView {
    return ^(UIView *refView, CGFloat subNum) {
        [self oprateBackFormStack:@(subNum) oprateType:XHSSOprateBackStackTypeSubByView refView:refView];
        return self;
    };
}

/**
 equalToView
 设置现有尺寸为 与某个参照视图相应尺寸属性相等
 */
- (UIView*(^)(UIView *refView))equalToView {
    return ^(UIView *refView) {
        [self oprateBackFormStack:@(0) oprateType:XHSSOprateBackStackTypeEqualToView refView:refView];
        return self;
    };
}

#pragma mark - ==============私有方法==============
- (BOOL)verifyCurrentOprateValueType:(XHSSSaveValueType)valueType {
    return [[XHSSLayoutManager shareManager] verifyValueType:valueType];
}

////////////////////////////////////////////////////////////////////
// 根据适配操作调用栈，按照出栈顺序对 view(self) 进行适配操作
#define kXHSSFinalValue     (NSNumber *)[self finalValueWithValue:value valueType:XHSSValueTypeFloat oprateType:oprateType refView:refView]
#define kXHSSIsEqualOpration    [self isEqualOpration:oprateType]
- (void)oprateBackFormStack:(NSValue *)value oprateType:(XHSSOprateBackStackType)oprateType refView:(UIView *)refView {
    
    [[XHSSLayoutManager shareManager] popStackEmptyWithItemAction:^(NSArray *stackItem) {
        XHSSSaveValueType valueType;
        [[stackItem lastObject] getValue:&valueType];
        switch (valueType) {
            case XHSSSaveValueTypeTop:
                self.y =        kXHSSIsEqualOpration ? 0 : refView.y       + [kXHSSFinalValue floatValue]*(+1);
                break;
            case XHSSSaveValueTypeLeft:
                self.x =        kXHSSIsEqualOpration ? 0 : refView.x       + [kXHSSFinalValue floatValue]*(+1);
                break;
            case XHSSSaveValueTypeBottom:
                self.maxY =     kXHSSIsEqualOpration ? 0 : refView.maxY    + [kXHSSFinalValue floatValue]*(+1);   // wait to test
                break;
            case XHSSSaveValueTypeRight:
                self.maxX =     kXHSSIsEqualOpration ? 0 : refView.maxX    + [kXHSSFinalValue floatValue]*(+1);   // wait to test
                break;
            case XHSSSaveValueTypeWidth:
                self.width =    kXHSSIsEqualOpration ? 0 : refView.width   + [kXHSSFinalValue floatValue]*(+1);
                break;
            case XHSSSaveValueTypeHeight:
                self.height =   kXHSSIsEqualOpration ? 0 : refView.height  + [kXHSSFinalValue floatValue]*(+1);
                break;
                // x , y add the same float value
            case XHSSSaveValueTypeCenter:
                self.selCenter = CGPointMake(kXHSSIsEqualOpration ? 0 : refView.selCenter.x + [kXHSSFinalValue floatValue]*(+1),
                                             kXHSSIsEqualOpration ? 0 : refView.selCenter.y + [kXHSSFinalValue floatValue]*(+1));
                break;
                // x , y add the same float value
            case XHSSSaveValueTypeOrigin:
                self.selOrigin = CGPointMake(kXHSSIsEqualOpration ? 0 : refView.selOrigin.x + [kXHSSFinalValue floatValue]*(+1),
                                             kXHSSIsEqualOpration ? 0 : refView.selOrigin.y + [kXHSSFinalValue floatValue]*(+1));
                break;
                // x , y add the same float value
            case XHSSSaveValueTypeBounds:
                self.selBounds = CGSizeMake(kXHSSIsEqualOpration ? 0 : refView.bounds.size.width + [kXHSSFinalValue floatValue]*(+1),
                                            kXHSSIsEqualOpration ? 0 : refView.bounds.size.height + [kXHSSFinalValue floatValue]*(+1));
                break;
                
            default:
                NSLog(@"非法的数据类型");
                break;
        }
    }];
}

// 根据操作类型、数据类型 获取最终计算坐标使用的值 【目前只使用 float 类型，并直接返回不作处理， 以后可能支持 point、size、rect】
#define kXHSSDecodedValue (NSNumber *)[self decodeValue:value forValueType:valueType]
- (NSValue *)finalValueWithValue:(id)value valueType:(XHSSValueType)valueType oprateType:(XHSSOprateBackStackType)oprateType refView:(UIView *)refView {
    switch (oprateType) {
        case XHSSOprateBackStackTypeAddByNum:
            return @([kXHSSDecodedValue floatValue]*(+1));
            break;
        case XHSSOprateBackStackTypeSubByNum:
            return @([kXHSSDecodedValue floatValue]*(-1));
            break;
        case XHSSOprateBackStackTypeEqualToNum:
            return @([kXHSSDecodedValue floatValue]*(1));
            break;
        case XHSSOprateBackStackTypeAddByView:
            return @([kXHSSDecodedValue floatValue]*(+1));
            break;
        case XHSSOprateBackStackTypeSubByView:
            return @([kXHSSDecodedValue floatValue]*(-1));
            break;
        case XHSSOprateBackStackTypeEqualToView:
            return @([kXHSSDecodedValue floatValue]*(1));
            break;
        default:
            return @(0);
            break;
    }
}

// 判断是否在做布局尺寸直接复制操作
- (BOOL)isEqualOpration:(XHSSOprateBackStackType)oprationType {
    if (oprationType == XHSSOprateBackStackTypeEqualToNum || oprationType == XHSSOprateBackStackTypeEqualToView) {
        return YES;
    }
    return NO;
}

// 根据数据类型获取 实际类型的值 【以后可能会直接计算 point、size 类型的 value，现在直接返回不作处理】
- (NSValue *)decodeValue:(NSValue *)value forValueType:(XHSSValueType)valueType {
    switch (valueType) {
        case XHSSValueTypeFloat:
            return value; // [(NSNumber *)value floatValue];
            break;
        case XHSSValueTypePoint:
            return value;
            break;
        case XHSSValueTypeSize:
            return value;
            break;
        case XHSSValueTypeRect:
            return value;
            break;
        case XHSSValueTypeView:
            return value;
            break;
        default:
            return value;
            break;
    }
}
//////////////////////////////////////////////////////////////////

#pragma mark - ==============公共方法==============
/**
 设置完全适配情况下的基础屏幕尺寸, 如果不设置则当前适配为固定坐标适配
 
 @param screenWidth :   当前布局所在的屏幕宽度
 */
- (void)setAdaptionBaseScreenWidth:(CGFloat)screenWidth {
    [[XHSSLayoutManager shareManager] setAdaptionBaseScreenWidth:screenWidth];
}

@end
