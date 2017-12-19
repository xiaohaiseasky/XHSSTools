//
//  HNAHiAccumulatePointCalendarView.m
//  YUYTrip
//
//  Created by Apple on 2017/10/14.
//  Copyright © 2017年 HNA. All rights reserved.
//

#import "HNAHiAccumulatePointCalendarView.h"

typedef NS_ENUM(NSUInteger, HNAAccumulatePointSignType) {
    HNAAccumulatePointSignTypeSigned,
    HNAAccumulatePointSignTypeUnsigned,
};

@interface HNAHiAccumulatePointCalendarView ()

@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *preBtnImgView;
@property (nonatomic, strong) UIImageView *nextBtnImgView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIImageView *calendarBgImgView;
@property (nonatomic, strong) UILabel *signBtnLabel;
@property (nonatomic, strong) HNACalendarView *calendar;
@property (nonatomic, strong) NSDateFormatter *formater;

@end


static const int baseBtnTag = 1000;

@implementation HNAHiAccumulatePointCalendarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (NSDateFormatter *)formater {
    if (_formater == nil) {
        _formater = [[NSDateFormatter alloc] init];
        [_formater setDateFormat:@"YYYY年MM月"];
    }
    return _formater;
}

#pragma mark - UI
- (void)setUpView {
    
    CGFloat selfWidth = self.bounds.size.width;
    
    // 背景图片
    _bgImgView = [[UIImageView alloc] init];
    _bgImgView.frame = self.bounds;
    _bgImgView.image = [UIImage imageNamed:@"bg"];
    [self addSubview:_bgImgView];
    
    // 每日签到题目
    _titleLabel = [self labelWithFont:[UIFont boldSystemFontOfSize:23]
                                color:[UIColor whiteColor]
                         textAligment:NSTextAlignmentCenter];
    _titleLabel.frame = CGRectMake(0, 67, selfWidth, 32);
    _titleLabel.text = @"每日签到";
    [self addSubview:_titleLabel];
    
    // 显示日期的 label
    CGFloat dateLabelW = 80;
    CGFloat dateLabelH = 21;
    _dateLabel = [self labelWithFont:[UIFont systemFontOfSize:13]
                               color:[UIColor whiteColor]
                        textAligment:NSTextAlignmentCenter];
    _dateLabel.frame = CGRectMake((selfWidth - dateLabelW)/2.0, CGRectGetMaxY(_titleLabel.frame) + 3, dateLabelW, dateLabelH);
    _dateLabel.text = [self.formater stringFromDate:[NSDate date]];
    [self addSubview:_dateLabel];
    
    // 选择上一月的按钮
    CGFloat btnWidthAndHeight = 12;
    CGFloat btnLabelSpace = 14;
    _preBtnImgView = [self imageViewWithCornerRadius:0 action:@selector(preBtnClick)];
    _preBtnImgView.frame = CGRectMake(CGRectGetMinX(_dateLabel.frame) - btnLabelSpace - btnWidthAndHeight,
                                      CGRectGetMinY(_dateLabel.frame) + (CGRectGetHeight(_dateLabel.frame) - btnWidthAndHeight)/2.0,
                                      btnWidthAndHeight,
                                      btnWidthAndHeight);
    _preBtnImgView.image = [UIImage imageNamed:@"datepickerLast"];
    [self addSubview:_preBtnImgView];
    
    // 选择下一个月的按钮
    _nextBtnImgView = [self imageViewWithCornerRadius:0 action:@selector(nextBtnClick)];
    _nextBtnImgView.frame = CGRectMake(CGRectGetMaxX(_dateLabel.frame) + btnLabelSpace,
                                      CGRectGetMinY(_preBtnImgView.frame),
                                      btnWidthAndHeight,
                                      btnWidthAndHeight);
    _nextBtnImgView.image = [UIImage imageNamed:@"datepickerNext"];
    [self addSubview:_nextBtnImgView];
    
    // 日历视图
    _calendar = [[HNACalendarView alloc] initWithFrame:CGRectMake(23,
                                                                  CGRectGetMaxY(_dateLabel.frame)+8,
                                                                  self.frame.size.width-23*2,
                                                                  self.frame.size.height-8*2)];
    [self addSubview:_calendar];
    
    // 立即签到按钮
    CGFloat signBtnW = 173;
    CGFloat signBtnH = 37;
    _signBtnLabel = [self labelWithFont:[UIFont boldSystemFontOfSize:17]
                                  color:[UIColor orangeColor]
                           textAligment:NSTextAlignmentCenter];
    _signBtnLabel.frame = CGRectMake((selfWidth - signBtnW)/2.0, CGRectGetMaxY(_calendar.frame)+25, signBtnW, signBtnH);
    _signBtnLabel.backgroundColor = [UIColor yellowColor];
    _signBtnLabel.text = @"立即签到";
    _signBtnLabel.layer.cornerRadius = signBtnH/2.0;
    _signBtnLabel.clipsToBounds = YES;
    _signBtnLabel.userInteractionEnabled = YES;
    [_signBtnLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signBtnClick)]];
    [self addSubview:_signBtnLabel];
    
    // 添加所有的控件后，调整自身的 frame
    CGRect oldFrame = self.frame;
    self.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, CGRectGetMaxY(_signBtnLabel.frame)+21);
    self.bgImgView.frame = self.bounds;
    
