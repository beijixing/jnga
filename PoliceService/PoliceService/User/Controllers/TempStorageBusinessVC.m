//
//  TempStorageBusinessVC.m
//  PoliceService
//
//  Created by fosung on 2017/6/20.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "TempStorageBusinessVC.h"
#import "GlobalVariableManager.h"
#import "UDIDManager.h"

@interface TempStorageBusinessVC ()

@end

@implementation TempStorageBusinessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"暂存业务";
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://jnhz.jiga.gov.cn/api/business/MyListt?fcard=%@&uuid=%@&token=%@",[GlobalVariableManager manager].codeId,[UDIDManager getUDID],[GlobalVariableManager manager].loginToken]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self setUpLeftNavbarItem];
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
