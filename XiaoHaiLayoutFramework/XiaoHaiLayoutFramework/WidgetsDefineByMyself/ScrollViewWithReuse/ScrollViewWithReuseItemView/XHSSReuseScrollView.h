//
//  XHSSReuseScrollView.h
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2018/1/16.
//  Copyright © 2018年 XiaoHai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XHSSReuseScrollView;


/**
 
 */
@protocol XHSSReuseScrollViewDataSource <NSObject>

@required
- (NSInteger)numberOfItemInScrollView:(XHSSReuseScrollView*)scrollView;
- (UIView*)itemViewInScrollView:(XHSSReuseScrollView*)scrollView atIndex:(NSInteger)index;
- (CGSize)itemViewSizeInScrollView:(XHSSReuseScrollView*)scrollView atIndex:(NSInteger)index;
- (CGSize)itemViewEdgeInsetsInScrollView:(XHSSReuseScrollView*)scrollView atIndex:(NSInteger)index;

@end




/**
 
 */
typedef NS_ENUM(NSUInteger, XHSSReuseScrollViewScrollDirection) {
    XHSSReuseScrollViewScrollDirectionHorizontal,
    XHSSReuseScrollViewScrollDirectionVertical,
};

@interface XHSSReuseScrollView : UIScrollView

@property (nonatomic, assign) XHSSReuseScrollViewScrollDirection scrollDirection;
@property (nonatomic, weak) id<XHSSReuseScrollViewDataSource> dataSource;

@end
