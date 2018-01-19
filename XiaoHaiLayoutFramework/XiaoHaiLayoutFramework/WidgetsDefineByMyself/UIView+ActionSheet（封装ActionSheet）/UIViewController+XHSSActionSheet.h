//
//  UIViewController+XHSSActionSheet.h
//  TestCollectionViewLayout
//
//  Created by Apple on 2017/11/7.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XHSSActionSheetType) {
    XHSSActionSheetTypeAlert,
    XHSSActionSheetTypeActionSheet,
};

typedef void(^XHSSActionSheetCallback)(NSString *title, NSInteger index);

@interface UIViewController (XHSSActionSheet)

@property (nonatomic, strong) UIAlertController *alertController;
@property (nonatomic, strong) NSDictionary *dataSourceDic;
@property (nonatomic, strong) NSString *pageName;
@property (nonatomic, assign) BOOL isAddErrorAction;
@property (nonatomic, assign) BOOL isAddCancelAction;
@property (nonatomic, assign) BOOL isAddTextFieldToAlert;
@property (nonatomic, assign) XHSSActionSheetType type;
@property (nonatomic, copy) XHSSActionSheetCallback actionSheetCallback;

- (void)showAlertControllerWithType:(XHSSActionSheetType)type pageName:(NSString*)pageName callBack:(void(^)(NSString *title, NSInteger index))callBack;

@end
