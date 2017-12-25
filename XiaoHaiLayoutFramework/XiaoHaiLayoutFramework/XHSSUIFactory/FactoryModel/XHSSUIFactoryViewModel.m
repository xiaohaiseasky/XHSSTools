//
//  XHSSUIFactoryViewModel.m
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/12/21.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//



#import "XHSSUIFactoryViewModel.h"


@interface XHSSUIFactoryViewModel ()

@property (nonatomic, strong, readwrite) NSMutableDictionary *subComponentsInfoDic;
@property (nonatomic, strong, readwrite) NSMutableArray<NSString*> *subComponentNameArr;

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

@end
