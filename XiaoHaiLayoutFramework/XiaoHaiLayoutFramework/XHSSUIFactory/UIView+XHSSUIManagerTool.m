//
//  UIView+XHSSUIManagerTool.m
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/12/4.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import "UIView+XHSSUIManagerTool.h"

@implementation UIView (XHSSUIManagerTool)

#pragma mark - ==============UI链===============
- (UIView*(^)(UIView *superView))xhss_addToSuperView {
    return ^(UIView *superView) {
        [superView addSubview:self];
        return self;
    };
}

- (UIView*(^)(XHSSLayoutBlock layout))xhss_addLayout {
    return ^(XHSSLayoutBlock layout) {
        if (layout) {
            layout(self);
        }
        return self;
    };
}

- (UIView*(^)(XHSSConfigBlock config))xhss_addConfig {
    return ^(XHSSConfigBlock config) {
        if (config) {
            XHSSConfigManager *configManager = [XHSSConfigManager shareConfigManager];
            configManager.targetView = self;
            config(configManager);
        }
        return self;
    };
}

- (UIView*(^)(XHSSConfigBlock config))xhss_addConfigRelated {
    return ^(XHSSConfigBlock config) {
        if (config) {
            XHSSConfigManager *configManager = [[XHSSConfigManager alloc] init];
            configManager.targetView = self;
            config(configManager);
        }
        return self;
    };
}

@end
