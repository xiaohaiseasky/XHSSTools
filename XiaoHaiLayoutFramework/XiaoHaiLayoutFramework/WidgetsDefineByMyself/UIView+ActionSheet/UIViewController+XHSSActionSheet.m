//
//  UIViewController+XHSSActionSheet.m
//  TestCollectionViewLayout
//
//  Created by Apple on 2017/11/7.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import "UIViewController+XHSSActionSheet.h"
#import <objc/runtime.h>

//static NSString const *kXHSSAlertControllerKey = @"kXHSSAlertControllerKey";

@implementation UIViewController (XHSSActionSheet)
#pragma mark - setter & getter
// alertController
- (UIAlertController*)alertController {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setAlertController:(UIAlertController *)alertController {
    objc_setAssociatedObject(self, @selector(alertController), alertController, OBJC_ASSOCIATION_RETAIN);
}

// dataSourceDic
- (NSDictionary*)dataSourceDic {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setDataSourceDic:(NSDictionary *)dataSourceDic {
    objc_setAssociatedObject(self, @selector(dataSourceDic), dataSourceDic, OBJC_ASSOCIATION_RETAIN);
}

// pageName
- (NSString*)pageName {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setPageName:(NSString *)pageName {
    objc_setAssociatedObject(self, @selector(pageName), pageName, OBJC_ASSOCIATION_RETAIN);
    [self loadDataFromPlistToDictionary];
}

// isAddErrorAction
- (BOOL)isAddErrorAction {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setIsAddErrorAction:(BOOL)isAddErrorAction {
    objc_setAssociatedObject(self, @selector(isAddErrorAction), @(isAddErrorAction), OBJC_ASSOCIATION_ASSIGN);
}

// isAddCancelAction
- (BOOL)isAddCancelAction {
    id object = objc_getAssociatedObject(self, _cmd) != nil ?  objc_getAssociatedObject(self, _cmd) : @(YES);
    return [object boolValue];
    //return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setIsAddCancelAction:(BOOL)isAddCancelAction {
    objc_setAssociatedObject(self, @selector(isAddCancelAction), @(isAddCancelAction), OBJC_ASSOCIATION_ASSIGN);
}

// isAddTextFieldToAlert
- (BOOL)isAddTextFieldToAlert {
    id object = objc_getAssociatedObject(self, _cmd) != nil ?  objc_getAssociatedObject(self, _cmd) : @(YES);
    return [object boolValue];
    //return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setIsAddTextFieldToAlert:(BOOL)isAddTextFieldToAlert {
    objc_setAssociatedObject(self, @selector(isAddTextFieldToAlert), @(isAddTextFieldToAlert), OBJC_ASSOCIATION_ASSIGN);
}

//
- (XHSSActionSheetType)type {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
- (void)setType:(XHSSActionSheetType)type {
    objc_setAssociatedObject(self, @selector(type), @(type), OBJC_ASSOCIATION_ASSIGN);
}

// actionSheetCallback
- (XHSSActionSheetCallback)actionSheetCallback {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setActionSheetCallback:(XHSSActionSheetCallback)actionSheetCallback {
    objc_setAssociatedObject(self, @selector(actionSheetCallback), actionSheetCallback, OBJC_ASSOCIATION_COPY);
}


#pragma mark - DataSource
- (void)loadDataFromPlistToDictionary {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ActionSheet数据源" ofType:@".plist"];
    NSDictionary *dataSourceDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    if (dataSourceDic == nil) {
        dataSourceDic = [NSDictionary dictionary];
    }
    self.dataSourceDic = dataSourceDic;
    
    [self createUIAlertControllerWithType:self.type];
    
    [self autoShowActionSheet];
}

#pragma mark - ActionSheet
- (void)createUIAlertControllerWithType:(XHSSActionSheetType)type {
    switch (type) {
        case XHSSActionSheetTypeAlert:
            self.alertController = [UIAlertController alertControllerWithTitle:@"title" message:@"messgae" preferredStyle:UIAlertControllerStyleAlert];
            [self addActionToAlertController:self.alertController];
            break;
        case XHSSActionSheetTypeActionSheet:
            self.alertController = [UIAlertController alertControllerWithTitle:nil/*@"title"*/ message:nil/*@"messgae"*/ preferredStyle:UIAlertControllerStyleActionSheet];
            [self addActionToAlertController:self.alertController];
            [self addBaseActionToAlertControler:self.alertController];
            break;
            
        default:
            break;
    }
}

#pragma mark - add action
- (void)addActionToAlertController:(UIAlertController*)alertController {
    NSArray *titles = self.dataSourceDic[self.pageName];
    NSInteger actionTitleCount = titles.count;
    if ([[titles lastObject] isKindOfClass:[NSDictionary class]]) {
        actionTitleCount--;
        NSDictionary *alertConfigDic = [titles lastObject];
        if (self.alertController.preferredStyle == UIAlertControllerStyleAlert) {
            self.alertController.title = alertConfigDic[@"title"];
            self.alertController.message = alertConfigDic[@"message"];
            if (self.isAddTextFieldToAlert) {
                [self addTextFieldToAlertController:self.alertController placeHolder:alertConfigDic[@"placeHolder"] okBtnName:alertConfigDic[@"okBtnTitle"]];
            }
        }
    }
    for (NSInteger i=0; i<actionTitleCount; i++) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:titles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"title = %@ , index = %ld", titles[i], i);
            
            if (self.actionSheetCallback) {
                self.actionSheetCallback(titles[i], i);
            }
        }];
        [alertController addAction:action];
    }
}

- (void)addBaseActionToAlertControler:(UIAlertController*)alertController {
    // 添加 AlertAction 事件回调（三种类型：默认，取消，警告）
    // cancel类自动变成最后一个，警告类推荐放上面
    if (self.isAddErrorAction) {
        UIAlertAction *errorAction = [UIAlertAction actionWithTitle:@"error" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"error");
        }];
        [alertController addAction:errorAction];
    }
    if (self.isAddCancelAction) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"cancel");
        }];
        //        if ([cancelAction valueForKey:@"titleTextColor"]) {
        [cancelAction setValue:[UIColor redColor] forKey:@"titleTextColor"];
        //        }
        [alertController addAction:cancelAction];
    }
}

