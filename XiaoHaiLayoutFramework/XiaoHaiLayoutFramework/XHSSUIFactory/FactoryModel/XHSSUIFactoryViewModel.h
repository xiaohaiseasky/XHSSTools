//
//  XHSSUIFactoryViewModel.h
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/12/21.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "XHSSUIFactory.h"
#import "XHSSManagerBridge.h"


@interface XHSSUIFactoryViewModel : NSObject

@property (nonatomic, strong) NSString *componentType;
@property (nonatomic, strong) NSString *componentName;
@property (nonatomic, strong) XHSSConfigBridgeBlock componentConfig;
@property (nonatomic, strong) NSString *componentLayoutRefView;
@property (nonatomic, strong) XHSSLayoutBridgeBlock componentLayout;
@property (nonatomic, strong) NSString *componentAction;
@property (nonatomic, strong) XHSSUIFactoryViewModel *subComponent;
@property (nonatomic, strong) NSString *componentDataKeyPath;
@property (nonatomic, strong) id dataModel;



// type
// name
// super
// config
// refView
// layout
// action
@property (nonatomic, strong, readonly) NSMutableDictionary *subComponentsInfoDic;
@property (nonatomic, strong, readonly) NSMutableArray<NSString*> *subComponentNameArr;

- (void)addSubComponent:(id)subCommponent forName:(NSString*)componentName;
- (void)removeSubComponent:(NSString *)componentName;

@end
