//
//  XHSSScrollPopWindow.h
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2018/1/9.
//  Copyright © 2018年 XiaoHai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XHSSScrollPopWindow;


/**
 XHSSScrollPopWindow 的数据源、代理
 */
@protocol XHSSScrollPopWindowDelegate <NSObject>

@required
- (NSInteger)pageNumberInScrollPopWindow:(XHSSScrollPopWindow*)scrollPopWindow;
- (UIView*)pageViewInScrollPopWindow:(XHSSScrollPopWindow*)scrollPopWindow atIndex:(NSInteger)index;
- (CGSize)pageViewSizeInScrollPopWindow:(XHSSScrollPopWindow*)scrollPopWindow atIndex:(NSInteger)index;

@end



/**
 可滑动弹窗
 */
@interface XHSSScrollPopWindow : UIView

@property (nonatomic, assign) BOOL reuseEnable;
@property (nonatomic, assign) NSInteger maxAvilableScrollIndex;
@property (nonatomic, weak) id<XHSSScrollPopWindowDelegate> delegate;

- (void)show;
- (void)hidden;

- (UIView*)reusePageViewOfClass:(Class)pageClass withIdentifier:(NSString*)identifier;

@end
