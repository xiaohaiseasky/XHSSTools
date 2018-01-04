//
//  XHSSTabScrollView.h
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/12/29.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import <UIKit/UIKit.h>


@class XHSSTabScrollView;

/**
 滚动切换视图的代理
 */
@protocol XHSSTabScrollViewDelegate <NSObject>

@optional
- (void)XHSSTabScrollView:(XHSSTabScrollView*)tabScrollView didSwitchToSubVC:(UIViewController*)subVC atIndex:(NSInteger)index;

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
- (UIEdgeInsets)toolBarEdgeInsetsForXHSSTabScrollView:(XHSSTabScrollView*)tabScrollView;
- (UIView*)XHSSTabScrollView:(XHSSTabScrollView*)tabScrollView viewForItemInToolBar:(UIView*)toolBar;

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

@property (nonatomic, assign) CGFloat toolBarHeight;
@property (nonatomic, assign) UIEdgeInsets toolBarEdgeInsets;
//@property (nonatomic, assign) NSInteger toolBarItemCount;
//@property (nonatomic, strong) UIView *toolBar;

//@property (nonatomic, assign) NSInteger subVCCount;

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

@property (nonatomic, strong) NSMutableArray<UIViewController*> *subVCArr;

- (instancetype)initWithConfig:(XHSSTabScrollViewConfig*)config;

@end