#pragma mark - add input to alert view
- (void)addTextFieldToAlertController:(UIAlertController*)alertController placeHolder:(NSString*)placeHolder okBtnName:(NSString*)okBtnName {
    if (alertController.preferredStyle == UIAlertControllerStyleAlert) {
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = placeHolder;
        }];
        
        UIAlertAction *okInputAction = [UIAlertAction actionWithTitle:okBtnName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 获取上面的输入框
            UITextField *tempField = [alertController.textFields firstObject];
            NSLog(@"%@",tempField.text);
            
            if (self.actionSheetCallback) {
                self.actionSheetCallback(tempField.text, -1);
            }
        }];
        [okInputAction setValue:[UIColor redColor] forKey:@"titleTextColor"];
        [alertController addAction:okInputAction];
    }
}

#pragma mark - show & hidden
- (void)autoShowActionSheet {
    [self presentViewController:self.alertController animated:YES completion:^{
        NSLog(@"auto presented");
    }];
}

- (void)showActionSheetInController:(UIViewController*)controller {
    [controller presentViewController:self.alertController animated:YES completion:^{
        NSLog(@"presented");
    }];
}

- (void)showActionSheet {
    [self showActionSheetInController:self];
}

- (void)hiddenActionSheet {
    [self.alertController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"dismiss");
    }];
}

#pragma mark - public 
- (void)showAlertControllerWithType:(XHSSActionSheetType)type pageName:(NSString*)pageName callBack:(void(^)(NSString *title, NSInteger index))callBack {
    self.actionSheetCallback = callBack;
    self.type = type;
    self.pageName = pageName;
}

@end
