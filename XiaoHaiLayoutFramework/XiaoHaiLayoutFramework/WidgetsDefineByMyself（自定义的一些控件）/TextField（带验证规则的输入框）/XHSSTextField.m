//
//  XHSSTextField.m
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/12/1.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import "XHSSTextField.h"

@interface XHSSTextField () <UITextFieldDelegate>

//// the view will be move up if keyboard show
//@property (nonatomic, strong) UIView *targetViewByKeyboard;
//// iphone's status bar height
//@property (nonatomic, assign) CGFloat statusBarHeight;
//
//// the object provide the viladite founction
//@property (nonatomic, strong) id viladitor;
//// the viladite founction
//@property (nonatomic, assign) SEL viladitefounction;
//// viladition call back
//@property (nonatomic, copy) void(^viladitionCallBack)(BOOL isAvilable);
//
//// shouldClear
//@property (nonatomic, assign) BOOL shouldClear;
//// shouldReturn
//@property (nonatomic, assign) BOOL shouldReturn;
//// text length control
//@property (nonatomic, assign) NSInteger minInputLength;
//@property (nonatomic, assign) NSInteger maxInputLength;
//
//// if need show message
//@property (nonatomic, assign) BOOL shouldShowMessageWhenInputValidateFaild;
//@property (nonatomic, assign) BOOL shouldShowMessageWhenInputLengthInvalidate;
//// message need show
//@property (nonatomic, copy) NSString *tipMessageWhenInputValidateFaild;
//@property (nonatomic, copy) NSString *tipMessageWhenInputLengthInvalidate;
//// tipView need show
////@property (nonatomic, strong) UIView *tipView;
//// call back when time is need show some message
//@property (nonatomic, copy) void(^needShowMessageCallBack)(NSString *message);
//
//// viladate type
//@property (nonatomic, assign) XHSSTextFieldViladateType viladateType;
//
//// text length avilable state change call back
//@property (nonatomic, copy) void(^inputLenghtAvilableStatusChangeCallBack)(BOOL isAvilable, XHSSTextFieldInputLengthAvilableType avilableType);
//// input status change call back
//@property (nonatomic, copy) void(^inputStatusChangeCallBack)(XHSSTextFieldInputStatusType inputState);

//////////////////////////////////////////////////////
@property (nonatomic, weak) id<UITextFieldDelegate> innerDelegate;
@property (nonatomic, weak) id<UITextFieldDelegate> outterDelegate;

@property (nonatomic, strong) UIView *showTipeView;

@end

@implementation XHSSTextField
#pragma mark - setter && getter
- (void)setDelegate:(id<UITextFieldDelegate>)delegate {
    [super setDelegate:self];
    if (!(delegate == self)) {
        _innerDelegate = delegate;
        _outterDelegate = delegate;
    }
}

#pragma mark - init
- (instancetype)init {
    self = [super init];
    if (self) {
        self = [self initWithFrame:CGRectZero];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)dealloc {
    [self removeNotifiction];
    [self removeTarget];
    NSLog(@"<<<<<<< TextField distoried >>>>>>>");
}

- (void)setup {
    self.delegate = self;
    [self addNotification];
    [self addTarget];
    [self setupData];
}

- (void)setupData {
    self.statusBarHeight = 20;
    self.shouldClear = YES;
    self.shouldReturn = YES;
    self.minInputLength = 0;
    self.maxInputLength = NSIntegerMax;
    self.shouldShowMessageWhenInputValidateFaild = NO;
    self.shouldShowMessageWhenInputLengthInvalidate = NO;
    self.viladateType = XHSSTextFieldViladateTypeNone;
}

#pragma mark - 键盘事件
// 添加键盘监听事件，处理视图移动的回调
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHiddenAction:) name:UIKeyboardWillHideNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChangeCallFromNoti:) name:UITextFieldTextDidChangeNotification object:textField];
}
- (void)removeNotifiction {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)addTarget {
    [self addTarget:self action:@selector(textFieldTextEditing) forControlEvents:UIControlEventEditingChanged];
//    [self addTarget:self action:@selector(textFieldTextEditingEnd) forControlEvents:UIControlEventEditingDidEndOnExit];
}
- (void)removeTarget {
    [self removeTarget:self action:@selector(textFieldTextEditing) forControlEvents:UIControlEventEditingChanged];
//    [self removeTarget:self action:@selector(textFieldTextEditingEnd) forControlEvents:UIControlEventEditingChanged];
}
// 键盘 action
- (CGRect)convertSelfFrameToWindowRect {
    return [[UIApplication sharedApplication].keyWindow convertRect:self.frame fromView:self.targetViewByKeyboard];
}
- (void)moveTargetViewWhenSelfBeginFirstResponder {
    
}

