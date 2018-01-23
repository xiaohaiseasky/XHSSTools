//
//  XHSSCutImageView.h
//  TestCollectionViewLayout
//
//  Created by Apple on 2017/11/27.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XHSSCutImageViewStyle) {
    XHSSCutImageViewStyleNone,
    XHSSCutImageViewStyleRect,
    XHSSCutImageViewStyleAny,
};

@interface XHSSCutImageView : UIView

@property (nonatomic, assign) CGFloat controlPointWidth;
@property (nonatomic, copy) void(^callback)(UIImage *cutImage);
@property (nonatomic, copy) void(^cancelCallBack)();
@property (nonatomic, copy) void(^sureCallBack)();

@end
