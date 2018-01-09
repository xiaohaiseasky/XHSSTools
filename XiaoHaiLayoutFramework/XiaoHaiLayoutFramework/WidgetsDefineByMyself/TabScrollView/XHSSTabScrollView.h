//
//  XHSSTabScrollView.h
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/12/29.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//
//
// *** not deal with problem : item to subVC maping plan ***
//
// *** not deal with problem : colick item to notificate subVC ***

#import <UIKit/UIKit.h>


@class XHSSTabScrollView;

typedef NS_ENUM(NSUInteger, XHSSTabScrollViewToolBarItemViewState) {
    XHSSTabScrollViewToolBarItemViewStateNormal,
    XHSSTabScrollViewToolBarItemViewStateHiglight,
};


/**
  自定义 滚动切换视图ToolBarItem 需遵循此协议
 */
@protocol XHSSTabScrollViewToolBarItemViewDelegate <NSObject>

@required
- (void)updateStatusForState:(XHSSTabScrollViewToolBarItemViewState)state;

@end

/**
  自定义 滚动切换视图ToolBar 需遵循此协议
 */
typedef void (^XHSSTabScrollViewToolBarItemColickCallBack)(NSInteger index);
@protocol XHSSTabScrollViewToolBarViewDelegate <NSObject>

@required
- (void)shouldSwitchToIndex:(NSInteger)index withAnimationDuration:(NSTimeInterval)duration;
@property(nonatomic, copy) XHSSTabScrollViewToolBarItemColickCallBack callBack;

/// do not have effect current
- (NSInteger)itemCount;
- (UIView<XHSSTabScrollViewToolBarItemViewDelegate>*)itemAtIndex:(NSInteger)index;

@end



/**
 滚动切换视图的代理
 */
@protocol XHSSTabScrollViewDelegate <NSObject>

@optional
- (void)XHSSTabScrollView:(XHSSTabScrollView*)tabScrollView didSwitchToSubVC:(UIViewController*)subVC atIndex:(NSInteger)index;
- (void)XHSSTabScrollView:(XHSSTabScrollView*)tabScrollView toolBar:(UIView*)toolBar didSwitchToItem:(UIView*)item atIndex:(NSInteger)index;

@end


/**
 滚动切换视图的数据源
 */
@protocol XHSSTabScrollViewDataSource <NSObject>

@required
- (NSInteger)numberOfSubVCInXHSSTabScrollView:(XHSSTabScrollView*)tabScrollView;
- (UIViewController*)XHSSTabScrollView:(XHSSTabScrollView*)tabScrollView subVCAtIndex:(NSInteger)index;

@optional
/// *** 如果提供 headerView 需要实现以下两个代理方法 ***
- (CGFloat)headerViewHeightForXHSSTabScrollView:(XHSSTabScrollView*)tabScrollView;
- (UIView*)viewForHeaderInXHSSTabScrollView:(XHSSTabScrollView*)tabScrollView;

/// *** 如果需要调整 toolBar 的高度 需要实现以下代理方法 ***
- (CGFloat)toolBarHeightForXHSSTabScrollView:(XHSSTabScrollView*)tabScrollView;
/// *** 如果提供自定义 toolBar 需要实现以下代理方法，且只需要实现此代理方法，及以上调整高度的代理方法 ***
- (UIView<XHSSTabScrollViewToolBarViewDelegate>*)viewForToolBarInXHSSTabScrollView:(XHSSTabScrollView*)tabScrollView;
/// *** 如果没有提供自定义 toolBar 且需要调整 toolBar 的内边距 ，实现以下代理方法 ***
- (UIEdgeInsets)toolBarEdgeInsetsForXHSSTabScrollView:(XHSSTabScrollView*)tabScrollView;
/// *** 如果没有提供自定义 toolBar 且未在配置类中指定 toolBarItemCount 、subVCCount 和 subVCArr ，需要实现以下代理方法指定 toolBarItem 的数量 ***
- (NSInteger)numberOfToolBarItemInXHSSTabScrollView:(XHSSTabScrollView*)tabScrollView;
/// *** 如果没有提供自定义 toolBar 且提供自定义的 toolBarItem ，实现以下代理方法 ***
- (UIView<XHSSTabScrollViewToolBarItemViewDelegate>*)XHSSTabScrollView:(XHSSTabScrollView*)tabScrollView viewForItemInToolBar:(UIView*)toolBar atIndex:(NSInteger)index;

@end


