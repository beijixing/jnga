//
//  MyBusiness2VC.m
//  PoliceService
//
//  Created by fosung on 2017/6/21.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "MyBusiness2VC.h"
#import "GlobalVariableManager.h"
#import "UDIDManager.h"
#import "FSMacro.h"
#import "WJHUD.h"

@interface MyBusiness2VC ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;

@end

@implementation MyBusiness2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的业务";
    [self setUpLeftNavbarItem];
    [self loadWebWithTag:0];
    self.webView.delegate = self;
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

- (IBAction)segmentChange:(UIButton *)sender {
    [self loadWebWithTag:sender.tag];
    if (sender == _firstButton) {
        [_firstButton setBackgroundColor:COLOR_WITH_RGB(115, 198, 250)];
        [_firstButton setTintColor:[UIColor whiteColor]];
        [_secondButton setBackgroundColor:[UIColor lightGrayColor]];
        [_secondButton setTintColor:[UIColor blackColor]];
    }
    if (sender == _secondButton) {
        [_secondButton setBackgroundColor:COLOR_WITH_RGB(115, 198, 250)];
        [_secondButton setTintColor:[UIColor whiteColor]];
        [_firstButton setBackgroundColor:[UIColor lightGrayColor]];
        [_firstButton setTintColor:[UIColor blackColor]];
    }
}

-(void)loadWebWithTag:(NSUInteger)tag{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://jnhz.jiga.gov.cn/api/business/MyList?id=%ld&fcard=%@&uuid=%@&token=%@",(long)tag,[GlobalVariableManager manager].codeId,[UDIDManager getUDID],[GlobalVariableManager manager].loginToken]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [WJHUD showOnView:self.view];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [WJHUD hideFromView:self.view];
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
