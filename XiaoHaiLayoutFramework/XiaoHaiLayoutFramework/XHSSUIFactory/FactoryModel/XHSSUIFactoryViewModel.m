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


NSString * const XHSSBindSuperViewKey = @"XHSSBindSuperViewKey";
NSString * const XHSSBindViewModelKey = @"XHSSBindViewModelKey";
NSString * const XHSSBindLayoutBridgeBlockKey = @"XHSSBindLayoutBridgeBlockKey";
NSString * const XHSSBindConfigBridgeBlockKey = @"XHSSBindConfigBridgeBlockKey";

@interface XHSSUIFactoryViewModel ()

@property (nonatomic, strong, readwrite) NSMutableDictionary *subComponentsInfoDic;
@property (nonatomic, strong, readwrite) NSMutableArray<NSString*> *subComponentNameArr;
//@property (nonatomic, strong) UIView *targetView;

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



#pragma mark - *** OC Style ***
/// *** OC Style ***
- (void)bindToView:(UIView*)view {
    self.targetView = view;
    //[self.subComponentNameArr addObject:@"root"];
//    [self.subComponentsInfoDic setObject:self.targetView forKey:@"root"];
    
    objc_setAssociatedObject(view, (__bridge const void * _Nonnull)(XHSSBindViewModelKey), [self mutableCopy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    XHSSUIFactoryViewModel *model = objc_getAssociatedObject(view, (__bridge const void * _Nonnull)(XHSSBindViewModelKey));
    [model.subComponentNameArr enumerateObjectsUsingBlock:^(NSString * _Nonnull viewName, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIView * subView = model.subComponentsInfoDic[viewName];
        UIView * superView = objc_getAssociatedObject(subView, (__bridge const void * _Nonnull)(XHSSBindSuperViewKey));
        if (superView == nil) {
            objc_setAssociatedObject(subView, (__bridge const void * _Nonnull)(XHSSBindSuperViewKey), self.targetView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        subView.needAddToSuperView();
        subView.needRefreshConfig();
        subView.needRefreshLayout();
        
        
//        if (!([viewName containsString:@"/"] || [viewName containsString:@"."])) {
//            [model.targetView addSubview:model.subComponentsInfoDic[viewName]];
//            UIView * subView = model.subComponentsInfoDic[viewName];
//            subView.needAddToSuperView();
//            subView.needRefreshConfig();
//            subView.needRefreshLayout();
//        } else {
//            [model loopAddToSuperViewWithKeyPath:viewName];
//        }
    }];
}

- (void)loopAddToSuperViewWithKeyPath:(NSString*)keyPath {
    NSString *currentKeyPath = keyPath;
    NSArray<NSString*> *subViewNames = [keyPath componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/."]];
    NSMutableArray<NSString*> *tempViewNameArr = [NSMutableArray arrayWithArray:subViewNames];
    
    while (tempViewNameArr.count > 1) {
        NSString * subViewName = currentKeyPath;
        NSString * superViewName = [currentKeyPath substringToIndex:tempViewNameArr.lastObject.length +1];
        UIView * subView = self.subComponentsInfoDic[subViewName];
        UIView * superView = self.subComponentsInfoDic[superViewName];
        
        objc_setAssociatedObject(subView, (__bridge const void * _Nonnull)(XHSSBindSuperViewKey), superView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//        [superView addSubview:subView];
        subView.needAddToSuperView();
        subView.needRefreshConfig();
        subView.needRefreshLayout();
        
        currentKeyPath = superViewName;
        [tempViewNameArr removeLastObject];
    }
}

/////////////////////////////
- (void)addSubComponent:(id)subCommponent forName:(NSString*)componentName {
    /// *** check if the componentName is already exist ***
    if ([self.subComponentNameArr containsObject:componentName]) {
        return;
    }
    
    [self.subComponentsInfoDic setValue:subCommponent forKey:componentName];
    [self.subComponentNameArr addObject:componentName];
}
- (void)addSubComponent:(id _Nonnull )subCommponent forNamePath:(NSString*_Nonnull)componentNamePath {
    /// *** check if the componentName is already exist ***
    if ([self.subComponentNameArr containsObject:componentNamePath]) {
        return;
    }
    
    [self.subComponentsInfoDic setValue:subCommponent forKey:componentNamePath];
    [self.subComponentNameArr addObject:componentNamePath];
}

- (void)removeSubComponentByName:(NSString *)componentName {
    [self.subComponentsInfoDic removeObjectForKey:componentName];
    [self.subComponentNameArr removeObject:componentName];
}
- (void)removeSubComponentByNamePath:(NSString *_Nonnull)componentNamePath {
    [self.subComponentsInfoDic removeObjectForKey:componentNamePath];
    [self.subComponentNameArr removeObject:componentNamePath];
}


- (UIView*)rootView {
//    return self.targetView;
    return self.targetView /*self.subComponentsInfoDic[@"root"] == nil*/ ? self.targetView : self.subComponentsInfoDic[@"root"];
}

- (id)subComponentForKey:(NSString*)key {
    return self.subComponentsInfoDic[key];
}
- (id)subComponentForKeyPath:(NSString*)keyPath {
    return self.subComponentsInfoDic[keyPath];
}



#pragma mark - *** Chain Call Style ***
/// *** Chain Call Style ***
- (XHSSUIFactoryViewModel*_Nonnull(^_Nonnull)(UIView * _Nonnull view))bindToView {
    __weak typeof(self) weakSelf = self;
    return ^(UIView * _Nonnull view) {
        weakSelf.targetView = view;
        
        //[weakSelf.subComponentNameArr addObject:@"root"];
//        [weakSelf.subComponentsInfoDic setObject:weakSelf.targetView forKey:@"root"];
        
        objc_setAssociatedObject(view, (__bridge const void * _Nonnull)(XHSSBindViewModelKey), 1 ? weakSelf : [weakSelf mutableCopy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        XHSSUIFactoryViewModel *model = objc_getAssociatedObject(view, (__bridge const void * _Nonnull)(XHSSBindViewModelKey));
        [model.subComponentNameArr enumerateObjectsUsingBlock:^(NSString * _Nonnull viewName, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIView * subView = model.subComponentsInfoDic[viewName];
            UIView * superView = objc_getAssociatedObject(subView, (__bridge const void * _Nonnull)(XHSSBindSuperViewKey));
            if (superView == nil) {
                objc_setAssociatedObject(subView, (__bridge const void * _Nonnull)(XHSSBindSuperViewKey), weakSelf.targetView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            subView.needAddToSuperView();
            subView.needRefreshConfig();
            subView.needRefreshLayout();
            
//            if (!([viewName containsString:@"/"] || [viewName containsString:@"."])) {
//                [model.targetView addSubview:model.subComponentsInfoDic[viewName]];
//                UIView * subView = model.subComponentsInfoDic[viewName];
//                subView.needAddToSuperView();
//                subView.needRefreshConfig();
//                subView.needRefreshLayout();
//            } else {
//                [model loopAddToSuperViewWithKeyPath:viewName];
//            }
        }];
        
        
        
//        [weakSelf.subComponentNameArr enumerateObjectsUsingBlock:^(NSString * _Nonnull viewName, NSUInteger idx, BOOL * _Nonnull stop) {
//            UIView * subView = (UIView*)weakSelf.subComponentsInfoDic[viewName];
//            [weakSelf.targetView addSubview:weakSelf.subComponentsInfoDic[viewName]];
//            subView.needRefreshLayout();
//        }];
//        objc_setAssociatedObject(view, (__bridge const void * _Nonnull)(XHSSBindViewModelKey), [self mutableCopy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
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
-(XHSSUIFactoryViewModel*_Nonnull(^_Nonnull)(id _Nonnull subCommponent, NSString * _Nonnull componentNamePath))addSubComponentForNamePath {
    __weak typeof(self) weakSelf = self;
    return ^(id _Nonnull subCommponent, NSString * _Nonnull componentNamePath) {
        /// *** check if the componentName is already exist ***
        if (![weakSelf.subComponentNameArr containsObject:componentNamePath]) {
            [weakSelf.subComponentsInfoDic setValue:subCommponent forKey:componentNamePath];
            [weakSelf.subComponentNameArr addObject:componentNamePath];
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
-(XHSSUIFactoryViewModel*_Nonnull(^_Nonnull)(NSString * _Nonnull componentNamePath))removeSubComponentByNamePath {
    __weak typeof(self) weakSelf = self;
    return ^(NSString * _Nonnull componentNamePath) {
        [weakSelf.subComponentsInfoDic removeObjectForKey:componentNamePath];
        [weakSelf.subComponentNameArr removeObject:componentNamePath];
        return self;
    };
}


- (id(^)(NSString *key))subComponentForKey {
    return ^(NSString *key) {
        return self.subComponentsInfoDic[key];
    };
}
- (id(^)(NSString *keyPath))subComponentForKeyPath {
    __weak typeof(self) weakSelf = self;
    return ^(NSString *keyPath) {
        return weakSelf.subComponentsInfoDic[keyPath];
    };
}

#pragma mark - NSCopying , NSMutableCopying
- (id)copyWithZone:(NSZone *)zone{
    return [self mutableCopyWithZone:zone];
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    XHSSUIFactoryViewModel * model = [[XHSSUIFactoryViewModel allocWithZone:zone] init];
    model.subComponentNameArr = [self mutableDeepCopyArr:self.subComponentNameArr];
    model.subComponentsInfoDic = [self mutableDeepCopyDic:self.subComponentsInfoDic];
    model.targetView = self.targetView;
    return model;
}

-(NSMutableArray *)mutableDeepCopyArr:(NSMutableArray*)arr {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[arr count]];
    for(id value in arr) {
        id copyValue = [value copy];
        [array addObject:copyValue];
    }
    return array;
}

-(NSMutableDictionary *)mutableDeepCopyDic:(NSDictionary*)dic {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:[dic count]];
    for(id key in [dic allKeys]) {
        id shouldBeView = [dic objectForKey:key];
        
        if ([shouldBeView isKindOfClass:[UIView class]]) {
            UIView *newView = [self copyView:shouldBeView];
            [dict setObject:newView forKey:key];
        } else {
            [dict setObject:shouldBeView forKey:key];
        }
    }
    return dict;
}

- (UIView*)copyView:(UIView*)targetView {
    if (targetView == self.targetView) {
        return targetView;
    }
    
    UIView *newView = [[[targetView class] alloc] init];
    newView.frame = targetView.frame;
    
    XHSSConfigBridgeBlock configBlock = objc_getAssociatedObject(targetView, (__bridge const void * _Nonnull)(XHSSBindConfigBridgeBlockKey));
    objc_setAssociatedObject(newView, (__bridge const void * _Nonnull)(XHSSBindConfigBridgeBlockKey), [configBlock copy], OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    XHSSLayoutBridgeBlock layoutBlock = objc_getAssociatedObject(targetView, (__bridge const void * _Nonnull)(XHSSBindLayoutBridgeBlockKey));
    objc_setAssociatedObject(newView, (__bridge const void * _Nonnull)(XHSSBindLayoutBridgeBlockKey), [layoutBlock copy], OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    UIView *superView = objc_getAssociatedObject(targetView, (__bridge const void * _Nonnull)(XHSSBindSuperViewKey));
    if (superView && !(superView == self.targetView)) {
        UIView *resultView = [self copyView:superView];
        objc_setAssociatedObject(newView, (__bridge const void * _Nonnull)(XHSSBindSuperViewKey), resultView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    /// *** is need or not ***
    XHSSUIFactoryViewModel *model = objc_getAssociatedObject(targetView, (__bridge const void * _Nonnull)(XHSSBindViewModelKey));
    objc_setAssociatedObject(newView, (__bridge const void * _Nonnull)(XHSSBindViewModelKey), [model mutableCopy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return newView;
}

@end
