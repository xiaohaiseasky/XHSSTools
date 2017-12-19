//
//  XHSSCollectionViewFlowLayout.m
//  TestCollectionViewLayout
//
//  Created by Apple on 2017/11/30.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import "XHSSCollectionViewFlowLayout.h"

@interface XHSSCollectionViewFlowLayout ()

@property (nonatomic, strong) NSMutableArray *laAttributesArr;  //  所有的布局属性

// 布局时标记最大contentsize 的 y坐标
@property (nonatomic, assign) CGFloat maxY;

#pragma mark - ============SIMPLE BEGIN=============
@property (nonatomic, assign) CGFloat shortestColumn;
//@property (nonatomic, assign) CGSize cachItemSize;
@property (nonatomic, assign) CGFloat lastSectionEdgeInsetsBottomValue;
@property (nonatomic, strong) NSMutableArray *heightsArr;
#pragma mark - ============SIMPLE END=============

#pragma mark - ============COMPLEX BEGIN=============
@property (nonatomic, assign) CGFloat minAvilableWith;
@property (nonatomic, strong) NSMutableDictionary *avilableFramesDic;
@property (nonatomic, strong) NSMutableArray *avilableHeightsArr;
@property (nonatomic, strong) NSMutableArray *tempHeightArr;
#pragma mark - ============COMPLEX END=============

@end

@implementation XHSSCollectionViewFlowLayout

#pragma mark - ============SIMPLE BEGIN=============
- (NSMutableArray*)heightsArr {
    if (_heightsArr == nil) {
        _heightsArr = [NSMutableArray array];
    }
    return _heightsArr;
}
#pragma mark - ============SIMPLE END=============

#pragma mark - ============BEGIN=============
- (NSMutableArray*)avilableHeightsArr {
    if (_avilableHeightsArr == nil) {
        _avilableHeightsArr = [NSMutableArray array];
    }
    return _avilableHeightsArr;
}

- (NSMutableArray*)tempHeightArr {
    if (_tempHeightArr == nil) {
        _tempHeightArr = [NSMutableArray array];
    }
    return _tempHeightArr;
}

- (NSMutableDictionary*)avilableFramesDic {
    if (_avilableFramesDic == nil) {
        _avilableFramesDic = [NSMutableDictionary dictionary];
    }
    return _avilableFramesDic;
}
#pragma mark - ============END=============

#pragma mark - setter & getter
- (NSMutableArray*)laAttributesArr {
    if (_laAttributesArr == nil) {
        _laAttributesArr = [NSMutableArray array];
    }
    return _laAttributesArr;
}

#pragma mark - init
- (instancetype)initWithDelegate:(id<XHSSCollectionViewLayoutDelegate>)layoutDelegate {
    if (self = [self init]) {
        self.layoutDelegate = layoutDelegate;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initValue];
    }
    return self;
}

- (void)initValue {
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    self.headerReferenceSize = CGSizeMake(self.collectionView.frame.size.width, 0);
    self.footerReferenceSize = CGSizeMake(self.collectionView.frame.size.width, 0);
    
    self.minAvilableWith = 10;
}

#pragma mark - rewrite
/**
 prepareLayout
 */
- (void)prepareLayout {
    [super prepareLayout];
    
    [self.laAttributesArr removeAllObjects];
    
    self.maxY = 0;
    
    NSInteger sectionCount = self.collectionView.numberOfSections;
    for (NSInteger section=0; section<sectionCount; section++) {
        
        NSIndexPath * sectionIndexPath = [NSIndexPath indexPathWithIndex:section];
        // header
        UICollectionViewLayoutAttributes *headerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:sectionIndexPath];
        [self.laAttributesArr addObject:headerAttributes];
        
        // footer
        UICollectionViewLayoutAttributes *footerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:sectionIndexPath];
        [self.laAttributesArr addObject:footerAttributes];
        
        
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger item=0; item<itemCount; item++) {
            
            // indexPath
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            // cell
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.laAttributesArr addObject:attributes];
        }
    }
}

/**
 ContentSize
 */
- (CGSize)collectionViewContentSize {
    CGFloat totalHeight = self.maxY+10;
    return CGSizeMake(self.collectionView.frame.size.width, totalHeight);
}

