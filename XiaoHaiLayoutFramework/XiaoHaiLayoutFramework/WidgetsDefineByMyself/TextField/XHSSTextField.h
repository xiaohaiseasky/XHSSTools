//
//  XHSSTextField.h
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/12/1.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//
//
// 添加键盘监听事件，处理视图移动的回调
//
// 内部验证，外部提供验证的方法，对内容进行验证
//
// 开始输入，输入内容变化，输入结束 事件监听
//
// 输入内容长度控制
//
// 显示内容、样式、功能控制
//
// *** 提供的验证方法类型必须是：接收一个 NSString 参数，返回一个 BOOL 值 ***
//
// *** 使用者提供验证方式目前形式是：提供验证方法 及 验证方法拥有者 ； 应该只让使用者提供 验证规则 而不是 验证方法 ***
//
// &&& 第一响应者未处理



#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XHSSTextFieldInputLengthAvilableType) {
    XHSSTextFieldInputLengthAvilableTypeAvilable,
    XHSSTextFieldInputLengthAvilableTypeTooLong,
    XHSSTextFieldInputLengthAvilableTypeTooShort,
};
typedef NS_ENUM(NSUInteger, XHSSTextFieldInputStatusType) {
    XHSSTextFieldInputStatusTypeBeginEditing,
    XHSSTextFieldInputStatusTypeEditing,
    XHSSTextFieldInputStatusTypeEndEditing,
};
typedef NS_ENUM(NSUInteger, XHSSTextFieldViladateType) {
    XHSSTextFieldViladateTypeNone,
    XHSSTextFieldViladateTypePhoneNumberNormal,
    XHSSTextFieldViladateTypePhoneNumberStrict,
    XHSSTextFieldViladateTypeEmail,
    XHSSTextFieldViladateTypeIDCard,
    XHSSTextFieldViladateTypeBankAccount,
};



@interface XHSSTextField : UITextField

// the view will be move up if keyboard show
@property (nonatomic, strong) UIView *targetViewByKeyboard;
// iphone's status bar height
@property (nonatomic, assign) CGFloat statusBarHeight;

// the object provide the viladite founction
@property (nonatomic, strong) id viladitor;
// the viladite founction
@property (nonatomic, assign) SEL viladitefounction;
// viladition call back
@property (nonatomic, copy) void(^viladitionCallBack)(BOOL isAvilable);

// shouldClear
@property (nonatomic, assign) BOOL shouldClear;
// shouldReturn
@property (nonatomic, assign) BOOL shouldReturn;
// text length control
@property (nonatomic, assign) NSInteger minInputLength;
@property (nonatomic, assign) NSInteger maxInputLength;

// if need show message
@property (nonatomic, assign) BOOL shouldShowMessageWhenInputValidateFaild;
@property (nonatomic, assign) BOOL shouldShowMessageWhenInputLengthInvalidate;
// message need show
@property (nonatomic, copy) NSString *tipMessageWhenInputValidateFaild;
@property (nonatomic, copy) NSString *tipMessageWhenInputLengthInvalidate;
// tipView need show
//@property (nonatomic, strong) UIView *tipView;
// call back when time is need show some message
@property (nonatomic, copy) void(^needShowMessageCallBack)(NSString *message);

// viladate type
@property (nonatomic, assign) XHSSTextFieldViladateType viladateType;

// text length avilable state change call back
@property (nonatomic, copy) void(^inputLenghtAvilableStatusChangeCallBack)(BOOL isAvilable, XHSSTextFieldInputLengthAvilableType avilableType);
// input status change call back
@property (nonatomic, copy) void(^inputStatusChangeCallBack)(XHSSTextFieldInputStatusType inputState);
// colick return call back
@property (nonatomic, copy) void(^returnColickCallBack)();

@end
