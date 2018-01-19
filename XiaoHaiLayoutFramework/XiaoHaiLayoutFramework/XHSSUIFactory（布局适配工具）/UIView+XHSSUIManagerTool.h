//
//  UIView+XHSSUIManagerTool.h
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/12/4.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+XHSSLayoutTool.h"


@interface UIView (XHSSUIManagerTool)

#pragma mark - ==============UI链===============
- (UIView*(^)(UIView *superView))xhss_addToSuperView;
- (UIView*(^)(XHSSLayoutBlock layout))xhss_addLayout;
- (UIView*(^)(XHSSConfigBlock config))xhss_addConfig;
//- (UIView*(^)(XHSSConfigBlock config))xhss_addConfigRelated;

@end
