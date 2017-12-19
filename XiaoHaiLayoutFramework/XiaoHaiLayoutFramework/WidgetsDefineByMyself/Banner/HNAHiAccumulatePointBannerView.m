//
//  HNAHiAccumulatePointBannerView.m
//  YUYTrip
//
//  Created by Apple on 2017/10/14.
//  Copyright © 2017年 HNA. All rights reserved.
//

#import "HNAHiAccumulatePointBannerView.h"
#import "HNAHiAccumulatePointPageControlView.h"

@interface HNAHiAccumulatePointBannerView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HNAHiAccumulatePointPageControlView *pageControl; //UIPageControl *pageControl;
@property (nonatomic, strong) UIImageView *leftImgView;
@property (nonatomic, strong) UIImageView *centerImgView;
@property (nonatomic, strong) UIImageView *RightImgView;

@property (nonatomic, assign) NSInteger currentImgIndex;

@property (nonatomic, strong) NSTimer *timer;

@end

static const NSTimeInterval bannerScrollTime = 3;

@implementation HNAHiAccumulatePointBannerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setImagesArr:(NSMutableArray *)imagesArr {
    _imagesArr = imagesArr;
    _pageControl.numberOfPages = _imagesArr.count;
    [self setImagesForImgViewsWithImgIndex:_currentImgIndex totalImgCount:_imagesArr.count];
//    self.currentImgIndex++;
}

- (void)setUp {
    self.currentImgIndex = 0;
    [self setUpTimer];
    [self setUpViews];
}

- (void)setUpTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:bannerScrollTime target:self selector:@selector(autoScrollOfBanner) userInfo:nil repeats:YES];
}

- (void)setUpViews {
    self.backgroundColor = [UIColor whiteColor];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = self.bounds;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.layer.cornerRadius = 7;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width*3, _scrollView.frame.size.height);
    _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width, 0);
    [self addSubview:_scrollView];
    
    [self addImgViewToScrollView];
    
    CGFloat pageControlW = self.frame.size.width/2.0;
    CGFloat pageControlH = 12;
    CGFloat pageControlX = self.frame.size.width/4.0;
    CGFloat pageControlMarginBottom = 6;
    CGFloat pageControlY = self.frame.size.height - pageControlMarginBottom - pageControlH;
    _pageControl = [[HNAHiAccumulatePointPageControlView alloc] initWithFrame:CGRectMake(pageControlX,
                                                                                         pageControlY,
                                                                                         pageControlW,
                                                                                         pageControlH)];
    //_pageControl.frame = CGRectMake(pageControlX, pageControlY, pageControlW, pageControlH);
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.numberOfPages = self.imagesArr.count;
    [self addSubview:_pageControl];
    
}

// 添加 imageView 到 scrollView
- (void)addImgViewToScrollView {
    _leftImgView = [self imageViewWithAction:@selector(tapLeftImageView)];
    _leftImgView.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);;
    [_scrollView addSubview:_leftImgView];
    
    _centerImgView = [self imageViewWithAction:@selector(tapCenterImageView)];
    _centerImgView.frame = CGRectMake(_scrollView.frame.size.width, 0, _leftImgView.frame.size.width, _leftImgView.frame.size.height);
    [_scrollView addSubview:_centerImgView];
    
    _RightImgView = [self imageViewWithAction:@selector(tapRightImageView)];
    _RightImgView.frame = CGRectMake(_scrollView.frame.size.width*2, 0, _leftImgView.frame.size.width, _leftImgView.frame.size.height);
    [_scrollView addSubview:_RightImgView];
    
//    [self test];
}

// 创建一个 imageView
- (UIImageView *)imageViewWithAction:(SEL)action {
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.userInteractionEnabled = YES;
    imgView.layer.cornerRadius = 4;
    imgView.clipsToBounds = YES;
    [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:action]];
    return imgView;
}

