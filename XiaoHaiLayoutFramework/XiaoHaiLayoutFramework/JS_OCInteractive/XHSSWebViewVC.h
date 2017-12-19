//
//  XHSSWebViewVC.h
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/10/20.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@class XHSSWKDelegateHandler;

// 解决正常写法存在内存泄漏的问题 ： 中间对象
@protocol XHSSWKScriptMessageHandlerBridgeDelegate <NSObject>

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;

@end

typedef void(^XHSSReceiveJSMessageCallBack)(WKWebView *webView, WKScriptMessage *message);
typedef void(^XHSSExecuteJSCodeCallBack)(WKWebView *webView, BOOL isSuccess, id result, NSError *erro);




@interface XHSSWebViewVC : UIViewController

@property (nonatomic, copy) NSString *url;
//
@property (nonatomic, copy) NSString *nameOfFunctionRegisteredToJS;
@property (nonatomic, copy) XHSSReceiveJSMessageCallBack receiveJSMessageCallBack;
//
@property (nonatomic, copy) NSString *jsCodeToExecute;
@property (nonatomic, copy) XHSSExecuteJSCodeCallBack executeJSCodeCallBack;

- (void)registerFunction:(NSString*)functionNmae toJSWithCallBack:(XHSSReceiveJSMessageCallBack)receiveJSMessageCallBack;
- (void)executeJSCode:(NSString*)jsCode withCallBack:(XHSSExecuteJSCodeCallBack)executeJSCodeCallBack;

@end




/**
 处理 WKVebView 代理事件的类
 */
@interface XHSSWKDelegateHandler : NSObject <WKUIDelegate, WKNavigationDelegate, XHSSWKScriptMessageHandlerBridgeDelegate>

//
@property (nonatomic, copy) NSString *nameOfFunctionRegisteredToJS;
@property (nonatomic, copy) XHSSReceiveJSMessageCallBack receiveJSMessageCallBack;
//
@property (nonatomic, copy) NSString *jsCodeToExecute;
@property (nonatomic, copy) XHSSExecuteJSCodeCallBack executeJSCodeCallBack;

- (void)registerFunction:(NSString*)functionNmae toJSWithCallBack:(XHSSReceiveJSMessageCallBack)receiveJSMessageCallBack;
- (void)executeJSCode:(NSString*)jsCode withCallBack:(XHSSExecuteJSCodeCallBack)executeJSCodeCallBack;

@end
