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
    self.toolBarItemCount = 0;
    self.toolBarYOffset = 0;
    self.toolBarIndicatorLineHeihgt = 1;
    self.toolBarIndicatorWidth = 70;
    self.toolBarIndicatorLineColor = [UIColor blueColor];
    self.toolBarIndicatorColor = [UIColor redColor];
    
    self.toolBarItemTitleArr = [NSArray array];
    self.toolBarItemFont = [UIFont systemFontOfSize:17];
    self.toolBarItemNormalTextColor = [UIColor darkGrayColor];
    self.toolBarItemHiglightTextColor = [UIColor redColor];
    
    self.toolBarItemToSubVCMapArr = [NSArray array];
    
    self.subVCArr = [NSArray array];
    self.subVCCount = 0;
    
    self.animationDuration = 0.4;
    
    self.tabScrollViewAnimationType = XHSSTabScrollViewAnimationTypeNone;
}

@end


/**
 滚动切换视图
 */
@interface XHSSTabScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIView<XHSSTabScrollViewToolBarViewDelegate> *toolBar;
@property (nonatomic, assign) NSInteger toolBarItemCount;
@property (nonatomic, assign) UIEdgeInsets toolBarEdgeinsets;
@property (nonatomic, strong) UIView *toolBarIndicatorLine;
@property (nonatomic, strong) UIView *toolBarIndicator;

@property (nonatomic, strong) UIScrollView *bottomContentView;
@property (nonatomic, assign) NSInteger subVCCount;

@end

@implementation XHSSTabScrollView

#pragma mark - ===========setter & getter===========
- (void)setDataSource:(id<XHSSTabScrollViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self upodateByDataSource];
}

- (NSMutableArray<UIView<XHSSTabScrollViewToolBarItemViewDelegate>*> *)toolBarItemArr {
    if (_toolBarItemArr == nil) {
        _toolBarItemArr = [NSMutableArray array];
    }
    return _toolBarItemArr;
}

- (NSMutableArray<UIViewController*> *)subVCArr {
    if (_subVCArr == nil) {
        _subVCArr = [NSMutableArray array];
    }
    return _subVCArr;
}

- (void)setHeaderView:(UIView *)headerView {
    _headerView = headerView;
    
    _headerView.backgroundColor = self.config.headerViewBgColor ? self.config.headerViewBgColor : _headerView.backgroundColor;
}
- (void)setToolBar:(UIView<XHSSTabScrollViewToolBarViewDelegate> *)toolBar {
    _toolBar = toolBar;
    
    _toolBar.backgroundColor = self.config.toolBarBgColor ? self.config.toolBarBgColor : _toolBar.backgroundColor;
}
- (void)setBottomContentView:(UIScrollView *)bottomContentView {
    _bottomContentView = bottomContentView;
    
    _bottomContentView.backgroundColor = self.config.bottomContentViewBgColor ? self.config.bottomContentViewBgColor : _bottomContentView.backgroundColor;
}

#pragma mark - init
- (instancetype)initWithConfig:(XHSSTabScrollViewConfig*)config {
    self = [self init];
    if (self) {
        self.config = config;
        [self setup];
    }
    return self;
}

- (void)setup {
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInSelf:)]];
    
    [self setupUI];
}

#pragma mark - ===========Action===========
- (void)tapInSelf:(UITapGestureRecognizer*)tap {
    CGPoint point = [tap locationInView:self];

    if (![self.toolBar respondsToSelector:@selector(shouldSwitchToIndex:withAnimationDuration:)] &&
        CGRectContainsPoint(self.toolBar.frame, point)) {
        __weak typeof(self) weakSelf = self;
        /// ???????
        [self.toolBarItemArr enumerateObjectsUsingBlock:^(UIView<XHSSTabScrollViewToolBarItemViewDelegate> * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            if (CGRectContainsPoint(item.frame, CGPointMake(point.x -CGRectGetMinX(self.toolBar.frame), point.y -CGRectGetMinY(self.toolBar.frame)))) {
                [weakSelf switchToolBarToIndex:idx shouldUpdateBottomContentView:YES];
                *stop = YES;
            }
        }];
    }
}


