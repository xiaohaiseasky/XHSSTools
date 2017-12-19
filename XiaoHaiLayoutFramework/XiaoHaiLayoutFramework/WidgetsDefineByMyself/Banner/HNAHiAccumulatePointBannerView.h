//
//  HNAHiAccumulatePointBannerView.h
//  YUYTrip
//
//  Created by Apple on 2017/10/14.
//  Copyright © 2017年 HNA. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^HNAHiAccumulatePointBannerViewTapCallBack)(NSInteger clickIndex);

@interface HNAHiAccumulatePointBannerView : UIView

@property (nonatomic, strong) NSMutableArray *imagesArr;
@property (nonatomic, copy) HNAHiAccumulatePointBannerViewTapCallBack callBack;

@end
