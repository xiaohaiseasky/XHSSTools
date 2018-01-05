//
//  XHSSTabScrollView.h
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/12/29.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

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
@protocol XHSSTabScrollViewToolBarViewDelegate <NSObject>

@required
- (void)switchToIndex:(NSInteger)index withAnimationDuration:(NSTimeInterval)duration;
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
- (CGFloat)headerViewHeightForXHSSTabScrollView:(XHSSTabScrollView*)tabScrollView;
- (UIView*)viewForHeaderInXHSSTabScrollView:(XHSSTabScrollView*)tabScrollView;

- (CGFloat)toolBarHeightForXHSSTabScrollView:(XHSSTabScrollView*)tabScrollView;
- (UIView<XHSSTabScrollViewToolBarViewDelegate>*)viewForToolBarInXHSSTabScrollView:(XHSSTabScrollView*)tabScrollView;
- (UIEdgeInsets)toolBarEdgeInsetsForXHSSTabScrollView:(XHSSTabScrollView*)tabScrollView;

- (NSInteger)numberOfToolBarItemInXHSSTabScrollView:(XHSSTabScrollView*)tabScrollView;
- (UIView<XHSSTabScrollViewToolBarItemViewDelegate>*)XHSSTabScrollView:(XHSSTabScrollView*)tabScrollView viewForItemInToolBar:(UIView*)toolBar atIndex:(NSInteger)index;

@end


/**
 滚动切换视图的配置文件
 */
typedef NS_ENUM(NSUInteger, XHSSTabScrollViewAnimationType) {
    XHSSTabScrollViewAnimationTypeNone,
};

@interface XHSSTabScrollViewConfig : NSObject

@property (nonatomic, strong) UIViewController *contentVC;

@property (nonatomic, assign) CGFloat headerViewHeight;
@property (nonatomic, strong) UIColor *headerViewBgColor;

@property (nonatomic, assign) CGFloat toolBarHeight;
@property (nonatomic, strong) UIColor *toolBarBgColor;
@property (nonatomic, assign) CGFloat toolBarYOffset;
@property (nonatomic, assign) UIEdgeInsets toolBarEdgeInsets;
@property (nonatomic, assign) NSInteger toolBarItemCount;
@property (nonatomic, assign) CGFloat toolBarIndicatorLineHeihgt;
@property (nonatomic, assign) CGFloat toolBarIndicatorWidth;
@property (nonatomic, strong) UIColor *toolBarIndicatorLineColor;
@property (nonatomic, strong) UIColor *toolBarIndicatorColor;

@property (nonatomic, assign) NSInteger subVCCount;
@property (nonatomic, strong) UIColor *bottomContentViewBgColor;

@property (nonatomic, assign) NSTimeInterval animationDuration;

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

@end

/**
 滚动切换视图ToolBarItem
 */
@interface XHSSTabScrollViewToolBarItemView : UIView <XHSSTabScrollViewToolBarItemViewDelegate>

- (void)setTitle:(NSString*)title;

@end
