//
//  HNAHiAccumulatePointCalendarView.h
//  YUYTrip
//
//  Created by Apple on 2017/10/14.
//  Copyright © 2017年 HNA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNAHiAccumulatePointCalendarView : UIView

@end


/*
 * 控件中的日历列表部分
 */
@interface HNACalendarView : UIView

// 选择上一个月
- (NSDate *)goPreventMonth;

// 选择下一个月
- (NSDate *)goNextMonth;

// 签到成功
- (void)signSuccess;

#warning unfinish implementation
////////////////////////////////////////////////////////////
// bg image
@property (nonatomic, strong) UIImage *bgImage;
// title
@property (nonatomic, copy) NSString *title;
// prevent btn image
@property (nonatomic, strong) UIImage *preBtnImage;
// next btn image
@property (nonatomic, strong) UIImage *nextBtnImage;
// action btn title
@property (nonatomic, copy) NSString *btnTitle;
/////////////////////////////////////////////////////////////
@property (nonatomic, strong) UIColor *higlightColor;
@property (nonatomic, strong) UIColor *nomalColor;
@property (nonatomic, strong) UIColor *dimColor;

@end
