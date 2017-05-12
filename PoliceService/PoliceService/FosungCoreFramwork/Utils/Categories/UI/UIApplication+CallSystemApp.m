//
//  UIApplication+CallSystemApp.m
//  PoliceService
//
//  Created by horse on 2017/3/6.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "UIApplication+CallSystemApp.h"

@implementation UIApplication (CallSystemApp)
- (void)callWithViewController:(UIViewController *)vc telNumber:(NSString *)tel {
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSString *telStr = [NSString stringWithFormat:@"tel:%@",tel]; //貌似tel:// 或者 tel: 都行
    NSURL *telURL =[NSURL URLWithString:telStr];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    //记得添加到view上
    [vc.view addSubview:callWebview];
}
@end