//    [self test];
}

// 根据需要创建 Label
- (UILabel *)labelWithFont:(UIFont *)font color:(UIColor *)color textAligment:(NSTextAlignment)aligment {
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = color;
    label.textAlignment = aligment;
    return label;
}

// 根据需要创建 UIImageView
- (UIImageView *)imageViewWithCornerRadius:(CGFloat)radius action:(SEL)action {
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.userInteractionEnabled = YES;
    imgView.layer.cornerRadius = radius <= 0 ? 0 : radius;
    [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:action]];
    return imgView;
}

#pragma mark - 逻辑函数
// 签到成功弹出提示视图
- (UIView *)signSuccessTipView {
    UIImageView *tipView = [[UIImageView alloc] init];
    tipView.frame = CGRectMake(_calendar.frame.origin.x + 33,
                               _calendar.frame.origin.y + 33,
                               _calendar.frame.size.width - 33*2,
                               _calendar.frame.size.width - 33*2);
    tipView.image = [UIImage imageNamed:@"group9Copy2"];
    return tipView;
}

// 显示签到成功提示视图
- (void)showSignSuccessTipView {
    UIView *tipView = [self signSuccessTipView];
    [self addSubview:tipView];
    [self performSelector:@selector(removeTipView:) withObject:tipView afterDelay:3];
}

// 隐藏签到成功提示视图
- (void)removeTipView:(UIView *)tipView {
    [tipView removeFromSuperview];
}

#pragma mark - tap action
- (void)preBtnClick {
    NSLog(@"preMonth btn click");
    
    NSString *dateStr = [self.formater stringFromDate:[self.calendar goPreventMonth]];
    self.dateLabel.text = dateStr;
}

- (void)nextBtnClick {
    NSLog(@"nextMonth btn click");
    
    NSString *dateStr = [self.formater stringFromDate:[self.calendar goNextMonth]];
    self.dateLabel.text = dateStr;
}

#pragma mark - btn action
- (void)signBtnClick {
    NSLog(@"sing btn click");
    [self showSignSuccessTipView];
    [_calendar signSuccess];
}

#pragma mark - test 
- (void)test {
    _titleLabel.backgroundColor = [UIColor redColor];
    _dateLabel.backgroundColor = [UIColor redColor];
    _preBtnImgView.backgroundColor = [UIColor cyanColor];
    _nextBtnImgView.backgroundColor = [UIColor cyanColor];
}

@end



/*
 * 控件中的日历列表部分
 */
@interface HNACalendarView ()

