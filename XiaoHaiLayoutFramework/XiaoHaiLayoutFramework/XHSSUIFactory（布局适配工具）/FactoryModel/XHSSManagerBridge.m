//
//  XHSSManagerBridge.m
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/12/22.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import "XHSSManagerBridge.h"
#import <objc/runtime.h>


#pragma mark - =========== XHSSManagerBridge ===========
// =============================================
//      XHSSManagerBridge
// =============================================
@implementation XHSSManagerBridge

#warning *** should check the componentClazz is kind of UIView class
+ (UIView*_Nonnull)createComponentWithClass:(Class _Nonnull)componentClazz {
    return [[componentClazz alloc] init];
}

@end



#pragma mark - =========== XHSSConfigManagerBridge ===========
// =============================================
//      XHSSConfigManagerBridge
// =============================================
@implementation XHSSConfigManagerBridge

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.targetView;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([self.targetView respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:self.targetView];
    } else {
        NSLog(@"******* 配置了该控件没有的属性 *******");
        [super forwardInvocation:anInvocation];
    }
}




/// *** mybe here should not use singletone , use singletone just for get component by name ***
+ (instancetype)sharedConfigManagerBridge {
    static XHSSConfigManagerBridge *configManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        configManager = [[XHSSConfigManagerBridge alloc] init];
    });
    return configManager;
}

@end





#pragma mark - =========== XHSSLayoutManagerBridge ===========
// =============================================
//      XHSSLayoutManagerBridge
// =============================================
@implementation XHSSLayoutManagerBridge

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.targetView;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([self.targetView respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:self.targetView];
    } else {
        NSLog(@"******* 使用了该控件没有布局方法 *******");
        [super forwardInvocation:anInvocation];
    }
}


/// *** mybe here should not use singletone , use singletone just for get component by name ***
+ (instancetype)sharedLayoutManagerBridge {
    static XHSSLayoutManagerBridge *layoutManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        layoutManager = [[XHSSLayoutManagerBridge alloc] init];
    });
    return layoutManager;
}

@end
