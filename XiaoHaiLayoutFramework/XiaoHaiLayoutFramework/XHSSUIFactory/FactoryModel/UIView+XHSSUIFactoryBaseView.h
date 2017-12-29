//
//  UIView+XHSSUIFactoryBaseView.h
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/12/21.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//
//
//
/**
 1. 数据绑定
 2. action 绑定
 3. manager 复用
 4. component key 处理
 5. 容错处理
 6. macro 定义
 */

#import <UIKit/UIKit.h>
#import "XHSSUIFactoryViewModel.h"


/**
 使用 viewModel 配置 view
 */
@interface UIView (XHSSUIFactoryBaseView)

@property (nonatomic, strong, readonly) XHSSUIFactoryViewModel * _Nonnull viewModel;

- (void)setupWithViewModel:(XHSSUIFactoryViewModel*_Nonnull)viewModel;
- (void)configWithDataModel:(id _Nonnull )dataModel;
- (void)needRelyoutWithViewModel:(XHSSUIFactoryViewModel*_Nonnull)viewModel;

@end




/**
 添加到父视图、配置、布局 链式调用
 */
@interface UIView (XHSSUIFactoryBaseViewUIManagerTool)

- (UIView*_Nonnull(^_Nonnull)(UIView * _Nonnull superView))addToSuperView;
- (UIView*_Nonnull(^_Nonnull)(XHSSLayoutBridgeBlock _Nonnull layout))addLayout;
- (UIView*_Nonnull(^_Nonnull)(XHSSConfigBridgeBlock _Nonnull config))addConfig;

- (UIView*_Nonnull(^_Nonnull)())needAddToSuperView;
- (UIView*_Nonnull(^_Nonnull)())needRefreshLayout;
- (UIView*_Nonnull(^_Nonnull)())needRefreshConfig;

@end