@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) NSDate *currShowDate;
@property (nonatomic, strong) NSCalendar *currCalendar;

@end

@implementation HNACalendarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUPView];
    }
    return self;
}

- (NSCalendar *)currCalendar {
    if (_currCalendar == nil) {
        if ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0) {
            _currCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        } else {
            _currCalendar = [NSCalendar currentCalendar];
        }
    }
    return _currCalendar;
}

#pragma mark - UI
- (void)setUPView {
    _bgImgView = [[UIImageView alloc] init];
    _bgImgView.frame = self.bounds;
    _bgImgView.backgroundColor = [UIColor whiteColor];
    _bgImgView.layer.cornerRadius = 4;
    _bgImgView.clipsToBounds = YES;
    _bgImgView.image = [UIImage imageNamed:@""];
    [self addSubview:_bgImgView];
    
    
    [self addItemInBaseView];
    
    // refresh date
    _currShowDate = [NSDate date];
    [self refreshButtonStateWithDate:_currShowDate];
}

// 添加显示每一天的 button
- (void)addItemInBaseView {
    NSArray *weekDayTitle = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六",];
    
    NSInteger rowCount = 7;
    NSInteger columnCount = 7;
    CGFloat leftMargin = 19.0;
    CGFloat topMargin = 11;
    CGFloat horizontalSpace = 9.5;
    CGFloat verticalSpace = 9.5;
    CGFloat btnW = (self.frame.size.width-leftMargin*2-horizontalSpace*(columnCount-1))/columnCount*1.0;
    CGFloat btnH = btnW; //(self.height-topMargin*2-verticalSpace*(rowCount-1))/rowCount*1.0;
    
    for (int i = 0; i < rowCount*columnCount; i++) {
        CGRect btnFrame = CGRectMake(leftMargin+(i%columnCount)*(btnW+horizontalSpace),
                               topMargin+(i/columnCount)*(btnH+verticalSpace),
                               btnW,
                               btnH);
        UIButton *btn = [self buttonItemInCalendarWithTag:baseBtnTag+i frame:btnFrame];
        
        [self addSubview:btn];
        
        // set weekDay title
        if (i < weekDayTitle.count) {
            [btn setTitle:weekDayTitle[i] forState:UIControlStateNormal];
        }
    }
    
    CGRect oldFrame = self.frame;
    CGRect newFrame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, topMargin+rowCount*(btnH+verticalSpace)+topMargin);
    self.frame = newFrame;
    _bgImgView.frame = self.bounds;
    
    [self addSepratLineInCanlendarWithFrame:CGRectMake(12, topMargin+btnH+verticalSpace/2.0, self.bounds.size.width - 12*2, 1)];
}

// 添加日历中第一行下面的分割线
- (void)addSepratLineInCanlendarWithFrame:(CGRect)lineFrame {
    UIView *sepLine = [[UIView alloc] init];
    sepLine.frame = lineFrame;
    sepLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:sepLine];
}

// 返回一个按钮，用来显示一天
- (UIButton *)buttonItemInCalendarWithTag:(NSInteger)tag frame:(CGRect)frame {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = frame.size.width/2.0;
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = tag;
    btn.backgroundColor = [UIColor cyanColor];
    return btn;
}

#pragma mark - tap
- (void)buttonClick:(UIButton *)btn {
    NSLog(@"btn tag = %d", btn.tag);
}

#pragma mark - 日期逻辑
// 上一个月
- (NSDate *)goPreventMonth {
    NSDate *preMonth = [self calculateDateFromDate:_currShowDate ByMonthStep:-1];
    self.currShowDate = preMonth;
    [self refreshButtonStateWithDate:self.currShowDate];
    return self.currShowDate;
}

// 下一个月
- (NSDate *)goNextMonth {
    NSDate *nextMonth = [self calculateDateFromDate:_currShowDate ByMonthStep:1];
    self.currShowDate = nextMonth;
    [self refreshButtonStateWithDate:self.currShowDate];
    return self.currShowDate;
}