/**
 layoutAttributesForElementsInRect
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return _laAttributesArr;
}

//////////////////////
/**
 Item
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *cellAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    cellAttributes.frame = [self componentPositionAtIndexPath:indexPath componentKind:@""];
    return cellAttributes;
}

/**
 Supplementary
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *cellAttributes;
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        cellAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
        cellAttributes.frame = [self componentPositionAtIndexPath:indexPath componentKind:UICollectionElementKindSectionHeader];
    } else {
        cellAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:indexPath];
        cellAttributes.frame = [self componentPositionAtIndexPath:indexPath componentKind:UICollectionElementKindSectionFooter];
    }
    return cellAttributes;
}

/**
 Decoration
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *cellAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:indexPath];
    cellAttributes.frame = CGRectMake(0,
                                      self.maxY/*indexPath.item/2*(100+10)*/,
                                      self.collectionView.frame.size.width,
                                      100);
    return cellAttributes;
}

/**
 shouldInvalidateLayoutForBoundsChange
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return NO;
}

#pragma mark - Tools
- (CGRect)componentPositionAtIndexPath:(NSIndexPath*)indexPath componentKind:(NSString*)kind {
    CGRect frame = CGRectZero;
    if (self.layoutDelegate && [self.layoutDelegate respondsToSelector:@selector(collectionViewFlowLayout:layoutInfoForIndexPath:)]) {
        
        XHSSCollectionViewLayoutInfoModel *layoutInfo = [self.layoutDelegate collectionViewFlowLayout:self layoutInfoForIndexPath:indexPath];
        switch (self.layoutType) {
            case XHSSCollectionViewFlowLayoutTypeSimpleOriginSize: {
                frame = [self simpleLayoutWithLayoutInfo:layoutInfo kind:kind indexPath:indexPath simpleLayoutType:self.layoutType];
            }
                break;
            case XHSSCollectionViewFlowLayoutTypeSimpleWidthFitOnly: {
                frame = [self simpleLayoutWithLayoutInfo:layoutInfo kind:kind indexPath:indexPath simpleLayoutType:self.layoutType];
            }
                break;
            case XHSSCollectionViewFlowLayoutTypeSimpleWidthFitHeightRatio: {
                frame = [self simpleLayoutWithLayoutInfo:layoutInfo kind:kind indexPath:indexPath simpleLayoutType:self.layoutType];
            }
                break;
            case XHSSCollectionViewFlowLayoutTypeComplex: {
                frame = [self complexLayoutWithLayoutInfo:layoutInfo kind:kind];
            }
                break;
            default:
                break;
        }
    }
    return frame;
}

- (CGRect)simpleLayoutWithLayoutInfo:(XHSSCollectionViewLayoutInfoModel*)layoutInfo kind:(NSString*)kind indexPath:(NSIndexPath*)indexPath simpleLayoutType:(XHSSCollectionViewFlowLayoutType)layoutType {
    CGRect frame = CGRectZero;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        CGSize headerSize = layoutInfo.sectionHeaderSize;
        UIEdgeInsets headerInsets = layoutInfo.sectionHeaderEdgeInsets;
        UIEdgeInsets sectionEdgeInsets = layoutInfo.sectionEdgeInsets;
        NSInteger columnCount = layoutInfo.columnNumber;
        frame = [self positionForHeaderOrFooterAtIndexPath:indexPath
                                                      size:headerSize
                                                edgeInsets:headerInsets
                                         sectionEdgeInsets:sectionEdgeInsets
                                               columnCount:columnCount
                                                      kind:kind];
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        CGSize footerSize = layoutInfo.sectionFooterSize;
        UIEdgeInsets footerInsets = layoutInfo.sectionFooterEdgeInsets;
        UIEdgeInsets sectionEdgeInsets = layoutInfo.sectionEdgeInsets;
        NSInteger columnCount = layoutInfo.columnNumber;
        frame = [self positionForHeaderOrFooterAtIndexPath:indexPath
                                                      size:footerSize
                                                edgeInsets:footerInsets
                                         sectionEdgeInsets:sectionEdgeInsets
                                               columnCount:columnCount
                                                      kind:kind];
    } else {
        UIEdgeInsets sectionEdgeInsets = layoutInfo.sectionEdgeInsets;
        CGFloat minimumLineSpacing = layoutInfo.minimumLineSpacing;
        CGFloat minimumInteritemSpacing = layoutInfo.minimumInteritemSpacing;
        CGFloat columnNum = layoutInfo.columnNumber;
        CGSize itemSize = layoutInfo.itemSize;
        CGFloat fixY = layoutInfo.fixYOffset;
        if (![self isSimpleLayoutInfoAvilable:layoutInfo]) {
            return frame;
        }
        frame = [self positionForItemAtIndexPath:indexPath
                              minimumLineSpacing:minimumLineSpacing
                         minimumInteritemSpacing:minimumInteritemSpacing
                                    columnNumber:columnNum originSize:itemSize
                               sectionEdgeInsets:sectionEdgeInsets
                                      fixYOffset:(CGFloat)fixY
                                simpleLayoutType:layoutType];
    }
    
    return frame;
}

- (CGRect)complexLayoutWithLayoutInfo:(XHSSCollectionViewLayoutInfoModel*)layoutInfo kind:(NSString*)kind {
    CGRect frame = CGRectZero;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        CGSize headerSize = layoutInfo.sectionHeaderSize;
        UIEdgeInsets headerInsets = layoutInfo.sectionHeaderEdgeInsets;
        UIEdgeInsets sectionEdgeInsets = layoutInfo.sectionEdgeInsets;
        frame = [self positionForSize:headerSize edgeInsets:headerInsets sectionEdgeInsets:sectionEdgeInsets kind:kind];
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        CGSize footerSize = layoutInfo.sectionFooterSize;
        UIEdgeInsets footerInsets = layoutInfo.sectionFooterEdgeInsets;
        UIEdgeInsets sectionEdgeInsets = layoutInfo.sectionEdgeInsets;
        frame = [self positionForSize:footerSize edgeInsets:footerInsets sectionEdgeInsets:sectionEdgeInsets kind:kind];
    } else {
        CGSize itemSize = layoutInfo.itemSize;
        UIEdgeInsets itemEdgeInsets = layoutInfo.itemEdgeInsets;
        frame = [self positionForSize:itemSize edgeInsets:itemEdgeInsets sectionEdgeInsets:UIEdgeInsetsZero kind:@""];
    }
    return frame;
}

#pragma mark - ============== simple layout core logic ==================
- (BOOL)isSimpleLayoutInfoAvilable:(XHSSCollectionViewLayoutInfoModel*)simpleLayoutInfo {
    UIEdgeInsets itemEdgeInsets = simpleLayoutInfo.itemEdgeInsets;
    //CGFloat minimumLineSpacing = simpleLayoutInfo.minimumLineSpacing;
    //CGFloat minimumInteritemSpacing = simpleLayoutInfo.minimumInteritemSpacing;
    CGFloat columnNum = simpleLayoutInfo.columnNumber;
    if (columnNum <= 0 || [self isEdgeInsetsAvilable:itemEdgeInsets]) {
        return NO;
    }
    return YES;
}
- (NSInteger)shortestColumnHeightIndexInHeightArray:(NSMutableArray*)heightArray {
    __block NSInteger index = -1;
    __block CGFloat height = MAXFLOAT;
    [heightArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (height > [obj floatValue]) {
            height = [obj floatValue];
            index = idx;
        }
    }];
    return index;
}
- (NSInteger)heightesColumnHeightIndexInHeightArray:(NSMutableArray*)heightArray {
    __block NSInteger index = -1;
    __block CGFloat height = -123;
    [heightArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (height < [obj floatValue]) {
            height = [obj floatValue];
            index = idx;
        }
    }];
    return index;
}
- (CGRect)positionForHeaderOrFooterAtIndexPath:(NSIndexPath*)indexPath size:(CGSize)size edgeInsets:(UIEdgeInsets)edgeInsets sectionEdgeInsets:(UIEdgeInsets)sectionEdgeInsets columnCount:(NSInteger)columnCount kind:kind {
    
    CGRect resultFrame = CGRectMake(0, 0, self.collectionView.frame.size.width, 0);
    
    if ([self isSizeValueAvilable:size]) {
        // here NO should can be selected
        BOOL hasSectionEdgeInsets = NO;
        BOOL hasEdgeInsets = [self isEdgeInsetsAvilable:edgeInsets];
        
        CGFloat x = (hasSectionEdgeInsets ? sectionEdgeInsets.left : 0) +(hasEdgeInsets ? edgeInsets.left : 0);
        NSInteger heightestColumnIndex = [self heightesColumnHeightIndexInHeightArray:self.heightsArr];
        
        CGFloat y = 0;
        if (kind == UICollectionElementKindSectionHeader) {
            y = heightestColumnIndex < 0 ?
            (hasSectionEdgeInsets ? sectionEdgeInsets.top : 0) +(hasEdgeInsets ? edgeInsets.top : 0) :
            [self.heightsArr[heightestColumnIndex] floatValue] +(hasEdgeInsets ? edgeInsets.top : 0);
        } else if (kind == UICollectionElementKindSectionFooter) {
            y = heightestColumnIndex < 0 ?
            (hasEdgeInsets ? edgeInsets.top : 0) :
            [self.heightsArr[heightestColumnIndex] floatValue] +(hasEdgeInsets ? edgeInsets.top : 0);
        }
        
        // *** it is not deal with, if width is big than collection view width, height should be can selecte ratio or not ***
        CGFloat totalWidth = self.collectionView.frame.size.width -(hasSectionEdgeInsets ? sectionEdgeInsets.left +sectionEdgeInsets.right : 0 +0) -(hasEdgeInsets ? edgeInsets.left +edgeInsets.right : 0 +0);
        CGFloat w = size.width <= 0 ? totalWidth : size.width;
        CGFloat h = size.height;
        resultFrame = CGRectMake(x, y, w, h);
        
        // update height array
        hasSectionEdgeInsets = [self isEdgeInsetsAvilable:sectionEdgeInsets];
        [self.heightsArr removeAllObjects];
        for (NSInteger i=0; i<columnCount; i++) {
            [self.heightsArr addObject:@(CGRectGetMaxY(resultFrame)
             +(hasEdgeInsets ? edgeInsets.bottom : 0)
             +((kind == UICollectionElementKindSectionHeader) ? 0/*(hasSectionEdgeInsets ? sectionEdgeInsets.top : 0)*/ : 0)
             +((kind == UICollectionElementKindSectionFooter) ? self.lastSectionEdgeInsetsBottomValue : 0))];
        }
        self.lastSectionEdgeInsetsBottomValue = hasSectionEdgeInsets ? sectionEdgeInsets.bottom : 0;
        
        // update scrollView content size
        self.maxY = [self.heightsArr[0] floatValue];
    }
    
    return resultFrame;
}
- (CGRect)positionForItemAtIndexPath:(NSIndexPath*)indexPath
                  minimumLineSpacing:(CGFloat)minimumLineSpacing
             minimumInteritemSpacing:(CGFloat)minimumInteritemSpacing
                        columnNumber:(NSInteger)columnNumber
                          originSize:(CGSize)originSize
                   sectionEdgeInsets:(UIEdgeInsets)sectionEdgeInsets
                          fixYOffset:(CGFloat)fixY
                    simpleLayoutType:(XHSSCollectionViewFlowLayoutType)layoutType {
    
    CGRect resultFrame = CGRectZero;
    
    if (![self isSizeValueAvilable:originSize]) {
        return resultFrame;
    }
    
    // *** below varibles should be cached ***
    BOOL hasSectionEdgeInsets = [self isEdgeInsetsAvilable:sectionEdgeInsets];
    CGFloat totalWidth = self.collectionView.frame.size.width - (hasSectionEdgeInsets ? sectionEdgeInsets.left +sectionEdgeInsets.right : 0 +0);
    
    CGFloat startX = hasSectionEdgeInsets ? sectionEdgeInsets.left : 0;
    CGFloat startY = hasSectionEdgeInsets ? sectionEdgeInsets.top : 0;
    
    CGFloat itemWidthIfFitStyle = (totalWidth -minimumInteritemSpacing*(columnNumber-1))/columnNumber;
    CGFloat itemHeightIfRatioStype = itemWidthIfFitStyle*(originSize.height/originSize.width);
    
    // find the shortest column
    NSInteger shortestIndex = [self shortestColumnHeightIndexInHeightArray:self.heightsArr];
    
    // left origin layout
    if (shortestIndex < 0) {
        [self.heightsArr removeAllObjects];
        for (NSInteger i=0; i<columnNumber; i++) {
            [self.heightsArr addObject:@(startY)];
        }
        
        switch (layoutType) {
            case XHSSCollectionViewFlowLayoutTypeSimpleOriginSize: {
                // *** if originSize do not equal together ***
                resultFrame = CGRectMake(startX, startY, originSize.width, originSize.height);
                self.heightsArr[indexPath.item%columnNumber] = @(CGRectGetMaxY(resultFrame)/*originSize.height*/ +minimumLineSpacing +fixY);
            }
                break;
            case XHSSCollectionViewFlowLayoutTypeSimpleWidthFitOnly: {
                resultFrame = CGRectMake(startX, startY, itemWidthIfFitStyle, originSize.height);
                self.heightsArr[indexPath.item%columnNumber] = @(CGRectGetMaxY(resultFrame)/*originSize.height*/ +minimumLineSpacing +fixY);
            }
                break;
            case XHSSCollectionViewFlowLayoutTypeSimpleWidthFitHeightRatio: {
                resultFrame = CGRectMake(startX, startY, itemWidthIfFitStyle, itemHeightIfRatioStype);
                self.heightsArr[indexPath.item%columnNumber] = @(CGRectGetMaxY(resultFrame)/*itemHeightIfRatioStype*/ +minimumLineSpacing +fixY);
            }
                break;
            default:
                break;
        }
        
        // update scrollView content size
        self.maxY = [self.heightsArr[indexPath.item%columnNumber] floatValue];
    }
    // not left origin layout
    else {
        switch (layoutType) {
            case XHSSCollectionViewFlowLayoutTypeSimpleOriginSize: {
                // *** if originSize do not equal together
                resultFrame = CGRectMake(startX +(originSize.width +minimumInteritemSpacing)*(shortestIndex),
                                         0 +[self.heightsArr[shortestIndex] floatValue],
                                         originSize.width,
                                         originSize.height);
                self.heightsArr[shortestIndex] = @([self.heightsArr[shortestIndex] floatValue] +originSize.height +minimumLineSpacing +fixY);
            }
                break;
            case XHSSCollectionViewFlowLayoutTypeSimpleWidthFitOnly: {
                resultFrame = CGRectMake(startX +(itemWidthIfFitStyle +minimumInteritemSpacing)*(shortestIndex),
                                         0 +[self.heightsArr[shortestIndex] floatValue],
                                         itemWidthIfFitStyle,
                                         originSize.height);
                self.heightsArr[shortestIndex] = @([self.heightsArr[shortestIndex] floatValue] +originSize.height +minimumLineSpacing +fixY);
            }
                break;
            case XHSSCollectionViewFlowLayoutTypeSimpleWidthFitHeightRatio: {
                resultFrame = CGRectMake(startX +(itemWidthIfFitStyle +minimumInteritemSpacing)*(shortestIndex),
                                         0 +[self.heightsArr[shortestIndex] floatValue],
                                         itemWidthIfFitStyle,
                                         itemHeightIfRatioStype);
                self.heightsArr[shortestIndex] = @([self.heightsArr[shortestIndex] floatValue] +itemHeightIfRatioStype +minimumLineSpacing +fixY);
            }
                break;
            default:
                break;
        }
        
        // update scrollView content size
        self.maxY = [self.heightsArr[[self heightesColumnHeightIndexInHeightArray:self.heightsArr]] floatValue];
    }
    
    return resultFrame;
}



