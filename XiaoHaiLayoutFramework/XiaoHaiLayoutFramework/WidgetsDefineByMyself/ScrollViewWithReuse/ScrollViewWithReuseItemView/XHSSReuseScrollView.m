//
//  XHSSReuseScrollView.m
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2018/1/16.
//  Copyright © 2018年 XiaoHai. All rights reserved.
//

#import "XHSSReuseScrollView.h"

@interface XHSSReuseScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableDictionary<NSString*, NSMutableArray<UIView*> *> *reusePool;   // dic
@property (nonatomic, strong) NSMutableArray<UIView*> *pageViewArr;
@property (nonatomic, strong) NSMutableDictionary<NSString*, NSString*> *identifierMapToPageClassDic;

@end

@implementation XHSSReuseScrollView
- (NSMutableDictionary<NSString*, NSMutableArray<UIView*> *> *)reusePool {
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

#pragma mark - UI
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.delegate = self;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInScrollView:)]];
}

- (void)layoutSubviews {
    if (self.dataSource) {
        return;
    }
    [self addItemView];
}

- (void)addItemView {
    NSInteger itemViewCount = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfItemInScrollView:)]) {
        itemViewCount = [self.dataSource numberOfItemInScrollView:self];
        if (_scrollDirection == XHSSReuseScrollViewScrollDirectionHorizontal) {
            self.contentSize = CGSizeMake(CGRectGetWidth(self.frame),
                                          CGRectGetHeight(self.frame));
        } else {
            
        }
        
        
        [self.pageViewArr removeAllObjects];
        for (NSInteger index = 0; index < itemViewCount; index++) {
            [self addReusePageViewAtIndex:index];
        }
    }
}

#pragma mark -Action
- (void)tapInScrollView:(UITapGestureRecognizer*)tap {
    CGPoint point = [tap locationInView:self];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.pageViewArr enumerateObjectsUsingBlock:^(UIView * _Nonnull itemView, NSUInteger idx, BOOL * _Nonnull stop) {
        //
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}

#pragma mark - reuse
- (void)addReusePageViewAtIndex:(NSInteger)index {
    UIView *itemView;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(itemViewInScrollView:atIndex:)]) {
        itemView = [self.dataSource itemViewInScrollView:self atIndex:index];
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(itemViewSizeInScrollView:atIndex:)]) {
            /// *** ***
            CGSize itemViewSize = [self.dataSource itemViewSizeInScrollView:self atIndex:index];
            CGFloat x = (CGRectGetWidth(self.frame) -itemViewSize.width)/2.0 +CGRectGetWidth(self.frame)*index;
            CGFloat y = (CGRectGetHeight(self.frame) -itemViewSize.height)/2.0;
            itemView.frame = CGRectMake(x, y, itemViewSize.width, itemViewSize.height);
            [self addSubview:itemView];
            
            if (index >= self.pageViewArr.count) {
                [self.pageViewArr addObject:itemView];
            } else if ([self.pageViewArr[index] isMemberOfClass:[itemView class]]) {
                [self.pageViewArr replaceObjectAtIndex:index withObject:itemView];
            }
        }
        
        [self saveItemViewToReusePoolIfNeedWithIndex:index];
    }
}

- (void)saveItemViewToReusePoolIfNeedWithIndex:(NSInteger)index {
    /// *** horizontal ***
    if (index < self.pageViewArr.count &&
        (CGRectGetMaxX(self.pageViewArr[index].frame) <= 0 ||
         CGRectGetMinX(self.pageViewArr[index].frame) >= CGRectGetWidth(self.frame))) {
            __weak typeof(self) weakSelf = self;
            [self.identifierMapToPageClassDic.allKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull identifier, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *pageClassName = weakSelf.identifierMapToPageClassDic[identifier];
                if ([weakSelf.pageViewArr[index] isMemberOfClass:NSClassFromString(pageClassName)]) {
                    [weakSelf.reusePool[identifier] addObject:weakSelf.pageViewArr[index]];
                    //[weakSelf.pageViewArr[index] removeFromSuperview];
                    
                    [weakSelf.pageViewArr removeObjectAtIndex:index];
                    *stop = YES;
                }
            }];
        }
    /// *** vertical ***
    else {
        
    }
}

- (UIView*)reuseItemViewOfClass:(Class)pageClass withIdentifier:(NSString*)identifier {
    [self.identifierMapToPageClassDic setObject:NSStringFromClass(pageClass) forKey:identifier];
    //    NSLog(@"<<<<<<<identifierMapToPageClassDic = %@>>>>>>>", self.identifierMapToPageClassDic);
    
    if (self.reusePool[identifier] == nil) {
        [self.reusePool setObject:[NSMutableArray array] forKey:identifier];
    }
    
    __block UIView *itemView;
    if (self.reusePool[identifier].count == 0 || self.reusePool[identifier].lastObject == nil) {
        itemView = [[pageClass alloc] init];
    } else {
        itemView = self.reusePool[identifier].lastObject;
        
        if (itemView) {
            //[self.reusePool[identifier] removeObject:itemView];
            [self.reusePool[identifier] removeLastObject];
        } else {
            itemView = [[pageClass alloc] init];
        }
    }
    return itemView;
}

@end