#pragma mark - ===========UI===========
- (void)setupUI {
    
    if (self.config == nil) {
        self.config = [[XHSSTabScrollViewConfig alloc] init];
    }
    self.subVCArr = [NSMutableArray arrayWithArray: self.config.subVCArr];
    
    if (self.config.contentVC == nil) {
        return;
    }
    
    
    /// *** header ***
    if (self.headerView == nil) {
        self.headerView = [[UIView alloc] init];
        self.headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), self.config.headerViewHeight);
        [self addSubview:self.headerView];
    }
    
    /// *** toolBar ***
    self.toolBar = [[UIView alloc] init];
    self.toolBar.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame) -self.config.toolBarYOffset, CGRectGetWidth(self.frame), self.config.toolBarHeight);
    [self addSubview:self.toolBar];
    
    /// indicator line
    [self addIndicatorLineToToolBar];
    
    /// *** bottomContentView ***
    self.bottomContentView = [[UIScrollView alloc] init];
    self.bottomContentView.frame = CGRectMake(0,
                                              CGRectGetMaxY(self.toolBar.frame),
                                              CGRectGetWidth(self.frame),
                                              CGRectGetHeight(self.frame) - CGRectGetMaxY(self.toolBar.frame));
    self.bottomContentView.delegate = self;
    self.bottomContentView.contentOffset = CGPointZero;
    self.bottomContentView.pagingEnabled = YES;
    [self addSubview:self.bottomContentView];
    
    
    _headerView.backgroundColor = self.config.headerViewBgColor ? self.config.headerViewBgColor : [UIColor clearColor];
    _toolBar.backgroundColor = self.config.toolBarBgColor ? self.config.toolBarBgColor : [UIColor clearColor];
    _bottomContentView.backgroundColor = self.config.bottomContentViewBgColor ? self.config.bottomContentViewBgColor : [UIColor clearColor];
    
}

- (void)addIndicatorLineToToolBar {
    if (self.toolBarIndicatorLine) {
        [self.toolBarIndicatorLine removeFromSuperview];
    }
    if (self.toolBarIndicator) {
        [self.toolBarIndicator removeFromSuperview];
    }
    
    if (self.config.toolBarIndicatorLineHeihgt > 0) {
        self.toolBarIndicatorLine = [[UIView alloc] init];
        self.toolBarIndicatorLine.frame = CGRectMake(0,
                                                     CGRectGetHeight(self.toolBar.frame) -self.config.toolBarIndicatorLineHeihgt,
                                                     CGRectGetWidth(self.toolBar.frame),
                                                     self.config.toolBarIndicatorLineHeihgt);
        self.toolBarIndicatorLine.backgroundColor = self.config.toolBarIndicatorLineColor;
        [self.toolBar addSubview:self.toolBarIndicatorLine];
        
        
        CGFloat indicatorX = 0;
        if (self.toolBarItemArr.count > 0) {
            UIView<XHSSTabScrollViewToolBarItemViewDelegate> *firstItem = self.toolBarItemArr[0];
            indicatorX = CGRectGetMidX(firstItem.frame) -self.config.toolBarIndicatorWidth/2.0;
        }
        self.toolBarIndicator = [[UIView alloc] init];
        self.toolBarIndicator.frame = CGRectMake(indicatorX,
                                                 CGRectGetMinY(self.toolBarIndicatorLine.frame),
                                                 self.config.toolBarIndicatorWidth,
                                                 CGRectGetHeight(self.toolBarIndicatorLine.frame));
        self.toolBarIndicator.backgroundColor = self.config.toolBarIndicatorColor;
        [self.toolBar addSubview:self.toolBarIndicator];
    }
}

#pragma mark - =========== Update ByDataSource===========
- (void)upodateByDataSource {
    CGFloat headerHeight = self.config.headerViewHeight;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(headerViewHeightForXHSSTabScrollView:)]) {
        headerHeight = [self.dataSource headerViewHeightForXHSSTabScrollView:self];
    }
    
    CGFloat toolBarHeight = self.config.toolBarHeight;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(toolBarHeightForXHSSTabScrollView:)]) {
        toolBarHeight = [self.dataSource toolBarHeightForXHSSTabScrollView:self];
    }
    
    _toolBarEdgeinsets = self.config.toolBarEdgeInsets;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(toolBarEdgeInsetsForXHSSTabScrollView:)]) {
        _toolBarEdgeinsets = [self.dataSource toolBarEdgeInsetsForXHSSTabScrollView:self];
    }
    
    [self updateAllFrameWithHeaderHeight:headerHeight toolBarHeight:toolBarHeight];
    
    [self updateHeaderView];
    [self updateToolBar];
    [self updateBottomContentView];
}

