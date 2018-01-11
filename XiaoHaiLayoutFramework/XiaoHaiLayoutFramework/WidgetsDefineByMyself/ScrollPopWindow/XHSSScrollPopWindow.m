//
//  XHSSScrollPopWindow.m
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2018/1/9.
//  Copyright © 2018年 XiaoHai. All rights reserved.
//

#import "XHSSScrollPopWindow.h"

@interface XHSSScrollPopWindow () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *pageViewFrameArr;

// reuse
@property (nonatomic, assign) CGFloat currentOffset;
//@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIView *currentPageView;
@property (nonatomic, strong) NSMutableDictionary<NSString*, NSMutableArray*> *reusePool;
@property (nonatomic, strong) NSMutableArray<UIView*> *pageViewArr;
@property (nonatomic, strong) NSMutableDictionary<NSString*, NSString*> *identifierMapToPageClassDic;

@end



@implementation XHSSScrollPopWindow

#pragma mark - setter & getter

- (NSMutableDictionary<NSString*, NSMutableArray*>*)reusePool {
    if (_reusePool == nil) {
        _reusePool = [NSMutableDictionary dictionary];
    }
    return _reusePool;
}

- (NSMutableArray<UIView*>*)pageViewArr {
    if (_pageViewArr == nil) {
        _pageViewArr = [NSMutableArray array];
    }
    return _pageViewArr;
}

- (NSMutableDictionary<NSString*, NSString*>*)identifierMapToPageClassDic {
    if (_identifierMapToPageClassDic == nil) {
        _identifierMapToPageClassDic = [NSMutableDictionary dictionary];
    }
    return _identifierMapToPageClassDic;
}



- (void)setMaxAvilableScrollIndex:(NSInteger)maxAvilableScrollIndex {
    _maxAvilableScrollIndex = maxAvilableScrollIndex;
    
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame)*_maxAvilableScrollIndex,
                                         CGRectGetHeight(_scrollView.frame));
}

- (NSMutableArray*)pageViewFrameArr {
    if (_pageViewFrameArr == nil) {
        _pageViewFrameArr = [NSMutableArray array];
    }
    return _pageViewFrameArr;
}

- (void)setDelegate:(id<XHSSScrollPopWindowDelegate>)delegate {
    _delegate = delegate;
    
    [self addItemView];
}

#pragma mark - UI
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setuoUI];
    }
    return self;
}

- (void)setuoUI {
    self.maxAvilableScrollIndex = 0;
    self.frame = [UIApplication sharedApplication].keyWindow.bounds;
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = self.bounds;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [_scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInScrollView:)]];
    [self addSubview:_scrollView];
}

- (void)layoutSubviews {
    _scrollView.frame = self.bounds;
    
    if (self.delegate) {
        return;
    }
    [self addItemView];
}

- (void)addItemView {
    NSInteger itemViewCount = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageNumberInScrollPopWindow:)]) {
        itemViewCount = [self.delegate pageNumberInScrollPopWindow:self];
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame)*MIN(itemViewCount, _maxAvilableScrollIndex),
                                             CGRectGetHeight(_scrollView.frame));
        
        if (_reuseEnable) {
            itemViewCount = 3;
            [self.pageViewFrameArr removeAllObjects];
            [self.pageViewArr removeAllObjects];
            for (NSInteger index = 0; index < itemViewCount; index++) {
                [self addReusePageViewAtIndex:index];
            }
        } else {
            [self.pageViewFrameArr removeAllObjects];
            [self.pageViewArr removeAllObjects];
            for (NSInteger index = 0; index < itemViewCount; index++) {
                [self addReusePageViewAtIndex:index];
#if 0
                UIView* itemView = nil;
                if (self.delegate && [self.delegate respondsToSelector:@selector(pageViewInScrollPopWindow:atIndex:)]) {
                    itemView = [self.delegate pageViewInScrollPopWindow:self atIndex:index];
                    if (self.delegate && [self.delegate respondsToSelector:@selector(pageViewSizeInScrollPopWindow:atIndex:)]) {
                        CGSize itemViewSize = [self.delegate pageViewSizeInScrollPopWindow:self atIndex:index];
                        CGFloat x = (CGRectGetWidth(_scrollView.frame) -itemViewSize.width)/2.0 +CGRectGetWidth(_scrollView.frame)*index;
                        CGFloat y = (CGRectGetHeight(_scrollView.frame) -itemViewSize.height)/2.0;
                        itemView.frame = CGRectMake(x, y, itemViewSize.width, itemViewSize.height);
                        [_scrollView addSubview:itemView];

                        [self.pageViewFrameArr addObject:@(itemView.frame)];
                        [self.pageViewArr addObject:itemView];
                    }
                }
#endif
            }
        }
    }
}

