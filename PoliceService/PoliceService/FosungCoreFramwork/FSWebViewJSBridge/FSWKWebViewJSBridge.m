//
//  FSWKWebViewJSBridge.m
//  FosungCore
//
//  Created by horse on 2017/1/18.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "FSWKWebViewJSBridge.h"
#import "WKWebViewJavascriptBridge.h"
@interface FSWKWebViewJSBridge()
@property (nonatomic, strong) WKWebViewJavascriptBridge *bridge;
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation FSWKWebViewJSBridge
+ (instancetype)bridgeForWebView:(WKWebView*)webView {
    FSWKWebViewJSBridge *bridge = [[self alloc] initWithWebView:webView];
    return bridge;
}


+ (void)enableLogging {
    [FSWKWebViewJSBridge enableLogging];
}

- (instancetype)initWithWebView:(WKWebView *)web {
    if (self = [super init]) {
        self.webView = web;
    }
    return self;
}

-(WKWebViewJavascriptBridge *)bridge {
    if (_bridge) {
        return _bridge;
    }
    _bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
    return _bridge;
}

- (void)registerHandler:(NSString*)handlerName handler:(FSWVJBHandler)handler {

}

- (void)callHandler:(NSString*)handlerName {
    [self.bridge callHandler:handlerName];
}

- (void)callHandler:(NSString*)handlerName data:(id)data {
    [self.bridge callHandler:handlerName data:data];
}

- (void)callHandler:(NSString*)handlerName data:(id)data responseCallback:(FSWVJBResponseCallback)responseCallback {
    [self.bridge callHandler:handlerName data:data responseCallback:^(id responseData) {
        if (responseCallback) {
            responseCallback(responseData);
        }
    }];
}

- (void)reset {
    [self.bridge reset];
}

- (void)setWebViewDelegate:(id<WKNavigationDelegate>)webViewDelegate {
    [self.bridge setWebViewDelegate:webViewDelegate];
}
@end
