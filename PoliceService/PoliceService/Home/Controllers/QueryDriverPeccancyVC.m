//
//  QueryDriverPeccancyVC.m
//  PoliceService
//
//  Created by horse on 2017/3/1.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "QueryDriverPeccancyVC.h"
#import "VerifyCodeView.h"
#import "DriverPeccancyResultVC.h"
@interface QueryDriverPeccancyVC ()
@property (strong, nonatomic) IBOutlet UITextField *driverIDNumberTF;
@property (strong, nonatomic) IBOutlet UITextField *fileCodeTF;
@property (strong, nonatomic) IBOutlet UITextField *verificationCodeTF;
@property (strong, nonatomic) IBOutlet UIImageView *verifiCodeView;
@property (strong, nonatomic) VerifyCodeView *codeView;
@end

@implementation QueryDriverPeccancyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"驾驶证违法查询";
    [self setUpLeftNavbarItem];
    [self.verifiCodeView addSubview:self.codeView];
}

- (void)setUpLeftNavbarItem {
//    typeof(self) __weak wself = self;
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
        
    }];
}
- (IBAction)queryBtnAction:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:[[DriverPeccancyResultVC alloc] init] animated:YES];
}

- (VerifyCodeView *)codeView {
    if (_codeView) {
        return _codeView;
    }
    _codeView = [[VerifyCodeView alloc] initWithFrame:CGRectMake(0, 0, self.verifiCodeView.frame.size.width, self.verifiCodeView.frame.size.height)];
    //手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(codeViewClick:)];
    [_codeView addGestureRecognizer:tap];
    
    return _codeView;
}

- (void)codeViewClick:(UITapGestureRecognizer *)gesture {
    VerifyCodeView* codeView = (VerifyCodeView*)gesture.view;
    [codeView changeCode];
}

@end