#pragma mark - =========== Update headerView===========
- (void)updateHeaderView {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(viewForHeaderInXHSSTabScrollView:)]) {
        CGRect headerViewFrame = self.headerView.frame;
        [self.headerView removeFromSuperview];
        self.headerView = [self.dataSource viewForHeaderInXHSSTabScrollView:self];
        self.headerView.frame = headerViewFrame;
        [self addSubview:self.headerView];
    }
    [self sendSubviewToBack:self.headerView];
}

#pragma mark - =========== Update ToolBar===========
- (void)updateToolBar {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(viewForToolBarInXHSSTabScrollView:)]) {
        CGRect toolBarFrame = self.toolBar.frame;
        [self.toolBar removeFromSuperview];
        self.toolBar = [self.dataSource viewForToolBarInXHSSTabScrollView:self];
        self.toolBar.frame = toolBarFrame;
        __weak typeof(self) weakSelf = self;
        self.toolBar.callBack = ^(NSInteger index) {
            [weakSelf scrollBottomContentViewToIndex:index shouldUpdateToolBar:NO];
        };
        [self addSubview:self.toolBar];
        
        /// &&&&&&&
        [self.toolBarItemArr removeAllObjects];
        for (NSInteger index = 0; index < [self.toolBar itemCount]; index++) {
            /// ???????
            [self.toolBarItemArr addObject:[self.toolBar itemAtIndex:index]];
        }
    } else {
        _toolBarItemCount = self.config.toolBarItemCount;
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfToolBarItemInXHSSTabScrollView:)]) {
            _toolBarItemCount = [self.dataSource numberOfToolBarItemInXHSSTabScrollView:self];
        } else if (self.toolBarItemArr.count > 0) {
            _toolBarItemCount = self.toolBarItemArr.count;
        } else if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfSubVCInXHSSTabScrollView:)]) {
            _toolBarItemCount = [self.dataSource numberOfSubVCInXHSSTabScrollView:self];
        }else if (self.subVCArr.count > 0) {
            _toolBarItemCount = self.subVCArr.count;
        } else {
            _toolBarItemCount = _subVCCount;
        }
        
        [self addItemToToolBar];
        [self addIndicatorLineToToolBar];
    }
}

- (void)addItemToToolBar {
    [self.toolBarItemArr enumerateObjectsUsingBlock:^(UIView<XHSSTabScrollViewToolBarItemViewDelegate> * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        [item removeFromSuperview];
    }];
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(XHSSTabScrollView:viewForItemInToolBar:atIndex:)]) {
        [self.toolBarItemArr removeAllObjects];
        for (NSInteger index = 0; index < self.toolBarItemCount; index++) {
            UIView<XHSSTabScrollViewToolBarItemViewDelegate> *toolBarItem = [self.dataSource XHSSTabScrollView:self viewForItemInToolBar:self.toolBar atIndex:index];
            [self.toolBar addSubview:toolBarItem];
            [self.toolBarItemArr addObject:toolBarItem];
            [self fixPositionOfItem:toolBarItem AtIndex:index];
            
            if (index == 0 && [toolBarItem respondsToSelector:@selector(updateStatusForState:)]) {
                [toolBarItem updateStatusForState:XHSSTabScrollViewToolBarItemViewStateHiglight];
            }
        }
    } else if (self.toolBarItemArr.count > 0) {
        __weak typeof(self) weakSelf = self;
        [self.toolBarItemArr enumerateObjectsUsingBlock:^(UIView<XHSSTabScrollViewToolBarItemViewDelegate> * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            [weakSelf.toolBar addSubview:item];
            [weakSelf fixPositionOfItem:item AtIndex:idx];
            
            if (idx == 0 && [item respondsToSelector:@selector(updateStatusForState:)]) {
                [item updateStatusForState:XHSSTabScrollViewToolBarItemViewStateHiglight];
            }
        }];
    } else {
        [self.toolBarItemArr removeAllObjects];
        for (NSInteger index = 0; index < self.toolBarItemCount; index++) {
            XHSSTabScrollViewToolBarItemView *toolBarItem = [[XHSSTabScrollViewToolBarItemView alloc] init];
            toolBarItem.backgroundColor = [UIColor brownColor];
            [self.toolBar addSubview:toolBarItem];
            [self.toolBarItemArr addObject:toolBarItem];
            [self fixPositionOfItem:toolBarItem AtIndex:index];
            
            [toolBarItem setTitle:[NSString stringWithFormat:@"title%ld", index]];
            if (index == 0 && [toolBarItem respondsToSelector:@selector(updateStatusForState:)]) {
                [toolBarItem updateStatusForState:XHSSTabScrollViewToolBarItemViewStateHiglight];
            }
        }
    }
}

