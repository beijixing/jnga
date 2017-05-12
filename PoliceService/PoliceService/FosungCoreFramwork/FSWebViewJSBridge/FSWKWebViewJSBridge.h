//
//  FSWKWebViewJSBridge.h
//  FosungCore
//
//  Created by horse on 2017/1/18.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "FSWebViewJSBase.h"

@interface FSWKWebViewJSBridge : NSObject
+ (instancetype)bridgeForWebView:(WKWebView*)webView;
+ (void)enableLogging;
- (void)registerHandler:(NSString*)handlerName handler:(FSWVJBHandler)handler;
- (void)callHandler:(NSString*)handlerName;
- (void)callHandler:(NSString*)handlerName data:(id)data;
- (void)callHandler:(NSString*)handlerName data:(id)data responseCallback:(FSWVJBResponseCallback)responseCallback;
- (void)reset;
- (void)setWebViewDelegate:(id<WKNavigationDelegate>)webViewDelegate;
@end