/**
 滚动切换视图的配置文件
 */
typedef NS_ENUM(NSUInteger, XHSSTabScrollViewAnimationType) {
    XHSSTabScrollViewAnimationTypeNone,
};

@interface XHSSTabScrollViewConfig : NSObject

@property (nonatomic, strong) UIViewController *contentVC;              /// 承载 subVC 的 superVC

/// *** 如果提供 headerView 需要实现以下两个代理方法 ***
@property (nonatomic, assign) CGFloat headerViewHeight;                 /// headerView 高度
@property (nonatomic, strong) UIColor *headerViewBgColor;               /// headerView 背景颜色


@property (nonatomic, assign) CGFloat toolBarHeight;                    /// toolBar 高度
@property (nonatomic, strong) UIColor *toolBarBgColor;                  /// toolBar 背景颜色
@property (nonatomic, assign) CGFloat toolBarYOffset;                   /// toolBar Y轴偏移量，可以实现 toolBar 与 headerView 的重叠效果
/// *** 如果没有提供自定义 toolBar ***
@property (nonatomic, assign) UIEdgeInsets toolBarEdgeInsets;           /// toolBar 的内容的 内边距
@property (nonatomic, assign) NSInteger toolBarItemCount;               /// toolBar 中 item 的数量
@property (nonatomic, assign) CGFloat toolBarIndicatorLineHeihgt;       /// toolBar 中下边指示线的高度
@property (nonatomic, assign) CGFloat toolBarIndicatorWidth;            /// toolBar 中下边指示器的宽度
@property (nonatomic, strong) UIColor *toolBarIndicatorLineColor;       /// toolBar 中下边指示线的颜色
@property (nonatomic, strong) UIColor *toolBarIndicatorColor;           /// toolBar 中下边指示器的颜色
/// *** 如果没有提供自定义 toolBarItem ***
@property (nonatomic, strong) NSArray<NSString*> *toolBarItemTitleArr;  /// toolBar 中 item 的标题
@property (nonatomic, strong) UIFont *toolBarItemFont;                  /// toolBar 中 item 的字体
@property (nonatomic, strong) UIColor *toolBarItemNormalTextColor;      /// toolBar 中 item 的标题正常状态颜色
@property (nonatomic, strong) UIColor *toolBarItemHiglightTextColor;    /// toolBar 中 item 的标题高亮状态的颜色


@property (nonatomic, strong) NSArray *toolBarItemToSubVCMapArr;        /// toolBar 中 item 与 subVC 映射的数组


@property (nonatomic, strong) NSArray<UIViewController*> *subVCArr;     /// 装载 bottomContentView 中 subVC 的数组
@property (nonatomic, assign) NSInteger subVCCount;                     /// bottomContentView 中 subVC 的数量
@property (nonatomic, strong) UIColor *bottomContentViewBgColor;        /// bottomContentView 的背景颜色

@property (nonatomic, assign) NSTimeInterval animationDuration;         /// 切换时候的动画时间

@property (nonatomic, assign) XHSSTabScrollViewAnimationType tabScrollViewAnimationType;

@end


/**
 滚动切换视图
 */
@interface XHSSTabScrollView : UIView

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, weak) id<XHSSTabScrollViewDelegate> delegate;
@property (nonatomic, weak) id<XHSSTabScrollViewDataSource> dataSource;
@property (nonatomic, strong) XHSSTabScrollViewConfig *config;

@property (nonatomic, strong) NSMutableArray<UIView<XHSSTabScrollViewToolBarItemViewDelegate>*> *toolBarItemArr;
@property (nonatomic, strong) NSMutableArray<UIViewController*> *subVCArr;

- (instancetype)initWithConfig:(XHSSTabScrollViewConfig*)config;

@end



/**
 滚动切换视图ToolBar
 */
@interface XHSSTabScrollViewToolBarView : UIView <XHSSTabScrollViewToolBarViewDelegate>

@property (nonatomic, strong) NSArray<NSString*> *titlesArr;
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;

/// confirm protocol
@property(nonatomic, copy) XHSSTabScrollViewToolBarItemColickCallBack callBack;

@end

/**
 滚动切换视图ToolBarItem
 */
@interface XHSSTabScrollViewToolBarItemView : UIView <XHSSTabScrollViewToolBarItemViewDelegate>

- (void)setTitle:(NSString*)title;
- (void)setTitle:(NSString*)title font:(UIFont*)font textColor:(UIColor*)textColor;

@end