#pragma mark - ============== complex layout core logic ==================
- (BOOL)isSizeValueAvilable:(CGSize)size {
    return (size.width >= 0 &&
            size.height >= 0);
}

- (BOOL)isEdgeInsetsAvilable:(UIEdgeInsets)edgeInsets {
    return (edgeInsets.top >= 0 &&
            edgeInsets.left >= 0 &&
            edgeInsets.bottom >= 0 &&
            edgeInsets.right >= 0);
}

//
- (CGRect)positionForSize:(CGSize)itemSize edgeInsets:(UIEdgeInsets)itemEdgeInsets sectionEdgeInsets:(UIEdgeInsets)sectionEdgeInsets kind:(NSString*)kind {
    
    CGRect frame = CGRectZero;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        frame = [self frameWithSize:itemSize itemEdgeInsets:itemEdgeInsets sectionEdgeInsets:sectionEdgeInsets];
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        frame = [self frameWithSize:itemSize itemEdgeInsets:itemEdgeInsets sectionEdgeInsets:sectionEdgeInsets];
    } else {
        frame = [self frameWithSize:itemSize itemEdgeInsets:itemEdgeInsets sectionEdgeInsets:sectionEdgeInsets];
    }
    
    // update collection view contentsize
    self.maxY = [self findHeightestColumnAtHeightArray:self.avilableHeightsArr];
    return frame;
}
// return frame
- (CGRect)frameWithSize:(CGSize)size itemEdgeInsets:(UIEdgeInsets)itemEdgeInsets sectionEdgeInsets:(UIEdgeInsets)sectionEdgeInsets {
    
    CGFloat totalScrollWidth = self.collectionView.frame.size.width;
    
    // section edgeInsets
    CGFloat sectionTop = 0;
    CGFloat sectionLeft = 0;
    CGFloat sectionBottom = 0;
    CGFloat sectionRight = 0;
    
    // item edgeInsets
    CGFloat itemTop = 0;
    CGFloat itemLeft = 0;
    CGFloat itemBottom = 0;
    CGFloat itemRight = 0;
    
    // the frame will be return ai last
    CGRect resultframe = CGRectZero;
    
    // min avilable width
//    CGFloat minAvilableWith = 10;
    
    // judge if params transfor in are avilable
    if ([self isEdgeInsetsAvilable:sectionEdgeInsets]) {
        totalScrollWidth = self.collectionView.frame.size.width -sectionEdgeInsets.left -sectionEdgeInsets.right;
        sectionTop = sectionEdgeInsets.top;
        sectionLeft = sectionEdgeInsets.left;
        sectionBottom = sectionEdgeInsets.bottom;
        sectionRight = sectionEdgeInsets.right;
    }
    if ([self isEdgeInsetsAvilable:itemEdgeInsets]) {
        itemTop = itemEdgeInsets.top;
        itemLeft = itemEdgeInsets.left;
        itemBottom = itemEdgeInsets.bottom;
        itemRight = itemEdgeInsets.right;
    }
    if (![self isSizeValueAvilable:size]) {
        return CGRectMake(0, 0, self.collectionView.frame.size.width, 0);
    } else {
        // reset size value to content itemEdgeInsets value
//        size.width = itemLeft +size.width +itemRight;
//        size.height = itemTop +size.height +itemBottom;
        
        // if size is not avilable resize it
        size.width = size.width == 0 ? totalScrollWidth : size.width;
        size.width = size.width > totalScrollWidth ? totalScrollWidth : size.width;
        /*** height should can selecte for ratio or not ***/
    }
    
    self.tempHeightArr = [NSMutableArray arrayWithArray: self.avilableHeightsArr];
    
    while (self.tempHeightArr.count > 0) {
        NSString *shortestHeightkey = [self findShortestColumnAtHeightArray:self.tempHeightArr];
        CGRect targetFrame = [self sizeForShortestColumnHeight:shortestHeightkey];
        
        // *** note "="
        if (size.width +itemLeft +itemRight <= targetFrame.size.width) {
            // current position is avilable
            resultframe = [self currentAvilablePosition:targetFrame atHeightArr:self.tempHeightArr isEnoughForSize:size withEdgeInsets:itemEdgeInsets byMinAvilableWith:_minAvilableWith];
            return  resultframe;
        } else {
            // current position is not avilable
            [self.tempHeightArr removeObject:shortestHeightkey];
        }
    }
    
    // *** has not deal with the size of target item is bigger than screen width
    // layout form start, it is the left one
    resultframe = CGRectMake(sectionLeft +itemLeft,
                             [self findHeightestColumnAtHeightArray:self.avilableHeightsArr] +sectionTop +itemTop,
                             size.width -itemLeft -itemRight,
                             size.height -itemTop -itemBottom);
    // update information
    NSString *afterAddHeightKey = [self keyWithHeightValue:(CGRectGetMaxY(resultframe) +itemBottom)];
    NSString *beforeAddHeightKey = [self keyWithHeightValue:(resultframe.origin.y -itemTop)];
    
    [self.avilableHeightsArr removeAllObjects];
    [self.avilableHeightsArr addObject:afterAddHeightKey];
    [self.avilableHeightsArr addObject:beforeAddHeightKey];
    
    self.avilableFramesDic = [NSMutableDictionary dictionary];
    [self.avilableFramesDic setObject:@(CGRectMake(sectionLeft,
                                                   CGRectGetMaxY(resultframe)  +itemBottom,
                                                   size.width,
                                                   size.height))
                               forKey:afterAddHeightKey];
    NSLog(@"<<<<<<< add --- self.avilableFramesDic => %@ >>>>>>>", self.avilableFramesDic);
    
    [self.avilableFramesDic setObject:@(CGRectMake(CGRectGetMaxX(resultframe) +itemRight,
                                                   resultframe.origin.y -itemTop,
                                                   totalScrollWidth -size.width,
                                                   size.height))
                               forKey:beforeAddHeightKey];
    NSLog(@"<<<<<<< add --- self.avilableFramesDic => %@ >>>>>>>", self.avilableFramesDic);
    
    // clear
    [self clearUselessFrameAtAvilablePositionArr:self.avilableHeightsArr];
    NSLog(@"<<<<<<< clear --- self.avilableFramesDic => %@ >>>>>>>", self.avilableFramesDic);
    
    return resultframe;
}

