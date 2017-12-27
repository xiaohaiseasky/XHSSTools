//
//  UIView+XHSSUIFactoryBaseView.m
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/12/21.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import "UIView+XHSSUIFactoryBaseView.h"
#import <objc/runtime.h>


@implementation UIView (XHSSUIFactoryBaseView)

#pragma mark - setter & getter
- (XHSSUIFactoryViewModel*)viewModel {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setViewModel:(XHSSUIFactoryViewModel *)viewModel {
    objc_setAssociatedObject(self, @selector(viewModel), viewModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark -
- (void)setupWithViewModel:(XHSSUIFactoryViewModel*)viewModel {
    self.viewModel = viewModel;
    
    [viewModel.subComponentNameArr enumerateObjectsUsingBlock:^(NSString * _Nonnull subComponentName, NSUInteger idx, BOOL * _Nonnull stop) {
        objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(subComponentName), viewModel.subComponentsInfoDic[subComponentName], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }];
    
}

- (void)configWithDataModel:(id)dataModel {
    
}

- (void)needRelyoutWithViewModel:(XHSSUIFactoryViewModel*)viewModel {
    
}

@end


/**
 添加到父视图、配置、布局 链式调用
 */
@implementation UIView (XHSSUIFactoryBaseViewUIManagerTool)

- (UIView*_Nonnull(^_Nonnull)(UIView * _Nonnull superView))addToSuperView {
    return ^ (UIView * _Nonnull superView) {
        [superView addSubview:self];
        return self;
    };
}
- (UIView*_Nonnull(^_Nonnull)(XHSSLayoutBridgeBlock _Nonnull layout))addLayout {
    return ^ (XHSSLayoutBridgeBlock _Nonnull layout) {
        if (layout) {
#if 1
            objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(XHSSBindLayoutBridgeBlockKey), [layout copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
#else       /// *** here do not excute the layout block , instad save it to the view which is need layout and excute it when right time ***
            XHSSLayoutManagerBridge *layoutManager = /*[XHSSLayoutManagerBridge sharedLayoutManagerBridge];
                                                     */ [[XHSSLayoutManagerBridge alloc] init];
            layoutManager.targetView = self;
            layout(layoutManager);
#endif
        }
        return self;
    };
}
- (UIView*_Nonnull(^_Nonnull)(XHSSConfigBridgeBlock _Nonnull config))addConfig {
    return ^ (XHSSConfigBridgeBlock _Nonnull config) {
        if (config) {
            XHSSConfigManagerBridge *configManager = /*[XHSSConfigManagerBridge sharedConfigManagerBridge];
                                                     */ [[XHSSConfigManagerBridge alloc] init];
            configManager.targetView = self;
            config(configManager);
        }
        return self;
    };
}


- (UIView*_Nonnull(^_Nonnull)())needRefreshLayout {
    return ^ () {
        XHSSLayoutBridgeBlock layoutBlock = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(XHSSBindLayoutBridgeBlockKey));
        if (layoutBlock) {
            XHSSLayoutManagerBridge *layoutManager = /*[XHSSLayoutManagerBridge sharedLayoutManagerBridge];
                                                      */ [[XHSSLayoutManagerBridge alloc] init];
            layoutManager.targetView = self;
            layoutBlock(layoutManager);
        }
        return self;
    };
}

@end