- (void)fixPositionOfItem:(UIView*)item AtIndex:(NSInteger)index {
    CGFloat itemX = self.toolBarEdgeinsets.left;
    CGFloat itemY = self.toolBarEdgeinsets.top;
    CGFloat itemW = (CGRectGetWidth(self.toolBar.frame) -self.toolBarEdgeinsets.left -self.toolBarEdgeinsets.right)/self.toolBarItemCount;
    CGFloat itemH = CGRectGetHeight(self.toolBar.frame) -self.toolBarEdgeinsets.top -self.toolBarEdgeinsets.bottom -self.config.toolBarIndicatorLineHeihgt;
    
    item.frame = CGRectMake(itemX +itemW*index, itemY, itemW, itemH);
}

#pragma mark - =========== Update BottomContentView===========
- (void)updateBottomContentView {
    _subVCCount = self.config.subVCCount;
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
        [self.subVCArr removeAllObjects];
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

#pragma mark - ===========animation replace===========
- (void)replaceOldViewController:(UIViewController*)oldVC
               withNewController:(UIViewController*)newVC {

    [oldVC willMoveToParentViewController:nil];
    [self.config.contentVC addChildViewController:newVC];
    
    /// *** form left or right ??????? ***
    newVC.view.frame = CGRectMake(CGRectGetWidth(self.bottomContentView.frame),
                                  0,
                                  CGRectGetWidth(self.bottomContentView.frame),
                                  CGRectGetHeight(self.bottomContentView.frame));
    CGRect endFrame = CGRectMake(0,
                                 0,
                                 CGRectGetWidth(self.bottomContentView.frame),
                                 CGRectGetHeight(self.bottomContentView.frame));
    
    [self.config.contentVC transitionFromViewController:oldVC
                                       toViewController:newVC
                                               duration: 0.25 options:0
                                             animations:^{
                                                newVC.view.frame = oldVC.view.frame;
                                                oldVC.view.frame = endFrame;
                                             }
                                             completion:^(BOOL finished) {
                                                 [oldVC removeFromParentViewController];
                                                 [newVC didMoveToParentViewController:self.config.contentVC];
                                             }];
}

#pragma mark - ===========layout===========
- (void)layoutSubviews {
    [self updateAllFrameWithHeaderHeight:self.config.headerViewHeight toolBarHeight:self.config.toolBarHeight];
    
    [self updateHeaderView];
    [self updateToolBar];
    [self updateBottomContentView];
}

- (void)updateAllFrameWithHeaderHeight:(CGFloat)headerHeight toolBarHeight:(CGFloat)toolBarHeight {
    self.headerView.frame = CGRectMake(0,
                                       0,
                                       CGRectGetWidth(self.frame),
                                       headerHeight);
    self.toolBar.frame = CGRectMake(0,
                                    CGRectGetMaxY(self.headerView.frame) -self.config.toolBarYOffset,
                                    CGRectGetWidth(self.frame),
                                    toolBarHeight);
    self.bottomContentView.frame = CGRectMake(0,
                                              CGRectGetMaxY(self.toolBar.frame),
                                              CGRectGetWidth(self.frame),
                                              CGRectGetHeight(self.frame) - CGRectGetMaxY(self.toolBar.frame));
    
    self.bottomContentView.contentSize = CGSizeMake(CGRectGetWidth(self.bottomContentView.frame) * _subVCCount,
                                                    CGRectGetHeight(self.bottomContentView.frame));
}

#pragma mark - ===========UIScrollViewDelegate===========
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentIndex = scrollView.contentOffset.x/CGRectGetWidth(scrollView.frame);
    
    if (scrollView == self.bottomContentView) {
        /// notificate delegate
        [self bottomContentViewScrollToSubVC:self.subVCArr[currentIndex] atIndex:currentIndex];
        
        /// here need a map of subVC to toolBarItem and reverse
        [self switchToolBarToIndex:currentIndex shouldUpdateBottomContentView:NO];
    }
    
}

