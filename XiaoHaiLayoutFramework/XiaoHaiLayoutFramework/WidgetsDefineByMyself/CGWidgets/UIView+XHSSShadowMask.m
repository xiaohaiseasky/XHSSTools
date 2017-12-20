//
//  UIView+XHSSShadowMask.m
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/12/20.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import "UIView+XHSSShadowMask.h"
#import <objc/runtime.h>

@implementation UIView (XHSSShadowMask)

- (XHSSShadowView*)shadowView {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setShadowView:(XHSSShadowView *)shadowView {
    objc_setAssociatedObject(self, @selector(shadowView), shadowView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
