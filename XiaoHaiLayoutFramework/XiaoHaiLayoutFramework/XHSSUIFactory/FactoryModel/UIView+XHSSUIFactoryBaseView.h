//
//  UIView+XHSSUIFactoryBaseView.h
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/12/21.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XHSSUIFactoryViewModel;

@interface UIView (XHSSUIFactoryBaseView)

@property (nonatomic, strong, readonly) XHSSUIFactoryViewModel *viewModel;

- (void)setupWithViewModel:(XHSSUIFactoryViewModel*)viewModel;
- (void)configWithDataModel:(id)dataModel;
- (void)needRelyoutWithViewModel:(XHSSUIFactoryViewModel*)viewModel;

@end