// current avilable position is enough
- (CGRect)currentAvilablePosition:(CGRect)targetFrame atHeightArr:(NSMutableArray*)heigthArr isEnoughForSize:(CGSize)size withEdgeInsets:(UIEdgeInsets)edgeInsets byMinAvilableWith:(CGFloat)minAvilableWith {
    
    if (heigthArr.count == 0) {
        // layout form start
        return CGRectZero;
    }
    
    // item edgeInsets info
    CGFloat top = 0;
    CGFloat left = 0;
    CGFloat bottom = 0;
    CGFloat right = 0;
    if ([self isEdgeInsetsAvilable:edgeInsets]) {
        top = edgeInsets.top;
        left = edgeInsets.left;
        bottom = edgeInsets.bottom;
        right = edgeInsets.right;
    }
    
    NSString *shortestHeightkey = [self findShortestColumnAtHeightArray:heigthArr];
    
    // update last rect
    __block CGRect newRect;
    CGRect lastRect = [[self.avilableFramesDic objectForKey:shortestHeightkey] CGRectValue];
    newRect = lastRect;
    lastRect.origin.x += (left +size.width +right);
    lastRect.size.width -= (left +size.width +right);
    [self.avilableFramesDic setObject:@(lastRect) forKey:shortestHeightkey];
    
    // calculate new height
    NSString *newHeight = [NSString stringWithFormat:@"%lf", [shortestHeightkey floatValue] +(top +size.height +bottom)];
    
    // calculate new rect
    newRect.size.width = (left +size.width +right);
    newRect.origin.y += (top +size.height +bottom);
    
    // if new is equal and at together to any merge them
    __block BOOL canAdd = YES;
    [self.avilableHeightsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat height = [obj floatValue];
        /**
         *** here Loophole is find the first equal just merge, but this oparation can be leak new equal like this :
         *** (_-_)  --> (___)
         */
        if ([newHeight floatValue] == height) {
            // height equal to echother
            CGRect heightRect = [[self.avilableFramesDic objectForKey:[self keyWithHeightValue:height]] CGRectValue];
            CGRect newHeightRect = newRect; //[[self.avilableFramesDic objectForKey:newHeight] CGRectValue];
            if ((heightRect.origin.x < newHeightRect.origin.x) &&
                (heightRect.origin.x +heightRect.size.width +minAvilableWith >= newHeightRect.origin.x)) {
                ///
                heightRect.size.width += (CGRectGetMaxX(newHeightRect) -CGRectGetMaxX(heightRect));
                [self.avilableFramesDic setObject:@(heightRect) forKey:[self keyWithHeightValue:height]];
                NSLog(@"<<<<<<< reset * width --- self.avilableFramesDic => %@ >>>>>>>", self.avilableFramesDic);
            } else if ((heightRect.origin.x > newHeightRect.origin.x) &&
                       (newHeightRect.origin.x +newHeightRect.size.width +minAvilableWith >= heightRect.origin.x)) {
                ///
                heightRect.size.width += (heightRect.origin.x -newHeightRect.origin.x);
                heightRect.origin.x -= (heightRect.origin.x -newHeightRect.origin.x);
                [self.avilableFramesDic setObject:@(heightRect) forKey:[self keyWithHeightValue:height]];
                NSLog(@"<<<<<<< reset * X --- self.avilableFramesDic => %@ >>>>>>>", self.avilableFramesDic);
            } else {
                // do not at together the same height key will be replace the exist object, add 0.1 resulve thproblome
                CGFloat newHeightValue = [newHeight floatValue] +0.1f;
                // *** above opration make taht self.avilableHeightsArr do not has two components is equal
                NSString *newHeightKey = [self keyWithHeightValue:newHeightValue];
                [self.avilableHeightsArr addObject:newHeightKey];
                [self.avilableFramesDic setObject:@(newRect) forKey:newHeightKey];
                NSLog(@"<<<<<<< set * same --- self.avilableFramesDic => %@ >>>>>>>", self.avilableFramesDic);
            }
            canAdd = NO;
            *stop = YES;
        } else {
            // height do not equal to echother
            // consider for efficiency add opration do at out of enumrator
            ///
        }
    }];
    
    // consider for efficiency add opration do at here
    if (canAdd) {
        [self.avilableHeightsArr addObject:newHeight];
        [self.avilableFramesDic setObject:@(newRect) forKey:newHeight];
        NSLog(@"<<<<<<< set * normal --- self.avilableFramesDic => %@ >>>>>>>", self.avilableFramesDic);
    }
    
    // *** clear
    [self clearUselessFrameAtAvilablePositionArr:self.avilableHeightsArr];
    NSLog(@"<<<<<<< clear * out --- self.avilableFramesDic => %@ >>>>>>>", self.avilableFramesDic);
    
    return CGRectMake(targetFrame.origin.x +left, targetFrame.origin.y +top, size.width, size.height);
}

