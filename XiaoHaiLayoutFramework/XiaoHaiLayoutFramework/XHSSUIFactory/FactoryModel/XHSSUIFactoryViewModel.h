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

@protocol UIProtocol <NSObject>
@optional
@property (nonatomic, strong) NSString *valuevaluevaluevaluevaluevaluevaluevaluevalue;
- (void)uiuiuiuiuuiuiuiuiuiuiuiuiuiuiuiuiuiuiuiuiuiuiuiui;
@end






typedef void(^XHSSConfigBridgeBlock)(XHSSConfigManagerBridge *configManager);
typedef void(^XHSSLayoutBridgeBlock)(XHSSLayoutManagerBridge *LayoutManager);

@interface XHSSUIFactoryViewModel : NSObject <UIProtocol>

@property (nonatomic, strong) NSString *componentType;
@property (nonatomic, strong) NSString *componentName;
@property (nonatomic, strong) XHSSConfigBridgeBlock componentConfig;
@property (nonatomic, strong) NSString *componentLayoutRefView;
@property (nonatomic, strong) XHSSLayoutBridgeBlock componentLayout;
@property (nonatomic, strong) NSString *componentAction;
@property (nonatomic, strong) XHSSUIFactoryViewModel *subComponent;
@property (nonatomic, strong) id componentData;

@end
