//
//  XHSSUIFactoryViewModel.h
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/12/21.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHSSManagerBridge.h"


UIKIT_EXTERN NSString * _Nonnull const XHSSBindViewModelKey;
UIKIT_EXTERN NSString * _Nullable const XHSSBindLayoutBridgeBlockKey;


@interface XHSSUIFactoryViewModel : NSObject

// type
// name
// super
// config
// refView
// layout
// action
// animation
@property (nonatomic, strong, readonly) NSMutableDictionary * _Nonnull subComponentsInfoDic;
@property (nonatomic, strong, readonly) NSMutableArray<NSString*> * _Nonnull subComponentNameArr;

- (void)bindToView:(UIView*_Nonnull)view;

- (void)addSubComponent:(id _Nonnull )subCommponent forName:(NSString*_Nonnull)componentName;
- (void)removeSubComponent:(NSString *_Nonnull)componentName;

- (UIView*_Nonnull)rootView;

- (id _Nonnull )subComponentForKey:(NSString*_Nonnull)key;
- (id _Nonnull )subComponentForKeyPath:(NSString*_Nonnull)keyPath;

- (id _Nonnull (^_Nonnull)(NSString * _Nonnull key))subComponentForKey;
- (id _Nonnull (^_Nonnull)(NSString * _Nonnull keyPath))subComponentForKeyPath;

@end
