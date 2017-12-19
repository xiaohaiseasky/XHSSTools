//
//  XHSSToolsView.h
//  TestCollectionViewLayout
//
//  Created by Apple on 2017/11/16.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XHSSCutImageStyle) {
    XHSSCutImageStyleNone,
    XHSSCutImageStyleRect,
    XHSSCutImageStyleAny,
};

@interface XHSSToolsView : UIView 

@property (nonatomic, copy) void(^callback)(UIImage *cutImage);

+ (instancetype)shareCutView;

+ (void)showCutView;
+ (void)showCutViewWithComplementation:(void(^)(UIImage *cutImage))callback;
+ (void)hiddenCutView;
- (void)showCutViewWithComplementation:(void(^)(UIImage *cutImage))callback;
- (void)showCutView;
- (void)hiddenCutView;

+ (void)showCalculateViewWithWidht:(CGFloat)width heigth:(CGFloat)height;
+ (void)showCalculateView;
+ (void)hiddenCalculateView;
- (void)showCalculateViewWithWidht:(CGFloat)width heigth:(CGFloat)height;
- (void)showCalculateView;
- (void)hiddenCalculateView;
#pragma mark - init cutView or calculator
- (instancetype)initCutImageWithFrame:(CGRect)frame;
- (instancetype)initCalculatorWithFrame:(CGRect)frame;

@end










