//
//  XHSSWebViewVC.m
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/10/20.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import "XHSSWebViewVC.h"

@interface XHSSWKScriptMessageHandlerBridge : UIViewController <WKScriptMessageHandler>

@property (nonatomic, weak) id<XHSSWKScriptMessageHandlerBridgeDelegate> scriptMessageHandlerDelegate;

@end

@implementation XHSSWKScriptMessageHandlerBridge

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSLog(@"name:%@\\\\n body:%@\\\\n frameInfo:%@\\\\n", message.name, message.body, message.frameInfo);
    
    if ([self.scriptMessageHandlerDelegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)]) {
        [self.scriptMessageHandlerDelegate userContentController:userContentController didReceiveScriptMessage:message];
    }
}

@end



/////////////////////////////////////////////////////////////////////////



@interface XHSSWebViewVC ()

@property (nonatomic, strong) WKWebView *webView;
//@property (nonatomic, strong) XHSSWKDelegateHandler *wkDelegateHandler;
//@property (nonatomic, strong) WKWebViewConfiguration *webViewConfig;
//@property (nonatomic, strong) XHSSWKScriptMessageHandlerBridge *scriptMessageHandlerBridge;
//@property (nonatomic, strong) WKUserContentController *userContentController;
//@property (nonatomic, strong) WKPreferences *webPrefrence;

@end

@implementation XHSSWebViewVC

#pragma mark - setter & getter
//- (XHSSWKDelegateHandler*)wkDelegateHandler {
//    if (_wkDelegateHandler == nil) {
//        _wkDelegateHandler = [[XHSSWKDelegateHandler alloc] init];
//    }
//    return _wkDelegateHandler;
//}
//
//- (WKWebViewConfiguration *)webViewConfig {
//    if (_webViewConfig == nil) {
//        _webViewConfig = [[WKWebViewConfiguration alloc] init];
//    }
//    return _webViewConfig;
//}
//
//- (XHSSWKScriptMessageHandlerBridge*)scriptMessageHandlerBridge {
//    if (_scriptMessageHandlerBridge == nil) {
//        _scriptMessageHandlerBridge = [[XHSSWKScriptMessageHandlerBridge alloc] init];
//    }
//    return _scriptMessageHandlerBridge;
//}
//
//- (WKUserContentController*)userContentController {
//    if (_userContentController == nil) {
//        _userContentController = [[WKUserContentController alloc] init];
//    }
//    return _userContentController;
//}
//
//- (WKPreferences *)webPrefrence {
//    if (_webPrefrence == nil) {
//        _webPrefrence = [[WKPreferences alloc] init];
//        //The minimum font size in points default is 0;
//        _webPrefrence.minimumFontSize = 10;
//        //是否支持JavaScript
//        _webPrefrence.javaScriptEnabled = YES;
//        //不通过用户交互，是否可以打开窗口
//        _webPrefrence.javaScriptCanOpenWindowsAutomatically = NO;
//    }
//    return _webPrefrence;
//}

- (void)setNameOfFunctionRegisteredToJS:(NSString *)nameOfFunctionRegisteredToJS {
    _nameOfFunctionRegisteredToJS = [nameOfFunctionRegisteredToJS copy];
    
//    [self.userContentController addScriptMessageHandler:self.scriptMessageHandlerBridge name:_nameOfFunctionRegisteredToJS];
}

- (void)setJsCodeToExecute:(NSString *)jsCodeToExecute {
    _jsCodeToExecute = [jsCodeToExecute copy];
    
    [self.webView evaluateJavaScript:_jsCodeToExecute completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        ///
        NSLog(@"result => %@", result);
        if (self.executeJSCodeCallBack) {
            self.executeJSCodeCallBack(self.webView, error == nil, result, error);
        }
    }];
}

#pragma mark - UI
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
}
- (void)dealloc {
    if (self.nameOfFunctionRegisteredToJS && self.nameOfFunctionRegisteredToJS.length > 0) {
//        [self.userContentController removeScriptMessageHandlerForName:self.nameOfFunctionRegisteredToJS];
    }
}

- (void)setUpView {
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
}

- (WKWebView*)createWKWebViewWithConfig:(WKWebViewConfiguration*)config  {
//    config.preferences = self.webPrefrence;
//    config.userContentController = self.userContentController;
//
//    self.scriptMessageHandlerBridge.scriptMessageHandlerDelegate = self.wkDelegateHandler;
    
#if 0 // 注册 js 方法放到 nameOfFunctionRegisteredToJS 的 setter 方法中
    if (self.nameOfFunctionRegisteredToJS && self.nameOfFunctionRegisteredToJS.length > 0) {
        [self.userContentController addScriptMessageHandler:self.scriptMessageHandlerBridge name:self.nameOfFunctionRegisteredToJS];
    }
#endif
    
    WKWebView* webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
//    webView.UIDelegate = self.wkDelegateHandler;
//    webView.navigationDelegate = self.wkDelegateHandler;
    [self.view addSubview:webView];
    webView.backgroundColor = [UIColor redColor];
    
    return webView;
}

#pragma mark - =========================================================
#pragma mark - action
- (void)registerFunction:(NSString*)functionNmae toJSWithCallBack:(XHSSReceiveJSMessageCallBack)receiveJSMessageCallBack {
    self.receiveJSMessageCallBack = [receiveJSMessageCallBack copy];
//    [self.userContentController addScriptMessageHandler:self.scriptMessageHandlerBridge name:_nameOfFunctionRegisteredToJS];
}