// 滑动一次后 scrollview 恢复到中间位置以备下一次滑动
- (void)backToCenterImgViewAfterOnceScroll:(UIScrollView *)scrollView {
    
    NSInteger imgCount = self.imagesArr.count;
    if (imgCount == 0) {
        return;
    }
    
    CGFloat scrollViewW = scrollView.bounds.size.width;
    //CGFloat scrollViewH = scrollView.bounds.size.height;
    CGFloat currXOffset = scrollView.contentOffset.x;
    
    // 向左滑动后
    if (currXOffset >= scrollViewW*2) {
        // 恢复 scroll view 的 contentOffset 显示中间的 image view
        scrollView.contentOffset = CGPointMake(scrollViewW, 0);

        // 滑动后切换 image view 的内容使各个 image view 显示正确的图片
        self.currentImgIndex = ++self.currentImgIndex%imgCount;
        [self setImagesForImgViewsWithImgIndex:_currentImgIndex totalImgCount:imgCount];
    } else if (currXOffset <= 0) {
        // 恢复 scroll view 的 contentOffset 显示中间的 image view
        scrollView.contentOffset = CGPointMake(scrollViewW, 0);

        // 滑动后切换 image view 的内容使各个 image view 显示正确的图片
        self.currentImgIndex = (--self.currentImgIndex+imgCount)%imgCount;
        [self setImagesForImgViewsWithImgIndex:_currentImgIndex totalImgCount:imgCount];
    }
    
    // 更新 pageControl
    _pageControl.currentPage = self.currentImgIndex;
}

// 设置 imageView 的图片
- (void)setImagesForImgViewsWithImgIndex:(NSInteger)imgIndex totalImgCount:(NSInteger)total {
    _leftImgView.image = self.imagesArr[(imgIndex-1+total)%total];
    _centerImgView.image = self.imagesArr[imgIndex];
    _RightImgView.image = self.imagesArr[(imgIndex+1)%total];
}

#pragma mark - tap actions
- (void)tapLeftImageView {
    NSLog(@"current index -1 = %ld", _currentImgIndex-1);
}

- (void)tapCenterImageView {
    NSLog(@"current index = %ld", _currentImgIndex);
    if (self.callBack) {
        self.callBack(_currentImgIndex);
    }
}

- (void)tapRightImageView {
    NSLog(@"current index + 1 = %ld", _currentImgIndex+1);
}

#pragma mark - timer
- (void)pauseTimer {
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)resumeTimer {
    [_timer setFireDate:[NSDate distantPast]];
}

- (void)autoScrollOfBanner {
    
//    CGPoint currentOffset = _scrollView.contentOffset;
//    _scrollView.contentOffset = CGPointMake(currentOffset.x + _scrollView.width, currentOffset.y);
//    [self backToCenterImgViewAfterOnceScroll:_scrollView];
    
    [UIView animateWithDuration:bannerScrollTime-2.5 delay:0 options:0 animations:^{
        CGPoint currentOffset = _scrollView.contentOffset;
        _scrollView.contentOffset = CGPointMake(currentOffset.x + _scrollView.frame.size.width, currentOffset.y);
    } completion:^(BOOL finished) {
        [self backToCenterImgViewAfterOnceScroll:_scrollView];
    }];

}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self pauseTimer];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    //[self pauseTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //[self resumeTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x <= scrollView.bounds.size.width) {
        [self backToCenterImgViewAfterOnceScroll:scrollView];
        [self performSelector:@selector(resumeTimer) withObject:nil afterDelay:bannerScrollTime];
    } else {
        [self resumeTimer];
    }
}

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - test
- (void)test {
    //_scrollView.backgroundColor = [HNAColorManager red];
    //_leftImgView.backgroundColor = [UIColor cyanColor];
    //_centerImgView.backgroundColor = [UIColor orangeColor];
    //_RightImgView.backgroundColor = [UIColor blueColor];
}

@end
