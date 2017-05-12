//
//  FSWebViewJSBridge.h
//  FosungCore
//
//  Created by horse on 2017/1/18.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FSWebViewJSBase.h"

@interface FSWebViewJSBridge:NSObject

+ (instancetype)bridgeForWebView:(UIWebView*)webView;
+ (void)enableLogging;
+ (void)setLogMaxLength:(int)length;

- (void)registerHandler:(NSString*)handlerName handler:(FSWVJBHandler)handler;
- (void)callHandler:(NSString*)handlerName;
- (void)callHandler:(NSString*)handlerName data:(id)data;
- (void)callHandler:(NSString*)handlerName data:(id)data responseCallback:(FSWVJBResponseCallback)responseCallback;
- (void)setWebViewDelegate:(id <UIWebViewDelegate>)webViewDelegate;

@end
