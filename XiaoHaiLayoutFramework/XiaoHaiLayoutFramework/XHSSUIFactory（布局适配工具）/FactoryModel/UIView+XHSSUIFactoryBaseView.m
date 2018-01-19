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

#pragma mark - public
- (void)setupWithViewModel:(XHSSUIFactoryViewModel*)viewModel {
    self.viewModel = viewModel;
    
//    [viewModel.subComponentNameArr enumerateObjectsUsingBlock:^(NSString * _Nonnull subComponentName, NSUInteger idx, BOOL * _Nonnull stop) {
//        objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(subComponentName), viewModel.subComponentsInfoDic[subComponentName], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    }];
    
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

/**
 为视图绑定父视图
 */
- (UIView*_Nonnull(^_Nonnull)(UIView * _Nonnull superView))addToSuperView {
    return ^ (UIView * _Nonnull superView) {
//        [superView addSubview:self];
        objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(XHSSBindSuperViewKey), superView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return self;
    };
}



/**
 为视图绑定布局动作
 */
- (UIView*_Nonnull(^_Nonnull)(XHSSLayoutBridgeBlock _Nonnull layout))addLayout {
    return ^ (XHSSLayoutBridgeBlock _Nonnull layout) {
        if (layout) {
#if 1
            objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(XHSSBindLayoutBridgeBlockKey), [layout copy], OBJC_ASSOCIATION_COPY_NONATOMIC);
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

/**
 为视图绑定配置动作
 */
- (UIView*_Nonnull(^_Nonnull)(XHSSConfigBridgeBlock _Nonnull config))addConfig {
    return ^ (XHSSConfigBridgeBlock _Nonnull config) {
        if (config) {
#if 1
            objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(XHSSBindConfigBridgeBlockKey), [config copy], OBJC_ASSOCIATION_COPY_NONATOMIC);
#else       /// *** here do not excute the layout block , instad save it to the view which is need layout and excute it when right time ***
            XHSSConfigManagerBridge *configManager = [[XHSSConfigManagerBridge alloc] init];
            configManager.targetView = self;
            config(configManager);
#endif
        }
        return self;
    };
}




/**
 视图需要添加到父视图
 */
- (UIView*_Nonnull(^_Nonnull)())needAddToSuperView {
    return ^ () {
        UIView *superView = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(XHSSBindSuperViewKey));
        if (superView) {
            [superView addSubview:self];
        } else {
            superView = [(XHSSUIFactoryViewModel*)objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(XHSSBindViewModelKey)) rootView];
            if (superView) {
                [superView addSubview:self];
            }
        }
        return self;
    };
}

/**
 视图需要进行布局
 */
- (UIView*_Nonnull(^_Nonnull)())needRefreshLayout {
    return ^ () {
        XHSSLayoutBridgeBlock layoutBlock = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(XHSSBindLayoutBridgeBlockKey));
        if (layoutBlock) {
            XHSSLayoutManagerBridge *layoutManager = [[XHSSLayoutManagerBridge alloc] init];
            layoutManager.targetView = self;
            layoutBlock(layoutManager);
        }
        return self;
    };
}

/**
 视图需要进行配置
 */
- (UIView*_Nonnull(^_Nonnull)())needRefreshConfig {
    return ^ () {
        XHSSConfigBridgeBlock configBlock = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(XHSSBindConfigBridgeBlockKey));
        if (configBlock) {
            XHSSConfigManagerBridge *configManager = [[XHSSConfigManagerBridge alloc] init];
            configManager.targetView = self;
            configBlock(configManager);
        }
        return self;
    };
}

@end
