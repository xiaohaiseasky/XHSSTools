//
//  XHSSUIFactoryViewModel.h
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/12/21.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHSSManagerBridge.h"


UIKIT_EXTERN NSString * _Nonnull const XHSSBindSuperViewKey;
UIKIT_EXTERN NSString * _Nonnull const XHSSBindViewModelKey;
UIKIT_EXTERN NSString * _Nullable const XHSSBindLayoutBridgeBlockKey;
UIKIT_EXTERN NSString * _Nullable const XHSSBindConfigBridgeBlockKey;


@interface XHSSUIFactoryViewModel : NSObject <NSCopying,NSMutableCopying>

// type
// name
// super
// config
// refView
// layout
// action
// animation

@property (nonatomic, strong) UIView * _Nonnull targetView;
@property (nonatomic, strong, readonly) NSMutableDictionary * _Nonnull subComponentsInfoDic;
@property (nonatomic, strong, readonly) NSMutableArray<NSString*> * _Nonnull subComponentNameArr;

/// *** OC Style ***
- (void)bindToView:(UIView*_Nonnull)view;

- (void)addSubComponent:(id _Nonnull )subCommponent forName:(NSString*_Nonnull)componentName;
- (void)addSubComponent:(id _Nonnull )subCommponent forNamePath:(NSString*_Nonnull)componentNamePath;

- (void)removeSubComponentByName:(NSString *_Nonnull)componentName;
- (void)removeSubComponentByNamePath:(NSString *_Nonnull)componentNamePath;

- (UIView*_Nonnull)rootView;

- (id _Nonnull )subComponentForKey:(NSString*_Nonnull)key;
- (id _Nonnull )subComponentForKeyPath:(NSString*_Nonnull)keyPath;

/// *** Chain Call Style ***
- (XHSSUIFactoryViewModel*_Nonnull(^_Nonnull)(UIView * _Nonnull view))bindToView;

-(XHSSUIFactoryViewModel*_Nonnull(^_Nonnull)(id _Nonnull subCommponent, NSString * _Nonnull componentName))addSubComponentForName;
-(XHSSUIFactoryViewModel*_Nonnull(^_Nonnull)(id _Nonnull subCommponent, NSString * _Nonnull componentNamePath))addSubComponentForNamePath;

-(XHSSUIFactoryViewModel*_Nonnull(^_Nonnull)(NSString * _Nonnull componentName))removeSubComponentByName;
-(XHSSUIFactoryViewModel*_Nonnull(^_Nonnull)(NSString * _Nonnull componentNamePath))removeSubComponentByNamePath;

- (id _Nonnull (^_Nonnull)(NSString * _Nonnull key))subComponentForKey;
- (id _Nonnull (^_Nonnull)(NSString * _Nonnull keyPath))subComponentForKeyPath;

//////////////////////////////////

- (void)needRefreshConfig;
- (void)needRefreshConfigOfViewByKey:(NSString*_Nonnull)key;
- (void)needRefreshConfigOfViewByKeyPath:(NSString*_Nonnull)keyPath;

- (void)needRefreshLayout;
- (void)needRefreshLayoutOfViewByKey:(NSString*_Nonnull)key;
- (void)needRefreshLayoutOfViewByKeyPath:(NSString*_Nonnull)keyPath;

- (void)registerDadaForKey:(NSString*_Nonnull)key;
- (void)registerDadaForKeyPath:(NSString*_Nonnull)keyPath;

- (void)registerActionForKey:(NSString*_Nonnull)key;
- (void)registerActionForKeyPath:(NSString*_Nonnull)keyPath;

@end
