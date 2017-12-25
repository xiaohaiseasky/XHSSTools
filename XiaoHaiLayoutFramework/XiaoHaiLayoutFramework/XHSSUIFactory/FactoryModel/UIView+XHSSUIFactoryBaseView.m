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
    
//    //NSString *componentType = viewModel.componentType;
//    //NSString *componentName = viewModel.componentName;
//    XHSSConfigBridgeBlock componentConfig = viewModel.componentConfig;
//    //NSString *componentLayoutRefView = viewModel.componentLayoutRefView;
//    XHSSLayoutBridgeBlock componentLayout = viewModel.componentLayout;
//    //NSString *componentAction = viewModel.componentAction;
//    //XHSSUIFactoryViewModel *subComponent = viewModel.subComponent;
//    //NSString *componentDataKeyPath = viewModel.componentDataKeyPath;
//    //id dataModel = viewModel.dataModel;
//
//    if (componentConfig) {
//        XHSSConfigManagerBridge *configManager = [[XHSSConfigManagerBridge alloc] init];
//        //configManager.targetView =
//        componentConfig(configManager);
//    }
//
//    if (componentLayout) {
//        XHSSLayoutManagerBridge *layoutManager = [[XHSSLayoutManagerBridge alloc] init];
//        //layoutManager.targetView =
//        componentLayout(layoutManager);
//    }
    
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
            XHSSLayoutManagerBridge *layoutManager = [[XHSSLayoutManagerBridge alloc] init];
            layoutManager.targetView = self;
            layout(layoutManager);
        }
        return self;
    };
}
- (UIView*_Nonnull(^_Nonnull)(XHSSConfigBridgeBlock _Nonnull config))addConfig {
    return ^ (XHSSConfigBridgeBlock _Nonnull config) {
        if (config) {
            XHSSConfigManagerBridge *configManager = [[XHSSConfigManagerBridge alloc] init];
            configManager.targetView = self;
            config(configManager);
        }
        return self;
    };
}

@end