#pragma mark - ===========Action Logic===========
- (void)switchToolBarToIndex:(NSInteger)index shouldUpdateBottomContentView:(BOOL)should {
    
    /// ???????
    UIView<XHSSTabScrollViewToolBarItemViewDelegate> *currentItem = self.toolBarItemArr[index];
    
    /// update indicator position
    if (self.toolBarIndicator) {
        [UIView animateWithDuration:self.config.animationDuration animations:^{
            self.toolBarIndicator.frame = CGRectMake(CGRectGetMidX(currentItem.frame)
                                                     -CGRectGetWidth(self.toolBarIndicator.frame)/2.0,
                                                     CGRectGetMinY(self.toolBarIndicator.frame),
                                                     self.config.toolBarIndicatorWidth > 0
                                                     ? self.config.toolBarIndicatorWidth
                                                     : CGRectGetWidth(currentItem.frame),
                                                     CGRectGetHeight(self.toolBarIndicator.frame));
        } completion:^(BOOL finished) {
            /// notificate delegate
            [self toolBarSwitchToIndex:index];
        }];
    }
    
    /// update custom design view status
    if (self.toolBar && [self.toolBar respondsToSelector:@selector(shouldSwitchToIndex:withAnimationDuration:)]) {
        [self.toolBar shouldSwitchToIndex:index withAnimationDuration:self.config.animationDuration];
    } else {
        [self.toolBarItemArr enumerateObjectsUsingBlock:^(UIView<XHSSTabScrollViewToolBarItemViewDelegate> * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([item respondsToSelector:@selector(updateStatusForState:)]) {
                [item updateStatusForState:XHSSTabScrollViewToolBarItemViewStateNormal];
            }
        }];
        if (currentItem && [currentItem respondsToSelector:@selector(updateStatusForState:)]) {
            [currentItem updateStatusForState:XHSSTabScrollViewToolBarItemViewStateHiglight];
        }
    }
    
    /// update subVC switch sync
    /// here need a map of subVC to toolBarItem and reverse
    if (should) {
        [self scrollBottomContentViewToIndex:index shouldUpdateToolBar:NO];
    }
}
- (void)toolBarSwitchToIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(XHSSTabScrollView:toolBar:didSwitchToItem:atIndex:)]) {
        /// ???????
        [self.delegate XHSSTabScrollView:self toolBar:self.toolBar didSwitchToItem:self.toolBarItemArr[index] atIndex:index];
    }
}

- (void)scrollBottomContentViewToIndex:(NSInteger)index shouldUpdateToolBar:(BOOL)should {
    [UIView animateWithDuration:self.config.animationDuration animations:^{
        self.bottomContentView.contentOffset = CGPointMake(CGRectGetWidth(self.bottomContentView.frame)*index, 0);
    } completion:^(BOOL finished) {
        /// notificate delegate
        [self bottomContentViewScrollToSubVC:self.subVCArr[index] atIndex:index];
    }];
    
    
    /// here need a map of subVC to toolBarItem and reverse
    if (should) {
        [self switchToolBarToIndex:index shouldUpdateBottomContentView:NO];
    }
}
- (void)bottomContentViewScrollToSubVC:(UIViewController*)sunVC atIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(XHSSTabScrollView:didSwitchToSubVC:atIndex:)]) {
        [self.delegate XHSSTabScrollView:self didSwitchToSubVC:self.subVCArr[index] atIndex:index];
    }
}

@end



#pragma mark - ToolBar
/**
 滚动切换视图ToolBar
 */
@interface XHSSTabScrollViewToolBarView ()

@property (nonatomic, strong) NSMutableArray<UIView<XHSSTabScrollViewToolBarItemViewDelegate>*> *itemViewArr;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation XHSSTabScrollViewToolBarView

- (NSMutableArray<UIView<XHSSTabScrollViewToolBarItemViewDelegate>*> *)itemViewArr {
    if (_itemViewArr == nil) {
        _itemViewArr = [NSMutableArray array];
    }
    return _itemViewArr;
}

