//
//  XHSSAssetPickerViewController.h
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/10/23.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef NS_ENUM(NSUInteger, XHSSAssetType) {
    XHSSAssetTypeImage,
    XHSSAssetTypeVideo,
    XHSSAssetTypeAudio,
};

@interface XHSSAssetPickerVC : UIViewController

@property (nonatomic, strong) PHAssetCollection *assetCollection;

@end


/**
 base cell
 */
typedef void(^XHSSSelecteAssetCallback)(XHSSAssetType assetType, BOOL isSelected, NSIndexPath *indexPath);
@interface XHSSCollectionViewBaseItem : UICollectionViewCell

- (void)setData:(UIImage *)image;
- (void)setItemIndexPath:(NSIndexPath*)indexPath withCallback:(XHSSSelecteAssetCallback)callback;

@end

/**
 cell 上选择提示视图
 */
@interface XHSSSelecteTipView : UIView

@property (nonatomic, strong) UIColor *strokeColor;

@end


/**
 image cell
 */
@interface XHSSCollectionViewImageItem : XHSSCollectionViewBaseItem

@end



/**
 video cell
 */
@interface XHSSCollectionViewVideoItem : XHSSCollectionViewBaseItem

@end


/**
 section header
 */
@interface XHSSCollectionSectionHeader : UICollectionReusableView

- (void)setTitle:(NSString*)title;

@end