- (void)executeJSCode:(NSString*)jsCode withCallBack:(XHSSExecuteJSCodeCallBack)executeJSCodeCallBack {
    [self.webView evaluateJavaScript:jsCode completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        ///
        NSLog(@"result => %@", result);
        if (executeJSCodeCallBack) {
            executeJSCodeCallBack(self.webView, error == nil, result, error);
        }
    }];
}

@end




#pragma mark - ******************************************
/**
 处理 WKVebView 代理事件的类
 */
@interface XHSSWKDelegateHandler () 

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) XHSSWKDelegateHandler *wkDelegateHandler;
@property (nonatomic, strong) WKWebViewConfiguration *webViewConfig;
@property (nonatomic, strong) XHSSWKScriptMessageHandlerBridge *scriptMessageHandlerBridge;
@property (nonatomic, strong) WKUserContentController *userContentController;
@property (nonatomic, strong) WKPreferences *webPrefrence;

@end

@implementation XHSSWKDelegateHandler

#pragma mark - setter & getter
- (WKWebViewConfiguration *)webViewConfig {
    if (_webViewConfig == nil) {
        _webViewConfig = [[WKWebViewConfiguration alloc] init];
    }
    return _webViewConfig;
}

- (XHSSWKScriptMessageHandlerBridge*)scriptMessageHandlerBridge {
    if (_scriptMessageHandlerBridge == nil) {
        _scriptMessageHandlerBridge = [[XHSSWKScriptMessageHandlerBridge alloc] init];
    }
    return _scriptMessageHandlerBridge;
}

- (WKUserContentController*)userContentController {
    if (_userContentController == nil) {
        _userContentController = [[WKUserContentController alloc] init];
    }
    return _userContentController;
}

- (WKPreferences *)webPrefrence {
    if (_webPrefrence == nil) {
        _webPrefrence = [[WKPreferences alloc] init];
        //The minimum font size in points default is 0;
        _webPrefrence.minimumFontSize = 10;
        //是否支持JavaScript
        _webPrefrence.javaScriptEnabled = YES;
        //不通过用户交互，是否可以打开窗口
        _webPrefrence.javaScriptCanOpenWindowsAutomatically = NO;
    }
    return _webPrefrence;
}

- (void)setNameOfFunctionRegisteredToJS:(NSString *)nameOfFunctionRegisteredToJS {
    _nameOfFunctionRegisteredToJS = [nameOfFunctionRegisteredToJS copy];
    
    [self.userContentController addScriptMessageHandler:self.scriptMessageHandlerBridge name:_nameOfFunctionRegisteredToJS];
}

- (void)setJsCodeToExecute:(NSString *)jsCodeToExecute {
    _jsCodeToExecute = [jsCodeToExecute copy];
    
    [self.webView evaluateJavaScript:_jsCodeToExecute completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        ///
        NSLog(@"result => %@", result);
        if (self.executeJSCodeCallBack) {
            self.executeJSCodeCallBack(self.webView, error == nil, result, error);
        }
    }];
}

#pragma mark - =========================================================
#pragma mark - action
- (void)registerFunction:(NSString*)functionNmae toJSWithCallBack:(XHSSReceiveJSMessageCallBack)receiveJSMessageCallBack {
    self.receiveJSMessageCallBack = [receiveJSMessageCallBack copy];
    [self.userContentController addScriptMessageHandler:self.scriptMessageHandlerBridge name:_nameOfFunctionRegisteredToJS];
}

- (void)executeJSCode:(NSString*)jsCode withCallBack:(XHSSExecuteJSCodeCallBack)executeJSCodeCallBack {
    [self.webView evaluateJavaScript:jsCode completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        ///
        NSLog(@"result => %@", result);
        if (executeJSCodeCallBack) {
            executeJSCodeCallBack(self.webView, error == nil, result, error);
        }
    }];
}

#pragma mark - =========================================================
#pragma mark - WKUIDelegate
// 调用JS的alert()方法
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
}

// 调用JS的confirm()方法
-(void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
}

// 调用JS的prompt()方法
-(void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    
}

// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    return [[WKWebView alloc]init];
}

#pragma mark - WKNavigationDelegate
// 决定导航的动作，通常用于处理跨域的链接能否导航。WebKit对跨域进行了安全检查限制，不允许跨域，因此我们要对不能跨域的链接
// 单独处理。但是，对于Safari是允许跨域的，不用这么处理。
// 这个是决定是否Request
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSLog(@"%@",navigationAction.request.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
}

// 决定是否接收响应
// 这个是决定是否接收response
// 要获取response，通过WKNavigationResponse对象获取
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}

// 当main frame的导航开始请求时，会调用此方法
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
}

// 当main frame接收到服务重定向时，会回调此方法
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
}

// 当main frame开始加载数据失败时，会回调
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
}

// 当main frame的web内容开始到达时，会回调
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    
}

// 当main frame导航完成时，会回调
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    
}

// 当main frame最后下载数据失败时，会回调
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
}

// 这与用于授权验证的API，与AFN、UIWebView的授权验证API是一样的
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    
}

#pragma mark - XHSSWKScriptMessageHandlerBridgeDelegate
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"message => %@", message);
    
    if (self.receiveJSMessageCallBack) {
        self.receiveJSMessageCallBack(self.webView, message);
    }
}

@end

