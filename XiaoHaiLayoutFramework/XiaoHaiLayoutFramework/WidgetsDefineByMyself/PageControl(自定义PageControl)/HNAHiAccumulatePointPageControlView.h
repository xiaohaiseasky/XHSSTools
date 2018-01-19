//
//  HNAHiAccumulatePointPageControlView.h
//  YUYTrip
//
//  Created by Apple on 2017/10/19.
//  Copyright © 2017年 HNA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HNAHiAccumulatePointPageControlView;

@protocol HNAHiAccumulatePointPageControlViewDelegate <NSObject>

- (UIView*)pageControl:(HNAHiAccumulatePointPageControlView *)pageControl viewForIndicatorAtIndex:(NSInteger)index;

@end


@interface HNAHiAccumulatePointPageControlView : UIView

@property(nonatomic, assign) NSInteger numberOfPages;
@property(nonatomic, assign) NSInteger currentPage;

@property(nonatomic) BOOL hidesForSinglePage;

//- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount;

@property(nonatomic,strong) UIColor *pageIndicatorTintColor;
@property(nonatomic,strong) UIColor *currentPageIndicatorTintColor;

///////////////////////////////////////////////////////////////////////////
// 设置 indicator view 的大小
@property (nonatomic, assign) CGSize indicatorSize;

//
@property (nonatomic, assign) CGFloat indicatorSpace;

//
@property (nonatomic, assign) BOOL canResizeSelectedIndicator;
@property (nonatomic, assign) CGSize selectedIndicatorSize;

// 设置一个统一样式的 indicator view
@property (nonatomic, strong) UIView *indicatorView;

// delegate
@property (nonatomic, strong) id <HNAHiAccumulatePointPageControlViewDelegate> delegate;

@end


