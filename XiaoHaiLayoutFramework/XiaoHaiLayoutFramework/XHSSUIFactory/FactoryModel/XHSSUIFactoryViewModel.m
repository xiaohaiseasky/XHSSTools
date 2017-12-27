//
//  XHSSUIFactoryViewModel.m
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/12/21.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//



#import "XHSSUIFactoryViewModel.h"
#import <objc/runtime.h>


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



- (void)bindToView:(UIView*)view {
    self.targetView = view;
    
    __weak typeof(self) weakSelf = self;
    [self.subComponentNameArr enumerateObjectsUsingBlock:^(NSString * _Nonnull viewName, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf.targetView addSubview:weakSelf.subComponentsInfoDic[viewName]];
        XHSSLayoutBridgeBlock layoutBlock = objc_getAssociatedObject(weakSelf.subComponentsInfoDic[viewName], (__bridge const void * _Nonnull)(XHSSBindLayoutBridgeBlockKey));
        if (layoutBlock) {
            XHSSLayoutManagerBridge *layoutManager = /*[XHSSLayoutManagerBridge sharedLayoutManagerBridge];
                                                      */ [[XHSSLayoutManagerBridge alloc] init];
            layoutManager.targetView = view;
            layoutBlock(layoutManager);
        }
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

- (void)removeSubComponent:(NSString *)componentName {
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