// key can be integer
- (NSString*)keyWithHeightValue:(CGFloat)height {
    return [NSString stringWithFormat:@"%lf", height];
}

// find shortest column
- (NSString*)findShortestColumnAtHeightArray:(NSMutableArray*)heightArr {
    __block CGFloat shortestHeight = MAXFLOAT;
    __block CGRect lastFrame = CGRectMake(MAXFLOAT, 0, 0, 0);
    __block CGRect currentFrame = CGRectMake(MAXFLOAT, 0, 0, 0);
    [heightArr/*self.avilableHeightsArr*/ enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat height = [obj floatValue];
        if (shortestHeight > height) {
            shortestHeight = height;
        } else if (shortestHeight == height) {
            // if height is equal, selecte the left one
            lastFrame = currentFrame;
            currentFrame = [[self.avilableFramesDic objectForKey:[self keyWithHeightValue:height]] CGRectValue];
            if (currentFrame.origin.x < lastFrame.origin.x) {
                shortestHeight = height;
            }
        }
    }];
    return [NSString stringWithFormat:@"%lf", shortestHeight];
}

// find heightest column
- (CGFloat)findHeightestColumnAtHeightArray:(NSMutableArray*)heightArr {
    __block CGFloat maxHeight = 0;
    [heightArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat height = [obj floatValue];
        if (maxHeight < height) {
            maxHeight = height;
        }
    }];
    return maxHeight;
}

