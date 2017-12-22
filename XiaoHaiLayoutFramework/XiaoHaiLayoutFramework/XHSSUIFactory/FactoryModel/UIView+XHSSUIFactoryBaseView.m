//
//  UIView+XHSSUIFactoryBaseView.m
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/12/21.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import "UIView+XHSSUIFactoryBaseView.h"
#import "XHSSUIFactoryViewModel.h"
#import <objc/runtime.h>


@implementation UIView (XHSSUIFactoryBaseView)

#pragma mark - setter & getter
- (XHSSUIFactoryViewModel*)viewModel {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setViewModel:(XHSSUIFactoryViewModel *)viewModel {
    objc_setAssociatedObject(self, @selector(viewModel), viewModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//#pragma mark - init
//- (instancetype)initWithViewModel:(XHSSUIFactoryViewModel *)viewModel {
//    self =
//}

#pragma mark -
- (void)setupWithViewModel:(XHSSUIFactoryViewModel*)viewModel {
    //NSString *componentType = viewModel.componentType;
    //NSString *componentName = viewModel.componentName;
    XHSSConfigBridgeBlock componentConfig = viewModel.componentConfig;
    //NSString *componentLayoutRefView = viewModel.componentLayoutRefView;
    XHSSLayoutBridgeBlock componentLayout = viewModel.componentLayout;
    //NSString *componentAction = viewModel.componentAction;
    //XHSSUIFactoryViewModel *subComponent = viewModel.subComponent;
    //NSString *componentDataKeyPath = viewModel.componentDataKeyPath;
    //id dataModel = viewModel.dataModel;
    
    if (componentConfig) {
        XHSSConfigManagerBridge *configManager = [[XHSSConfigManagerBridge alloc] init];
        //configManager.targetView =
        componentConfig(configManager);
    }
    
    if (componentLayout) {
        XHSSLayoutManagerBridge *layoutManager = [[XHSSLayoutManagerBridge alloc] init];
        //layoutManager.targetView =
        componentLayout(layoutManager);
    }
}

- (void)configWithDataModel:(id)dataModel {
    
}

- (void)needRelyoutWithViewModel:(XHSSUIFactoryViewModel*)viewModel {
    
}

@end
