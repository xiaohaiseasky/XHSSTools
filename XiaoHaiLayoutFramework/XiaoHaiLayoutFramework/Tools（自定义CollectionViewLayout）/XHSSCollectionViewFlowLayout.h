//
//  XHSSCollectionViewFlowLayout.h
//  TestCollectionViewLayout
//
//  Created by Apple on 2017/11/30.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//
//
//
// *** 这里的算法效果达到了 ，但是性能未做优化 ***
//
// *** 应该提供一个 最小可用高度的 值 ***
//
//
// *** 简单布局未做优化
//




#import <UIKit/UIKit.h>

/**
 layout delegate
 */
@class XHSSCollectionViewLayoutInfoModel;
@protocol XHSSCollectionViewLayoutDelegate <NSObject>

@required
- (XHSSCollectionViewLayoutInfoModel*)collectionViewFlowLayout:(UICollectionViewFlowLayout*)flowLayout layoutInfoForIndexPath:(NSIndexPath*)indexPath;

@end



/**
 layout
 */
typedef NS_ENUM(NSUInteger, XHSSCollectionViewFlowLayoutType) {
    XHSSCollectionViewFlowLayoutTypeSimpleOriginSize,
    XHSSCollectionViewFlowLayoutTypeSimpleWidthFitOnly,
    XHSSCollectionViewFlowLayoutTypeSimpleWidthFitHeightRatio,
    XHSSCollectionViewFlowLayoutTypeComplex,
};

@interface XHSSCollectionViewFlowLayout : UICollectionViewFlowLayout

// 简单布局 OR 复杂布局`
@property (nonatomic, assign) XHSSCollectionViewFlowLayoutType layoutType;

// 简单布局

// 复杂布局，计算量大，没有做优化
@property (nonatomic, weak) id<XHSSCollectionViewLayoutDelegate> layoutDelegate;
- (instancetype)initWithDelegate:(id<XHSSCollectionViewLayoutDelegate>) layoutDelegate;

@end



/**
 layout information
 */
@interface XHSSCollectionViewLayoutInfoModel : NSObject

// section
@property (nonatomic, assign) UIEdgeInsets sectionEdgeInsets;

// header
@property (nonatomic, assign) UIEdgeInsets sectionHeaderEdgeInsets;
@property (nonatomic, assign) CGSize sectionHeaderSize;

// footer
@property (nonatomic, assign) UIEdgeInsets sectionFooterEdgeInsets;
@property (nonatomic, assign) CGSize sectionFooterSize;

// item
@property (nonatomic, assign) CGSize itemSize;

// 复杂布局时使用以下 item 的相关属性
/*** 只有复杂布局时候才设置这个属性值 ***/
@property (nonatomic, assign) UIEdgeInsets itemEdgeInsets;

// 简繁布局时使用以下 item 的相关属性
/* 复杂布局时 minimumLineSpacing minimumInteritemSpacing 通过 itemEdgeInsets 属性控制 */
/*** 要保证简单布局时候以下属性所有 model 中保持一致 ***/
@property (nonatomic, assign) CGFloat minimumLineSpacing;
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;
@property (nonatomic, assign) NSInteger columnNumber;
@property (nonatomic, assign) CGFloat fixYOffset; // 调节 Y 方向的偏移，来解除 minimumLineSpacing 的约束

@end
