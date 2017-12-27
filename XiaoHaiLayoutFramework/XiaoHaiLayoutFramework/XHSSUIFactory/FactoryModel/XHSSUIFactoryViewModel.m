//
//  XHSSUIFactoryViewModel.m
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/12/21.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//



#import "XHSSUIFactoryViewModel.h"
#import <objc/runtime.h>
#import "UIView+XHSSUIFactoryBaseView.h"


NSString * const XHSSBindViewModelKey = @"XHSSBindViewModelKey";
NSString * const XHSSBindLayoutBridgeBlockKey = @"XHSSBindLayoutBridgeBlockKey";

@interface XHSSUIFactoryViewModel ()

@property (nonatomic, strong, readwrite) NSMutableDictionary *subComponentsInfoDic;
@property (nonatomic, strong, readwrite) NSMutableArray<NSString*> *subComponentNameArr;
@property (nonatomic, strong) UIView *targetView;

@end

@implementation XHSSUIFactoryViewModel

- (NSMutableDictionary*)subComponentsInfoDic {
    if (_subComponentsInfoDic == nil) {
        _subComponentsInfoDic = [NSMutableDictionary dictionary];
    }
    return _subComponentsInfoDic;
}

- (NSMutableArray*)subComponentNameArr {
    if (_subComponentNameArr == nil) {
        _subComponentNameArr = [NSMutableArray array];
    }
    return _subComponentNameArr;
}



/// *** OC Style ***
- (void)bindToView:(UIView*)view {
    self.targetView = view;
    
    __weak typeof(self) weakSelf = self;
    [self.subComponentNameArr enumerateObjectsUsingBlock:^(NSString * _Nonnull viewName, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView * subView = (UIView*)weakSelf.subComponentsInfoDic[viewName];
        [weakSelf.targetView addSubview:weakSelf.subComponentsInfoDic[viewName]];
        subView.needRefreshLayout();
    }];
    
    objc_setAssociatedObject(view, (__bridge const void * _Nonnull)(XHSSBindViewModelKey), self/*[self copy]*/, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)addSubComponent:(id)subCommponent forName:(NSString*)componentName {
    /// *** check if the componentName is already exist ***
    if ([self.subComponentNameArr containsObject:componentName]) {
        return;
    }
    
    [self.subComponentsInfoDic setValue:subCommponent forKey:componentName];
    [self.subComponentNameArr addObject:componentName];
}

- (void)removeSubComponentByName:(NSString *)componentName {
    [self.subComponentsInfoDic removeObjectForKey:componentName];
    [self.subComponentNameArr removeObject:componentName];
}


- (UIView*)rootView {
    return self.targetView;
}

- (id)subComponentForKey:(NSString*)key {
    return self.subComponentsInfoDic[key];
}
- (id)subComponentForKeyPath:(NSString*)keyPath {
#warning - not implementation 
    return nil;
}


/// *** Chain Call Style ***
- (XHSSUIFactoryViewModel*_Nonnull(^_Nonnull)(UIView * _Nonnull view))bindToView {
    __weak typeof(self) weakSelf = self;
    return ^(UIView * _Nonnull view) {
        weakSelf.targetView = view;
        
        [weakSelf.subComponentNameArr enumerateObjectsUsingBlock:^(NSString * _Nonnull viewName, NSUInteger idx, BOOL * _Nonnull stop) {
            UIView * subView = (UIView*)weakSelf.subComponentsInfoDic[viewName];
            [weakSelf.targetView addSubview:weakSelf.subComponentsInfoDic[viewName]];
            subView.needRefreshLayout();
        }];
        
        objc_setAssociatedObject(view, (__bridge const void * _Nonnull)(XHSSBindViewModelKey), self/*[self copy]*/, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return self;
    };
}

-(XHSSUIFactoryViewModel*_Nonnull(^_Nonnull)(id _Nonnull subCommponent, NSString * _Nonnull componentName))addSubComponentForName {
    __weak typeof(self) weakSelf = self;
    return ^(id _Nonnull subCommponent, NSString * _Nonnull componentName) {
        /// *** check if the componentName is already exist ***
        if (![weakSelf.subComponentNameArr containsObject:componentName]) {
            [weakSelf.subComponentsInfoDic setValue:subCommponent forKey:componentName];
            [weakSelf.subComponentNameArr addObject:componentName];
        }
        
        return self;
    };
}

-(XHSSUIFactoryViewModel*_Nonnull(^_Nonnull)(NSString * _Nonnull componentName))removeSubComponentByName {
    __weak typeof(self) weakSelf = self;
    return ^(NSString * _Nonnull componentName) {
        [weakSelf.subComponentsInfoDic removeObjectForKey:componentName];
        [weakSelf.subComponentNameArr removeObject:componentName];
        return self;
    };
}


- (id(^)(NSString *key))subComponentForKey {
    return ^(NSString *key) {
        return self.subComponentsInfoDic[key];
    };
}
- (id(^)(NSString *keyPath))subComponentForKeyPath {
    return ^(NSString *keyPath) {
        return [[UIView alloc] init];
    };
}

@end
