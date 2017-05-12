//
//  CommonWebViewController.m
//  PoliceService
//
//  Created by horse on 2017/4/8.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "CommonWebViewController.h"
#import "WJHUD.h"
@interface CommonWebViewController ()<UIWebViewDelegate>

@end

@implementation CommonWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpLeftNavbarItem];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.urlString]]];
    [_webView loadRequest:request];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
}

- (void)setUpLeftNavbarItem {
    //    typeof(self) __weak wself = self;
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
        
    }];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
