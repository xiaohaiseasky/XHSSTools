//
//  XHSSVideoEditView.h
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/11/1.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHSSVideoEditView : UIView

@property (nonatomic, assign) double duration;
@property (nonatomic, copy) void(^valueChangeCallback)(float leftValue, CGFloat rightValue, UIImageView *imageView);
@property (nonatomic, copy) void(^doneCallback)();

@end
