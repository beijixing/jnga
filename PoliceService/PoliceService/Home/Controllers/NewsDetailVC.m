//
//  NewsDetailVC.m
//  PoliceService
//
//  Created by horse on 2017/3/17.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "NewsDetailVC.h"
#import "Constant.h"
#import "WJHUD.h"
#import "MJRefresh.h"
@interface NewsDetailVC ()<UIWebViewDelegate>
@property(nonatomic, strong) UIWebView *webView;
@end

@implementation NewsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"警务资讯";
    [self setUpLeftNavbarItem];
    [self.view addSubview:self.webView];
}

- (void)setUpLeftNavbarItem {
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
        
    }];
}


- (UIWebView *)webView {
    if (_webView) {
        return _webView;
    }
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?id=%@",Host_IP, Interface_NewsDetail, self.newsId]]];
    [_webView loadRequest:request];
    _webView.delegate = self;
    return _webView;
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    [WJHUD showOnView:self.view];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [WJHUD hideFromView:self.view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
