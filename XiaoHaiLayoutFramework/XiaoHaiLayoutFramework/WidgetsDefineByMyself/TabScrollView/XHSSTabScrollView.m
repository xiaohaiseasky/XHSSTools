//
//  XHSSTabScrollView.m
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/12/29.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import "XHSSTabScrollView.h"

/**
 滚动切换视图的配置文件
 */
@implementation XHSSTabScrollViewConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupInitData];
    }
    return self;
}

- (void)setupInitData {
    self.headerViewHeight = 150.0f;
    
    self.toolBarHeight = 70;
    self.toolBarEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.tabScrollViewAnimationType = XHSSTabScrollViewAnimationTypeNone;
}

@end


/**
 滚动切换视图
 */
@interface XHSSTabScrollView ()

@property (nonatomic, strong) UIScrollView *toolBar;
@property (nonatomic, strong) UIScrollView *bottomContentView;
@property (nonatomic, assign) NSInteger subVCCount;

@end

@implementation XHSSTabScrollView

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self setupUI];
//    }
//    return self;
//}

- (instancetype)initWithConfig:(XHSSTabScrollViewConfig*)config {
    self = [self init];
    if (self) {
        self.config = config;
        [self setupUI];
    }
    return self;
}

#pragma mark - UI
- (void)setupUI {
    
    if (self.config == nil) {
        self.config = [[XHSSTabScrollViewConfig alloc] init];
    }
    
    if (self.config.contentVC == nil) {
        return;
    }
    
    if (self.headerView == nil) {
        self.headerView = [[UIView alloc] init];
        self.headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), self.config.headerViewHeight);
        [self addSubview:self.headerView];
    }
    
    self.toolBar = [[UIScrollView alloc] init];
    self.toolBar.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), CGRectGetWidth(self.frame), self.config.toolBarHeight);
    self.toolBar.scrollEnabled = NO;
    [self addSubview:self.toolBar];
    
    self.bottomContentView = [[UIScrollView alloc] init];
    self.bottomContentView.frame = CGRectMake(0, CGRectGetMaxY(self.toolBar.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - CGRectGetMaxY(self.toolBar.frame));
    self.bottomContentView.contentOffset = CGPointZero;
    self.bottomContentView.pagingEnabled = YES;
    _subVCCount = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfSubVCInXHSSTabScrollView:)]) {
        _subVCCount = [self.dataSource numberOfSubVCInXHSSTabScrollView:self];
    }
    self.bottomContentView.contentSize = CGSizeMake(CGRectGetWidth(self.bottomContentView.frame) * _subVCCount, CGRectGetHeight(self.bottomContentView.frame));
    [self addSubview:self.bottomContentView];
    
}

- (void)addSubVC {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(XHSSTabScrollView:subVCAtIndex:)]) {
        for (NSInteger index = 0; index < _subVCCount; index++) {
            UIViewController *subVC = [self.dataSource XHSSTabScrollView:self subVCAtIndex:index];
            [self addSubVC:subVC toSuperVC:self.config.contentVC];
            subVC.view.frame = CGRectMake(CGRectGetWidth(self.bottomContentView.frame) *index,
                                          0,
                                          CGRectGetWidth(self.bottomContentView.frame),
                                          CGRectGetHeight(self.bottomContentView.frame));
        }
    }
}

#pragma mark - tool
- (void)addSubVC:(UIViewController*)subVC toSuperVC:(UIViewController*)superVC {
    [superVC addChildViewController:subVC];
    [superVC.view addSubview:self.bottomContentView];
    [subVC didMoveToParentViewController:superVC];
    
    /*
     subVC.view.frame = superVC [self frameForContentController];
     [superVC.view addSubview:self.currentClientView];
     [content didMoveToParentViewController:self];
     */
}

- (void)removeSubVC:(UIViewController*)subVC fromSuperVC:(UIViewController*)superVC {
    [subVC willMoveToParentViewController:nil];
    [subVC.view removeFromSuperview];
    [subVC removeFromParentViewController];
    
    /*
     [content willMoveToParentViewController:nil];
     [content.view removeFromSuperview];
     [content removeFromParentViewController];
     */
}

#pragma mark - layout
- (void)layoutSubviews {
    self.toolBar.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), CGRectGetWidth(self.frame), self.config.toolBarHeight);
    self.bottomContentView.frame = CGRectMake(0, CGRectGetMaxY(self.toolBar.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - CGRectGetMaxY(self.toolBar.frame));
    self.bottomContentView.frame = CGRectMake(0, CGRectGetMaxY(self.toolBar.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - CGRectGetMaxY(self.toolBar.frame));
}

@end