- (void) setTitlesArr:(NSArray<NSString*> *)titlesArr {
    _titlesArr = titlesArr;
    
    [self setupUI];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    if (_titlesArr == nil) {
        return;
    }
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInSelf:)]];
    
    if (self.contentView) {
        [self.contentView removeFromSuperview];
    }
    self.contentView = [[UIView alloc] init];
    self.contentView.frame = self.bounds;
    self.contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contentView];
    
    CGFloat x = _contentEdgeInsets.left;
    CGFloat y = _contentEdgeInsets.top;
    CGFloat width = (CGRectGetWidth(self.frame) -_contentEdgeInsets.left -_contentEdgeInsets.right)/_titlesArr.count;
    CGFloat height = CGRectGetHeight(self.frame) -_contentEdgeInsets.top -_contentEdgeInsets.bottom;
    
    [self.itemViewArr removeAllObjects];
    __weak typeof(self) weakSelf = self;
    [_titlesArr enumerateObjectsUsingBlock:^(NSString * _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
        XHSSTabScrollViewToolBarItemView *itemView = [[XHSSTabScrollViewToolBarItemView alloc] init];
        itemView.frame = CGRectMake(x +width*idx, y, width, height);
        [itemView setTitle:title];
        [weakSelf.contentView addSubview:itemView];
        [weakSelf.itemViewArr addObject:itemView];
        
        itemView.backgroundColor = [UIColor blueColor];
    }];
}

- (void)layoutSubviews {
    [self setupUI];
}

/// Action
- (void)tapInSelf:(UITapGestureRecognizer*)tap {
    CGPoint point = [tap locationInView:self];
    
    __weak typeof(self) weakSelf = self;
    [self.itemViewArr enumerateObjectsUsingBlock:^(UIView<XHSSTabScrollViewToolBarItemViewDelegate> * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint(item.frame, point) && weakSelf.callBack) {
            weakSelf.callBack(idx);
        }
    }];
}

/// confirm protocol
- (void)shouldSwitchToIndex:(NSInteger)index withAnimationDuration:(NSTimeInterval)duration {
    UIView <XHSSTabScrollViewToolBarItemViewDelegate> *item = self.itemViewArr[index];
    
    [self.itemViewArr enumerateObjectsUsingBlock:^(UIView<XHSSTabScrollViewToolBarItemViewDelegate> * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([item respondsToSelector:@selector(updateStatusForState:)]) {
            [item updateStatusForState:XHSSTabScrollViewToolBarItemViewStateNormal];
        }
    }];
    if ([item respondsToSelector:@selector(updateStatusForState:)]) {
        [item updateStatusForState:XHSSTabScrollViewToolBarItemViewStateHiglight];
    }
}


- (NSInteger)itemCount {
    return self.itemViewArr.count;
}

- (UIView<XHSSTabScrollViewToolBarItemViewDelegate> *)itemAtIndex:(NSInteger)index {
    return self.itemViewArr[index/self.itemViewArr.count];
}

@end


#pragma mark - ToolBarItem
/**
 滚动切换视图ToolBarItem
 */
@interface XHSSTabScrollViewToolBarItemView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation XHSSTabScrollViewToolBarItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:17];
    _titleLabel.textColor = [UIColor darkGrayColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
}

- (void)layoutSubviews {
    _titleLabel.frame = CGRectMake(10, 0, CGRectGetWidth(self.frame) -20, CGRectGetHeight(self.frame));
}

- (void)setTitle:(NSString*)title {
    _titleLabel.text = title;
}


- (void)setTitle:(NSString*)title font:(UIFont*)font textColor:(UIColor*)textColor {

    _titleLabel.font = font;
    _titleLabel.textColor = textColor;
}


/// confirm protocol
- (void)updateStatusForState:(XHSSTabScrollViewToolBarItemViewState)state {
    switch (state) {
        case XHSSTabScrollViewToolBarItemViewStateNormal:
            _titleLabel.textColor = [UIColor darkGrayColor];
            break;
        case XHSSTabScrollViewToolBarItemViewStateHiglight:
            _titleLabel.textColor = [UIColor redColor];
            break;
            
        default:
            break;
    }
}

@end