#pragma mark -Action
- (void)tapInScrollView:(UITapGestureRecognizer*)tap {
    CGPoint point = [tap locationInView:_scrollView];
    
    NSInteger index = _scrollView.contentOffset.x/CGRectGetWidth(_scrollView.frame);
    if (CGRectContainsPoint([self.pageViewFrameArr[index] CGRectValue], point)) {
        /// tap in page
    } else {
        [self hidden];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _currentOffset = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x/CGRectGetWidth(scrollView.frame);
    
    if (_reuseEnable) {
        [self savePageViewToReusePoolIfNeedWithIndex:index];
    }
    
    // prepare next page
    if (_reuseEnable) {
        _currentPageView = self.pageViewArr[MIN(self.pageViewArr.count -1, index)];
        if (_currentOffset > scrollView.contentOffset.x) {
            [self addReusePageViewAtIndex:index-1];
        } else if (_currentOffset < scrollView.contentOffset.x) {
            [self addReusePageViewAtIndex:index+1];
        }
    }
}

#pragma mark - public
- (void)showInView:(UIView*)superView {
    [superView addSubview:self];
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)hidden {
    [self removeFromSuperview];
}


#pragma mark - reuse
- (void)addReusePageViewAtIndex:(NSInteger)index {
    UIView *itemView;
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageViewInScrollPopWindow:atIndex:)]) {
        itemView = [self.delegate pageViewInScrollPopWindow:self atIndex:index];
        if (self.delegate && [self.delegate respondsToSelector:@selector(pageViewSizeInScrollPopWindow:atIndex:)]) {
            CGSize itemViewSize = [self.delegate pageViewSizeInScrollPopWindow:self atIndex:index];
            CGFloat x = (CGRectGetWidth(_scrollView.frame) -itemViewSize.width)/2.0 +CGRectGetWidth(_scrollView.frame)*index;
            CGFloat y = (CGRectGetHeight(_scrollView.frame) -itemViewSize.height)/2.0;
            itemView.frame = CGRectMake(x, y, itemViewSize.width, itemViewSize.height);
            [_scrollView addSubview:itemView];
            
            
            if (index >= self.pageViewFrameArr.count) {
                [self.pageViewFrameArr addObject:@(itemView.frame)];
            } else {
                [self.pageViewFrameArr replaceObjectAtIndex:index withObject:@(itemView.frame)];
            }
            
            if (index >= self.pageViewArr.count) {
                [self.pageViewArr addObject:itemView];
            } else if ([self.pageViewArr[index] isMemberOfClass:[itemView class]]) {
                [self.pageViewArr replaceObjectAtIndex:index withObject:itemView];
            }
        }
        
        if (_reuseEnable) {
            [self savePageViewToReusePoolIfNeedWithIndex:index];
        }
    }
}

- (void)savePageViewToReusePoolIfNeedWithIndex:(NSInteger)index {
    if (index < self.pageViewFrameArr.count &&
        (CGRectGetMaxX(self.pageViewArr[index].frame) <= -CGRectGetWidth(_scrollView.frame) ||
         CGRectGetMinX(self.pageViewArr[index].frame) >= +CGRectGetWidth(_scrollView.frame)*2)) {
            __weak typeof(self) weakSelf = self;
            
            [self.identifierMapToPageClassDic.allKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull identifier, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *pageClassName = weakSelf.identifierMapToPageClassDic[identifier];
                if ([weakSelf.pageViewArr[index] isMemberOfClass:NSClassFromString(pageClassName)]) {
                    [weakSelf.reusePool[identifier] addObject:weakSelf.pageViewArr[index]];
                    //[weakSelf.pageViewArr[index] removeFromSuperview];
                    *stop = YES;
                }
            }];
        }
}

- (UIView*)reusePageViewOfClass:(Class)pageClass withIdentifier:(NSString*)identifier {
    self.reuseEnable = YES;
    [self.identifierMapToPageClassDic setObject:NSStringFromClass(pageClass) forKey:identifier];
//    NSLog(@"<<<<<<<identifierMapToPageClassDic = %@>>>>>>>", self.identifierMapToPageClassDic);
    
    if (self.reusePool[identifier] == nil) {
        [self.reusePool setObject:[NSMutableArray array] forKey:identifier];
    }
    
    __block UIView *pageView;
    if (self.reusePool[identifier].count == 0 || self.reusePool[identifier].lastObject == nil) {
        pageView = [[pageClass alloc] init];
    } else {
        __weak typeof(self) weakSelf = self;
        [self.reusePool[identifier] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIView* reusePageView = (UIView*)obj;
            if (reusePageView != _currentPageView &&
                reusePageView != weakSelf.pageViewArr[MAX(0, MIN(idx+1, weakSelf.pageViewArr.count -1))] &&
                weakSelf.pageViewArr.count > 0 &&
                reusePageView != weakSelf.pageViewArr[MIN(weakSelf.pageViewArr.count -1, MAX(idx-1, 0))]) {
                pageView = reusePageView;
                *stop = YES;
            }
        }];
        
        if (pageView) {
            [self.reusePool[identifier] removeObject:pageView];
        } else {
            pageView = [[pageClass alloc] init];
        }
    }
    return pageView;
}

@end
