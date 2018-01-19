//
//  HNAHiAccumulatePointPageControlView.m
//  YUYTrip
//
//  Created by Apple on 2017/10/19.
//  Copyright © 2017年 HNA. All rights reserved.
//

#import "HNAHiAccumulatePointPageControlView.h"

@interface HNAHiAccumulatePointPageControlView ()

@end

static const NSInteger kHNAIndicatorBaseTag = 1000;

@implementation HNAHiAccumulatePointPageControlView

#pragma mark - SETTER
- (void)setNumberOfPages:(NSInteger)numberOfPages {
    _numberOfPages = numberOfPages;
    [self hiddenSelf];
    [self addIndicators];
}

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    [self selectIndicatorAtIndex:_currentPage];
}

- (void)setHidesForSinglePage:(BOOL)hidesForSinglePage {
    _hidesForSinglePage = hidesForSinglePage;
    [self hiddenSelf];
}

#warning 每次设置方法调用重绘效率不高
//
- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    _pageIndicatorTintColor = pageIndicatorTintColor;
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}

- (void)setIndicatorSize:(CGSize)indicatorSize {
    _indicatorSize = indicatorSize;
}

- (void)setIndicatorSpace:(CGFloat)indicatorSpace {
    _indicatorSpace = indicatorSpace;
}

- (void)setSelectedIndicatorSize:(CGSize)selectedIndicatorSize {
    _selectedIndicatorSize = selectedIndicatorSize;
}

- (void)setIndicatorView:(UIView *)indicatorView {
    _indicatorView = indicatorView;
}

#warning self.frame
- (void)setFrame:(CGRect)frame {
    self.frame = frame;
}



#pragma mark - init
- (instancetype)init {
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

#pragma mark - UI
- (void)setUp {
    self.numberOfPages = 0;
    self.currentPage = 0;
    self.hidesForSinglePage = NO;
    self.pageIndicatorTintColor = [UIColor orangeColor];
    self.currentPageIndicatorTintColor = [UIColor whiteColor];
    
    self.indicatorSize = CGSizeMake(16, 2);
    self.indicatorSpace = 4;
    
    self.canResizeSelectedIndicator = NO;
    self.selectedIndicatorSize = self.indicatorSize;
    
    [self setUpView];
}

- (void)setUpView {
    self.backgroundColor = [UIColor clearColor];
    
    [self addIndicators];
}

- (void)addIndicators {
    
    [self clearIndicators];
    
    CGFloat indicatorWidth = self.indicatorSize.width;
    CGFloat indicatorHeight= self.indicatorSize.height;
    CGFloat indicatorSpace = self.indicatorSpace;
    
    UIView *indicator;
    for (NSInteger i = 0; i < self.numberOfPages; i++) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(pageControl:viewForIndicatorAtIndex:)]) {
            [self.delegate pageControl:self viewForIndicatorAtIndex:i];
        } else if (self.indicatorView) {
            indicator = (UIView *)[self.indicatorView copy];
        } else {
            indicator = [[UIView alloc] init];
        }
        indicator.frame = CGRectMake(i*(indicatorSpace+indicatorWidth),
                                     0,
                                     indicatorWidth,
                                     indicatorHeight);
        indicator.tag = kHNAIndicatorBaseTag+i;
        indicator.backgroundColor = self.pageIndicatorTintColor;
        [self addSubview:indicator];
    }
    
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            CGRectGetMaxX(indicator.frame),
                            self.frame.size.height);
    
}

- (void)clearIndicators {
    for (NSInteger i = 0; i < self.numberOfPages; i++) {
        UIView *subView = [self viewWithTag:kHNAIndicatorBaseTag+i];
        [subView removeFromSuperview];
    }
}

- (void)selectIndicatorAtIndex:(NSInteger)index {
    [self recoverIndicatorsDefaultState];
    UIView *selectedIndicator = [self viewWithTag:kHNAIndicatorBaseTag+index];
    selectedIndicator.backgroundColor = self.currentPageIndicatorTintColor;
    [self indicator:selectedIndicator resizeFrameOfState:YES];
}

- (void)recoverIndicatorsDefaultState {
    for (NSInteger i = 0; i < self.numberOfPages; i++) {
        UIView *subView = [self viewWithTag:kHNAIndicatorBaseTag+i];
        [subView setBackgroundColor:self.pageIndicatorTintColor];
        [self indicator:subView resizeFrameOfState:NO];
    }
}

- (void)indicator:(UIView *)indicator resizeFrameOfState:(BOOL)selected {
    CGFloat indicatorX = indicator.frame.origin.x;
    CGFloat indicatorY = indicator.frame.origin.y;
    if (selected) {
        indicator.frame = CGRectMake(indicatorX, indicatorY, self.selectedIndicatorSize.width, self.selectedIndicatorSize.height);
    } else {
        indicator.frame = CGRectMake(indicatorX, indicatorY, self.indicatorSize.width, self.indicatorSize.height);
    }
}

- (void)hiddenSelf {
    if (self.hidesForSinglePage && self.numberOfPages <= 1) {
        self.hidden = YES;
    }
}


// no use
- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount {
    return self.bounds.size;
}

@end
