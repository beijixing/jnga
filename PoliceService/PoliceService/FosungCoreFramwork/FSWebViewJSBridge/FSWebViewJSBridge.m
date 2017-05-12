//
//  FSWebViewJSBridge.m
//  FosungCore
//
//  Created by horse on 2017/1/18.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "FSWebViewJSBridge.h"
#import "WebViewJavascriptBridge.h"
@interface FSWebViewJSBridge()
@property (nonatomic, strong) WebViewJavascriptBridge *bridge;
@property (nonatomic, strong)UIWebView *webView;
@end

@implementation FSWebViewJSBridge

+ (instancetype)bridgeForWebView:(UIWebView*)webView {
    FSWebViewJSBridge *bridge = [[self alloc] initWithWebView:webView];
    return bridge;
}


+ (void)enableLogging {
    [WebViewJavascriptBridge enableLogging];
}

+ (void)setLogMaxLength:(int)length {
    [WebViewJavascriptBridge setLogMaxLength:length];
}

- (instancetype)initWithWebView:(UIWebView *)web {
    if (self = [super init]) {
        self.webView = web;
    }
    return self;
}

-(WebViewJavascriptBridge *)bridge {
    if (_bridge) {
        return _bridge;
    }
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    return _bridge;
}

- (void)registerHandler:(NSString*)handlerName handler:(FSWVJBHandler)handler {
    [self.bridge registerHandler:handlerName handler:^(id data, WVJBResponseCallback responseCallback) {
        if (handler) {
            handler(data, responseCallback);
        }
    }];
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

- (void)setWebViewDelegate:(id <UIWebViewDelegate>)webViewDelegate {
    [self.bridge setWebViewDelegate:webViewDelegate];
}

@end