// rect of frame for shortest column
- (CGRect)sizeForShortestColumnHeight:(NSString*)height {
    CGRect frame = [[self.avilableFramesDic objectForKey:height] CGRectValue];
    return frame;
}

// clear no use frame
- (void)clearUselessFrameAtAvilablePositionArr:(NSMutableArray*)array {
    [array enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // clear no use frame
        CGRect currentHeightRect = [[self.avilableFramesDic objectForKey:obj] CGRectValue];
        if (currentHeightRect.size.width < _minAvilableWith) {
            [self.avilableHeightsArr removeObject:obj];
            [self.avilableFramesDic removeObjectForKey:obj];
        }
    }];
}

@end


/**
 layout information
 */
@implementation XHSSCollectionViewLayoutInfoModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self defaultValue];
    }
    return self;
}

- (void)defaultValue {
    CGFloat defaultEdgeInsetsComponentValue = -1;
    CGFloat defaultSizeInsetsComponentValue = -1;
    
    self.sectionEdgeInsets       = UIEdgeInsetsMake(defaultEdgeInsetsComponentValue,
                                                    defaultEdgeInsetsComponentValue,
                                                    defaultEdgeInsetsComponentValue,
                                                    defaultEdgeInsetsComponentValue);
    self.sectionHeaderEdgeInsets = UIEdgeInsetsMake(defaultEdgeInsetsComponentValue,
                                                    defaultEdgeInsetsComponentValue,
                                                    defaultEdgeInsetsComponentValue,
                                                    defaultEdgeInsetsComponentValue);
    self.sectionFooterEdgeInsets = UIEdgeInsetsMake(defaultEdgeInsetsComponentValue,
                                                    defaultEdgeInsetsComponentValue,
                                                    defaultEdgeInsetsComponentValue,
                                                    defaultEdgeInsetsComponentValue);
    self.itemEdgeInsets          = UIEdgeInsetsMake(defaultEdgeInsetsComponentValue,
                                                    defaultEdgeInsetsComponentValue,
                                                    defaultEdgeInsetsComponentValue,
                                                    defaultEdgeInsetsComponentValue);
    self.sectionHeaderSize = CGSizeMake(defaultSizeInsetsComponentValue,
                                        defaultSizeInsetsComponentValue);
    self.sectionFooterSize = CGSizeMake(defaultSizeInsetsComponentValue,
                                        defaultSizeInsetsComponentValue);
    self.itemSize          = CGSizeMake(defaultSizeInsetsComponentValue,
                                        defaultSizeInsetsComponentValue);
    
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    self.columnNumber = 3;
}

@end