// 刷新按钮的状态
- (void)refreshButtonStateWithDate:(NSDate *)date {
    [self recoveryButtonState];
    
    NSInteger totalDaysOfThisMonth = [self totalDaysInThisMonth:date];
    NSInteger firstDayInThisMonth = [self firstWeekDayInThisMonth:date];
    for (NSInteger i = 0; i < totalDaysOfThisMonth; i++) {
        UIButton *btn = (UIButton*)[self viewWithTag:baseBtnTag+firstDayInThisMonth+7+i];
        [btn setTitle:[NSString stringWithFormat:@"%ld", i+1] forState:UIControlStateNormal];
    }
    
    [self hilightDateLabelOfTodayWithDate:date firstDayInThisMonth:firstDayInThisMonth];
}

// 刷新按钮状态前先回复所有按钮为默认状态
- (void)recoveryButtonState {
    for (NSInteger i = 7; i<7*7; i++) {
        UIButton *btn = (UIButton*)[self viewWithTag:baseBtnTag+i];
        [btn setTitle:@"" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor clearColor];
    }
}

// 将今天对应的日期显示为红色
- (void)hilightDateLabelOfTodayWithDate:(NSDate *)date firstDayInThisMonth:(NSInteger)firstDay  {
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM"];
    
    if (![[formater stringFromDate:[NSDate date]] isEqualToString:[formater stringFromDate:date]]) {
        return;
    }
    
    NSInteger today = [self dayNumberOfDate:[NSDate date]];
    UIButton *todayBtn = (UIButton *)[self viewWithTag:baseBtnTag+firstDay+7+today-1];
    [todayBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
}

// 设置显示日期的按钮在 签到 或 未签到 时的状态
- (void)setBtnStatusOfDate:(NSDate *)date firstDayInThisMonth:(NSInteger)firstDay signType:(HNAAccumulatePointSignType)signType {
    NSInteger dayNum = [self dayNumberOfDate:date];
    UIButton *btn = (UIButton *)[self viewWithTag:baseBtnTag+firstDay+7+dayNum-1];
    switch (signType) {
        case HNAAccumulatePointSignTypeSigned:
            btn.backgroundColor = [UIColor orangeColor];
            break;
        case HNAAccumulatePointSignTypeUnsigned:
            btn.backgroundColor = [UIColor grayColor];
            break;
        default:
            btn.backgroundColor = [UIColor clearColor];
            break;
    }
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

// 获取某个日期对应的天所代表的数字
- (NSInteger)dayNumberOfDate:(NSDate *)date {
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"dd"];
    return [[formater stringFromDate:date] integerValue];
}

// 签到成功外部调用的公共接口
- (void)signSuccess {
    [self setBtnStatusOfDate:[NSDate date] firstDayInThisMonth:[self firstWeekDayInThisMonth:[NSDate date]] signType:HNAAccumulatePointSignTypeSigned];
}

#pragma mark - 日期逻辑
// 计算一个月有几天
- (NSInteger)totalDaysInThisMonth:(NSDate *)date {
    NSRange totalDaysInMonth = [self.currCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return totalDaysInMonth.length;
}

// 计算本月第一天是星期几
- (NSInteger)firstWeekDayInThisMonth:(NSDate *)date {
    NSCalendar *calendar = self.currCalendar;
    [calendar setFirstWeekday:1];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSInteger firstWeekDay = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekDay - 1;
}

// 在所给日期基础是上，按照一个月为增量加减日期，返回计算后的日期
- (NSDate *)calculateDateFromDate:(NSDate *)date ByMonthStep:(NSInteger)step {
    NSCalendar *calendar = self.currCalendar;
    NSDateComponents *comp = [calendar components:/*NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay*/NSCalendarUnitMonth fromDate:date];
    [comp setMonth:step];
    NSDate *newDate = [calendar dateByAddingComponents:comp toDate:date options:0];
    return newDate;
}

@end


