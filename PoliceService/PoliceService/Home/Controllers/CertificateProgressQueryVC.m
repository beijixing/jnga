//
//  CertificateProgressQueryVCViewController.m
//  PoliceService
//
//  Created by fosung on 2017/5/16.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "CertificateProgressQueryVC.h"

@interface CertificateProgressQueryVC ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation CertificateProgressQueryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"出入境证件办理进度查询";
    [self setUpLeftNavbarItem];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.icity365.com/eea/apps/progress/index.html"]];
    [self.webView loadRequest:request];
}
- (void)setUpLeftNavbarItem {
    //    typeof(self) __weak wself = self;
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
        
    }];
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
