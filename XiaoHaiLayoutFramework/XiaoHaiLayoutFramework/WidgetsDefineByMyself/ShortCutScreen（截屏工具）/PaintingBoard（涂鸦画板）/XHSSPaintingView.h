//
//  XHSSPaintingView.h
//  TestCollectionViewLayout
//
//  Created by Apple on 2017/11/28.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHSSPaintingView : UIView

@property (nonatomic, copy) void(^finishCallback)(UIImage *image);
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSMutableArray *btnColorArr;

@end