- (void)keyboardWillShowAction:(NSNotification*)notification {
    if (self.targetViewByKeyboard == nil) {
        return;
    }
    
    NSDictionary *userInfo = [notification userInfo];
    CGRect rectKeyboar = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat height = CGRectGetMinY(rectKeyboar);
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
//    CGRect rectLoginView = CGRectMake((width - self.targetViewByKeyboard.frame.size.width) / 2.0f,
//                                      (height - self.targetViewByKeyboard.frame.size.height) / 2.0f,
//                                      self.targetViewByKeyboard.frame.size.width,
//                                      self.targetViewByKeyboard.frame.size.height);
    
    CGRect rectTargetView = CGRectMake((width - self.targetViewByKeyboard.frame.size.width) / 2.0f,
                                      (height - CGRectGetMaxY([self convertSelfFrameToWindowRect])) / 2.0f,
                                      self.targetViewByKeyboard.frame.size.width,
                                      self.targetViewByKeyboard.frame.size.height);
//    if (rectTargetView.origin.y < _statusBarHeight) {
//        rectTargetView.origin.y = _statusBarHeight;
//    }
//    [UIView animateWithDuration:duration
//                     animations:^{
//                         self.targetViewByKeyboard.frame = rectTargetView;
//                     }
//                     completion:^(BOOL finished) {
//
//                     }];
    
    CGFloat keyboardH = CGRectGetHeight(rectKeyboar);
    CGFloat h = CGRectGetHeight([UIScreen mainScreen].bounds);
    CGRect convert = [self convertSelfFrameToWindowRect];
    CGFloat selfMaxY = (CGRectGetHeight([UIScreen mainScreen].bounds) -CGRectGetMaxY([self convertSelfFrameToWindowRect]));
    selfMaxY = (CGRectGetHeight([UIScreen mainScreen].bounds) -CGRectGetMaxY(self.frame));
    if (keyboardH > selfMaxY) {
        [UIView animateWithDuration:duration
                         animations:^{
                             CGRect frame = self.targetViewByKeyboard.frame;
                             frame.origin.y -= (keyboardH - selfMaxY);
                             self.targetViewByKeyboard.frame = frame;
                             
                             //self.targetViewByKeyboard.frame = rectTargetView;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
}
- (void)keyboardWillHiddenAction:(NSNotification*)notification {
    if (self.targetViewByKeyboard == nil) {
        return;
    }
    
    NSDictionary *userInfo = [notification userInfo];
    CGRect rectKeyboar = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat height = CGRectGetMinY(rectKeyboar);
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    
//    CGRect rectLoginView = CGRectMake((width - self.targetViewByKeyboard.frame.size.width) / 2.0f,
//                                      (height - self.targetViewByKeyboard.frame.size.height) / 2.0f,
//                                      self.targetViewByKeyboard.frame.size.width,
//                                      self.targetViewByKeyboard.frame.size.height);
    CGRect rectTargetView = CGRectMake((width - self.targetViewByKeyboard.frame.size.width) / 2.0f,
                                      (height - self.targetViewByKeyboard.frame.size.height) / 2.0f,
                                      self.targetViewByKeyboard.frame.size.width,
                                      self.targetViewByKeyboard.frame.size.height);
    
    [UIView animateWithDuration:duration
                     animations:^{
                         self.targetViewByKeyboard.frame = rectTargetView;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}
- (void)textFieldTextEditing {
    [self inputStatusChanged:XHSSTextFieldInputStatusTypeEditing];
}
- (void)textFieldTextEditingEnd {
    
}

#pragma mark - 内容验证
// 内部验证，外部提供验证的方法，对内容进行验证
// *** here should only require caller to provide viladite rules but not viladite founction ***
- (void)viladiteInput {
    BOOL result = NO;
    
    // custom provide first
    if (self.viladitor && [self.viladitor respondsToSelector:self.viladitefounction]) {
        result = [self.viladitor performSelector:self.viladitefounction withObject:self.text];
    } else {
        switch (self.viladateType) {
            case XHSSTextFieldViladateTypeNone: {
               // need not viladate
            }
                break;
            case XHSSTextFieldViladateTypePhoneNumberNormal: {
                result = [self isPhoneNumberAvilable:self.text];
            }
                break;
            case XHSSTextFieldViladateTypePhoneNumberStrict: {
                result = [self isPhoneNumberAvilable_exact:self.text];
            }
                break;
            case XHSSTextFieldViladateTypeEmail: {
                result = [self isEmailAddressAvilable:self.text];
            }
                break;
            case XHSSTextFieldViladateTypeIDCard: {
                result = [self isIDCardNumberAvilable:self.text];
            }
                break;
            case XHSSTextFieldViladateTypeBankAccount: {
                result = [self isBankAccountAvilable:self.text];
            }
                break;
            default:
                break;
        }
    }
    
    if (self.viladitionCallBack) {
        self.viladitionCallBack(result);
    }
    
    // show message
    if (result == NO && self.shouldShowMessageWhenInputValidateFaild) {
        [self showTipWithInfo:(self.tipMessageWhenInputValidateFaild == nil ||
                               self.tipMessageWhenInputValidateFaild.length == 0) ?
         @"请输入正确格式内容" :
         self.tipMessageWhenInputValidateFaild];
    }
}

#pragma mark - 输入事件
// 开始输入，输入内容变化，输入结束 事件监听
- (void)inputStatusChanged:(XHSSTextFieldInputStatusType)inputState {
    
    if (self.inputStatusChangeCallBack) {
        self.inputStatusChangeCallBack(inputState);
    }
    
    // viladite input and show message if needed when input end
    if (inputState == XHSSTextFieldInputStatusTypeEndEditing) {
        
        // viladate length
        [self viladiteInput];
        
        // show message
        if (([self ifInputString:self.text isTooLong:self.maxInputLength] ||
            [self ifInputString:self.text isTooShort:self.minInputLength]) &&
            self.shouldShowMessageWhenInputLengthInvalidate) {
            [self showTipWithInfo:(self.tipMessageWhenInputLengthInvalidate == nil ||
                                   self.tipMessageWhenInputLengthInvalidate.length == 0) ?
             @"输入长度非法" :
             self.tipMessageWhenInputLengthInvalidate];
        }
    }
}

#pragma mark - 内容长度控制
// 输入内容长度控制
// too long
- (BOOL)ifInputString:(NSString*)inputStr isTooLong:(NSInteger)maxLength {
    if (inputStr.length >= maxLength) {
        return YES;
    } else {
        return NO;
    }
}
// too short
- (BOOL)ifInputString:(NSString*)inputStr isTooShort:(NSInteger)minLength {
    if (inputStr.length < minLength) {
        return YES;
    } else {
        return NO;
    }
}
// can replace string in range with string
- (BOOL)shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    BOOL isLengthAvilable;
    XHSSTextFieldInputLengthAvilableType avilableType;
    
    // too long
    if (string.length + range.location >= self.maxInputLength) {
        isLengthAvilable = NO;
        avilableType = XHSSTextFieldInputLengthAvilableTypeTooLong;
    }
    // too short
    else if (string.length + range.location < self.minInputLength) {
        isLengthAvilable = YES;
        avilableType = XHSSTextFieldInputLengthAvilableTypeTooShort;
    }
    //
    else {
        isLengthAvilable = YES;
        avilableType = XHSSTextFieldInputLengthAvilableTypeAvilable;
    }
    
    // call back
    if (self.inputLenghtAvilableStatusChangeCallBack) {
        self.inputLenghtAvilableStatusChangeCallBack(isLengthAvilable, avilableType);
    }
    
    return isLengthAvilable;
}

#pragma mark - 内容
// 显示内容、样式、功能控制 [提示视图，提示信息，第一响应者]
- (void)showTipWithInfo:(NSString*)tip {
    
    // custom action first
    if (self.needShowMessageCallBack) {
        self.needShowMessageCallBack(tip);
        return;
    }
    
    if (tip == nil || tip.length == 0) {
        return;
    }
    
    if (_showTipeView) {
        [_showTipeView removeFromSuperview];
    }
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = tip;
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [tipLabel sizeToFit];
    tipLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    tipLabel.layer.cornerRadius = 7;
    tipLabel.clipsToBounds = YES;
    tipLabel.numberOfLines = 2;
    
    CGFloat windowW = [UIApplication sharedApplication].keyWindow.bounds.size.width;
    CGFloat windowH = [UIApplication sharedApplication].keyWindow.bounds.size.height;
    tipLabel.frame = CGRectMake((windowW -tipLabel.frame.size.width)/2.0,
                                (windowH -tipLabel.frame.size.height)/2.0,
                                tipLabel.frame.size.width +20,
                                tipLabel.frame.size.height +20);
    [[UIApplication sharedApplication].keyWindow addSubview:tipLabel];
    _showTipeView = tipLabel;
    
    // 动画，为了延时消失 tipLabel, performSelector 会有内存泄漏警告
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [tipLabel removeFromSuperview];
    });
}
- (void)returnColick {
    if (self.returnColickCallBack) {
        self.returnColickCallBack();
    }
    
//    // viladate length
//    [self inputStatusChanged:XHSSTextFieldInputStatusTypeEndEditing];
//    // viladate content
//    [self viladiteInput];
    
    [self resignFirstResponder];
}
#pragma mark - =================================================
#pragma mark - UITextFieldDelegate
// return NO to disallow editing.
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    // delegate first
    if (self.outterDelegate &&
        [self.outterDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [self.outterDelegate textFieldShouldBeginEditing:textField];
    }
    
    return YES;
}
// became first responder
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"%s", __func__);
    
    // delegate first
    if (self.outterDelegate &&
        [self.outterDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.outterDelegate textFieldDidBeginEditing:textField];
        return;
    }
    
    [self inputStatusChanged:XHSSTextFieldInputStatusTypeBeginEditing];
}
// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    NSLog(@"%s", __func__);
    
    // delegate first
    if (self.outterDelegate &&
        [self.outterDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [self.outterDelegate textFieldShouldEndEditing:textField];
    }
    
    return YES;
}
// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"%s", __func__);
    
    // delegate first
    if (self.outterDelegate &&
        [self.outterDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.outterDelegate textFieldDidEndEditing:textField];
        return;
    }
    
    // viladate length
    [self inputStatusChanged:XHSSTextFieldInputStatusTypeEndEditing];
    // viladate content
    [self viladiteInput];
}
// if implemented, called in place of textFieldDidEndEditing:
#if 0
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    
}
#endif
// return NO to not change text
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"%s", __func__);
    
    // delegate first
    if (self.outterDelegate &&
        [self.outterDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.outterDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    return [self shouldChangeCharactersInRange:range replacementString:string];
}
// called when clear button pressed. return NO to ignore (no notifications)
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    NSLog(@"%s", __func__);
    
    // delegate first
    if (self.outterDelegate &&
        [self.outterDelegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [self.outterDelegate textFieldShouldClear:textField];
    }
    
    return self.shouldClear;
}
// called when 'return' key pressed. return NO to ignore.
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
   NSLog(@"%s", __func__);
    
    // delegate first
    if (self.outterDelegate &&
        [self.outterDelegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [self.outterDelegate textFieldShouldReturn:textField];
    }
    
    [self returnColick];
    
    return self.shouldReturn;
}

#pragma mark - 常用正则表达式
// 手机号
- (BOOL)isPhoneNumberAvilable:(NSString*)phoneNum {
    NSString *regex = @"^[0-9]{11}";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:phoneNum];
}
- (BOOL)isPhoneNumberAvilable_exact:(NSString*)phoneNum {
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,1705
     * 联通：130,131,132,152,155,156,185,186,1709
     * 电信：133,1349,153,180,189,1700
     */
    
    /**
     * 中国移动：China Mobile
     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188，1705
     */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\\\d|705)\\\\d{7}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,152,155,156,185,186,1709
     */
    NSString * CU = @"^1((3[0-2]|5[256]|8[56])\\\\d|709)\\\\d{7}$";
    /**
     * 中国电信：China Telecom
     * 133,1349,153,180,189,1700
     */
    NSString * CT = @"^1((33|53|8[09])\\\\d|349|700)\\\\d{7}$";
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
    NSString * PHS = @"^0(10|2[0-5789]|\\\\d{3})\\\\d{7,8}$";
    
    if (([self isValueAvilable:phoneNum ByRegex:CM])
        || ([self isValueAvilable:phoneNum ByRegex:CU])
        || ([self isValueAvilable:phoneNum ByRegex:CT])
        || ([self isValueAvilable:phoneNum ByRegex:PHS])) {
        return YES;
    }else {
        return NO;
    }
}
- (BOOL)isValueAvilable:(NSString*)value ByRegex:(NSString *)regex {
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:value];
}
// 邮箱
- (BOOL)isEmailAddressAvilable:(NSString*)email {
    NSString *emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\\\.[A-Za-z]{2,4}";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    return [pre evaluateWithObject:email];
}
// 身份证
- (BOOL)isIDCardNumberAvilable:(NSString *)idCardNum {
    idCardNum = [idCardNum stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    int length =0;
    if (!idCardNum) {
        return NO;
    }else {
        length = (int)idCardNum.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [idCardNum substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            year = [idCardNum substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:idCardNum
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, idCardNum.length)];
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            year = [idCardNum substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:idCardNum
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, idCardNum.length)];
            
            if(numberofMatch >0) {
                int S = ([idCardNum substringWithRange:NSMakeRange(0,1)].intValue +
                         [idCardNum substringWithRange:NSMakeRange(10,1)].intValue) *7 +
                ([idCardNum substringWithRange:NSMakeRange(1,1)].intValue +
                 [idCardNum substringWithRange:NSMakeRange(11,1)].intValue) *9 +
                ([idCardNum substringWithRange:NSMakeRange(2,1)].intValue +
                 [idCardNum substringWithRange:NSMakeRange(12,1)].intValue) *10 +
                ([idCardNum substringWithRange:NSMakeRange(3,1)].intValue +
                 [idCardNum substringWithRange:NSMakeRange(13,1)].intValue) *5 +
                ([idCardNum substringWithRange:NSMakeRange(4,1)].intValue +
                 [idCardNum substringWithRange:NSMakeRange(14,1)].intValue) *8 +
                ([idCardNum substringWithRange:NSMakeRange(5,1)].intValue +
                 [idCardNum substringWithRange:NSMakeRange(15,1)].intValue) *4 +
                ([idCardNum substringWithRange:NSMakeRange(6,1)].intValue +
                 [idCardNum substringWithRange:NSMakeRange(16,1)].intValue) *2 +
                [idCardNum substringWithRange:NSMakeRange(7,1)].intValue *1 +
                [idCardNum substringWithRange:NSMakeRange(8,1)].intValue *6 +
                [idCardNum substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[idCardNum substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return NO;
    }
}
// 银行卡号
- (BOOL)isBankAccountAvilable:(NSString*)cardNumber{
    NSString * lastNum = [[cardNumber substringFromIndex:(cardNumber.length-1)] copy];//取出最后一位
    NSString * forwardNum = [[cardNumber substringToIndex:(cardNumber.length -1)] copy];//前15或18位
    
    NSMutableArray * forwardArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<forwardNum.length; i++) {
        NSString * subStr = [forwardNum substringWithRange:NSMakeRange(i, 1)];
        [forwardArr addObject:subStr];
    }
    
    NSMutableArray * forwardDescArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = (int)(forwardArr.count-1); i> -1; i--) {//前15位或者前18位倒序存进数组
        [forwardDescArr addObject:forwardArr[i]];
    }
    
    NSMutableArray * arrOddNum = [[NSMutableArray alloc] initWithCapacity:0];//奇数位*2的积 < 9
    NSMutableArray * arrOddNum2 = [[NSMutableArray alloc] initWithCapacity:0];//奇数位*2的积 > 9
    NSMutableArray * arrEvenNum = [[NSMutableArray alloc] initWithCapacity:0];//偶数位数组
    
    for (int i=0; i< forwardDescArr.count; i++) {
        NSInteger num = [forwardDescArr[i] intValue];
        if (i%2) {//偶数位
            [arrEvenNum addObject:[NSNumber numberWithInteger:num]];
        }else{//奇数位
            if (num * 2 < 9) {
                [arrOddNum addObject:[NSNumber numberWithInteger:num * 2]];
            }else{
                NSInteger decadeNum = (num * 2) / 10;
                NSInteger unitNum = (num * 2) % 10;
                [arrOddNum2 addObject:[NSNumber numberWithInteger:unitNum]];
                [arrOddNum2 addObject:[NSNumber numberWithInteger:decadeNum]];
            }
        }
    }
    
    __block  NSInteger sumOddNumTotal = 0;
    [arrOddNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumOddNumTotal += [obj integerValue];
    }];
    
    __block NSInteger sumOddNum2Total = 0;
    [arrOddNum2 enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumOddNum2Total += [obj integerValue];
    }];
    
    __block NSInteger sumEvenNumTotal =0 ;
    [arrEvenNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumEvenNumTotal += [obj integerValue];
    }];
    
    NSInteger lastNumber = [lastNum integerValue];
    
    NSInteger luhmTotal = lastNumber + sumEvenNumTotal + sumOddNum2Total + sumOddNumTotal;
    
    return (luhmTotal%10 ==0)?YES:NO;
}

@end
