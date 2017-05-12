//
//  CheckOpenCaseVC.m
//  PoliceService
//
//  Created by horse on 2017/2/21.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "CheckOpenCaseVC.h"
#import "WJHUD.h"
@interface CheckOpenCaseVC ()<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *phoneOrIDNumberTF;
@property (strong, nonatomic) IBOutlet UITextField *caseCodeTF;
@property(nonatomic, strong) UIWebView *webView;
@end

@implementation CheckOpenCaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"执法办案公开查询";
    [self.view addSubview:self.webView];
    [self setUpLeftNavbarItem];
}
- (void)setUpLeftNavbarItem {
    typeof(self) __weak wself = self;
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
        
    }];
}

- (UIWebView *)webView {
    if (_webView) {
        return _webView;
    }
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",@"http://60.211.180.234:10002/faces/cmp.xhtml"]]];
    [_webView loadRequest:request];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    return _webView;
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    [WJHUD showOnView:self.view];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [WJHUD hideFromView:self.view];
}


- (IBAction)resendCodeAction:(UIButton *)sender {
    //TODO:验证码重发
}
- (IBAction)confirmAction:(UIButton *)sender {
    //TODO:确认缴费
}
@end
