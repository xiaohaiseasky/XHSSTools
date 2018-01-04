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
@interface XHSSTabScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *toolBar;
@property (nonatomic, strong) UIScrollView *bottomContentView;
@property (nonatomic, assign) NSInteger subVCCount;

@end

@implementation XHSSTabScrollView

#pragma mark - ===========setter & getter===========
- (void)setDataSource:(id<XHSSTabScrollViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self updateBottomContentView];
}

- (NSMutableArray<UIViewController*> *)subVCArr {
    if (_subVCArr == nil) {
        _subVCArr = [NSMutableArray array];
    }
    return _subVCArr;
}

#pragma mark - init
- (instancetype)initWithConfig:(XHSSTabScrollViewConfig*)config {
    self = [self init];
    if (self) {
        self.config = config;
        [self setupUI];
    }
    return self;
}

#pragma mark - ===========UI===========
- (void)setupUI {
    
    if (self.config == nil) {
        self.config = [[XHSSTabScrollViewConfig alloc] init];
    }
    
    if (self.config.contentVC == nil) {
        return;
    }
    
    /// ***  ***
//    [self.config.contentVC.view addSubview:self];
    
    /// *** header ***
    if (self.headerView == nil) {
        self.headerView = [[UIView alloc] init];
        self.headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), self.config.headerViewHeight);
        [self addSubview:self.headerView];
    }
    
    /// *** toolBar ***
    self.toolBar = [[UIScrollView alloc] init];
    self.toolBar.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), CGRectGetWidth(self.frame), self.config.toolBarHeight);
    self.toolBar.scrollEnabled = NO;
    [self addSubview:self.toolBar];
    
    /// *** bottomContentView ***
    self.bottomContentView = [[UIScrollView alloc] init];
    self.bottomContentView.frame = CGRectMake(0, CGRectGetMaxY(self.toolBar.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - CGRectGetMaxY(self.toolBar.frame));
    self.bottomContentView.contentOffset = CGPointZero;
    self.bottomContentView.pagingEnabled = YES;
    [self addSubview:self.bottomContentView];
    
    
    _headerView.backgroundColor = [UIColor redColor];
    _toolBar.backgroundColor = [UIColor greenColor];
    _bottomContentView.backgroundColor = [UIColor blueColor];
    
}


- (void)updateBottomContentView {
    _subVCCount = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfSubVCInXHSSTabScrollView:)]) {
        _subVCCount = [self.dataSource numberOfSubVCInXHSSTabScrollView:self];
    } else if (self.subVCArr.count > 0) {
        _subVCCount = self.subVCArr.count;
    }
    self.bottomContentView.contentSize = CGSizeMake(CGRectGetWidth(self.bottomContentView.frame) * _subVCCount, CGRectGetHeight(self.bottomContentView.frame));
    [self addSubVC];
}

- (void)addSubVC {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(XHSSTabScrollView:subVCAtIndex:)]) {
        for (NSInteger index = 0; index < _subVCCount; index++) {
            UIViewController *subVC = [self.dataSource XHSSTabScrollView:self subVCAtIndex:index];
            [self.subVCArr addObject:subVC];
            [self addSubVC:subVC atIndex:index toSuperVC:self.config.contentVC];
        }
    } else if (self.subVCArr.count > 0) {
        __weak typeof(self) weakSelf = self;
        [self.subVCArr enumerateObjectsUsingBlock:^(UIViewController * _Nonnull subVC, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addSubVC:subVC atIndex:idx toSuperVC:weakSelf.config.contentVC];
        }];
    }
}

#pragma mark - ===========manager===========
/// *** add subVC ***
- (void)addSubVC:(UIViewController*)subVC atIndex:(NSInteger)index toSuperVC:(UIViewController*)superVC {
    [superVC addChildViewController:subVC];
    [self addViewOfSubVC:subVC toSuperView:self.bottomContentView];
    [self fixPositionOfSubVC:subVC atIndex:index bySuperView:self.bottomContentView];
    [subVC didMoveToParentViewController:superVC];
}

- (void)addViewOfSubVC:(UIViewController*)subVC toSuperView:(UIView*)superView {
    [superView addSubview:subVC.view];
}

- (void)fixPositionOfSubVC:(UIViewController*)subVC atIndex:(NSInteger)index bySuperView:(UIView*)superView {
    subVC.view.frame = CGRectMake(CGRectGetWidth(superView.frame) *index,
                                  0,
                                  CGRectGetWidth(superView.frame),
                                  CGRectGetHeight(superView.frame));
}


/// *** remove subVC ***
- (void)removeSubVC:(UIViewController*)subVC fromSuperVC:(UIViewController*)superVC {
    [subVC willMoveToParentViewController:nil];
    [subVC.view removeFromSuperview];
    [subVC removeFromParentViewController];
}

#pragma mark - ===========animation===========
- (void)animation {
    
}

#pragma mark - ===========layout===========
- (void)layoutSubviews {
    self.headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), self.config.headerViewHeight);
    self.toolBar.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), CGRectGetWidth(self.frame), self.config.toolBarHeight);
    self.bottomContentView.frame = CGRectMake(0, CGRectGetMaxY(self.toolBar.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - CGRectGetMaxY(self.toolBar.frame));
    
    /// update bottomContentView and sub view frame
    self.bottomContentView.contentSize = CGSizeMake(CGRectGetWidth(self.bottomContentView.frame) * _subVCCount, CGRectGetHeight(self.bottomContentView.frame));
    for (NSInteger index = 0; index < _subVCCount; index++) {
        [self fixPositionOfSubVC:self.subVCArr[index] atIndex:index bySuperView:self.bottomContentView];
    }
}

#pragma mark - ===========UIScrollViewDelegate===========
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentIndex = scrollView.contentOffset.x/CGRectGetWidth(scrollView.frame);
    
    if (scrollView == self.bottomContentView) {
        [self bottomContentViewScrollToSubVC:self.subVCArr[currentIndex] atIndex:currentIndex];
    }
    
}

#pragma mark - ===========Action Logic===========
- (void)switchToolBarToIndex:(NSInteger)index {
    
}
- (void)toolBarSwitchToIndex:(NSInteger)index {
    
}

- (void)scrollBottomContentViewToIndex:(NSInteger)index {
    self.bottomContentView.contentOffset = CGPointMake(CGRectGetWidth(self.bottomContentView.frame)*index, 0);
}
- (void)bottomContentViewScrollToSubVC:(UIViewController*)sunVC atIndex:(NSInteger)index {
    
}

@end
