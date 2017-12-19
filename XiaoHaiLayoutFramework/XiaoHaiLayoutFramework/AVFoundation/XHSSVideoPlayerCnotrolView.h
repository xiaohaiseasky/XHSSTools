//
//  XHSSVideoPlayerCnotrolView.h
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/10/26.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHSSVideoPlayerCnotrolView : UIView

@property (nonatomic, assign) double duration;
@property (nonatomic, copy) void(^valueChangeCallback)(float leftValue, CGFloat rightValue, UIImageView *imageView);
@property (nonatomic, copy) void(^doneCallback)();

@end
