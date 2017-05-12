//
//  CheckPeccancyVC.m
//  PoliceService
//
//  Created by horse on 2017/2/17.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "CheckPeccancyVC.h"
#import "UIFactory.h"
#import "FSMacro.h"
#import "UIView+CornerRadius.h"
#import "PopoverView.h"
#import "VerifyCodeView.h"
#import "CheckPeccancyResultVC.h"
@interface CheckPeccancyVC ()
@property (strong, nonatomic) IBOutlet UITextField *carNumberTF;
@property (strong, nonatomic) IBOutlet UITextField *engineNumberTF;
@property (strong, nonatomic) IBOutlet UITextField *carFrameNumberTF;
@property (strong, nonatomic) IBOutlet UITextField *verificationCodeTF;
@property (strong, nonatomic) IBOutlet UIImageView *verificationCodeView;
@property (strong, nonatomic) VerifyCodeView *codeView;

@end

@implementation CheckPeccancyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"违章查询";
    [self setUpLeftNavbarItem];
    [self setupCarNumberTFLeftView];
    [self.verificationCodeView addSubview:self.codeView];
}

- (void)setUpLeftNavbarItem {
//    typeof(self) __weak wself = self;
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
        
    }];
}

- (void)setupCarNumberTFLeftView {
    UIView *leftView = [UIFactory createViewWith:CGRectMake(0, 0, 40, 30) backgroundColor:[UIColor clearColor]];
    
    UIButton *chooseAreaCodeBtn = [UIFactory createButtonWith:CGRectMake(0, 2.5, 40, 25) selector:@selector(chooseAreaCode:) target:self titleColor:COLOR_WITH_RGB(90, 90, 90) title:@"A\U0000E601"];
    chooseAreaCodeBtn.titleLabel.font = [UIFont fontWithName:@"iconfont" size:15.0];
    chooseAreaCodeBtn.cornerRadius = 6;
    chooseAreaCodeBtn.borderWidth = 1.0;
    chooseAreaCodeBtn.borderColor = COLOR_WITH_RGB(203, 203, 203);
    chooseAreaCodeBtn.backgroundColor = COLOR_WITH_RGB(238, 238, 238);
    [leftView addSubview:chooseAreaCodeBtn];
    self.carNumberTF.leftViewMode=UITextFieldViewModeAlways;
    self.carNumberTF.leftView = leftView;
}

- (void)chooseAreaCode:(UIButton* )btn {

//    typeof(self) __weak wself = self;
    NSMutableArray *popOverActions = [[NSMutableArray alloc] init];
    NSArray *titleArr = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    
    for (NSString* fontName in titleArr) {
        PopoverAction *action = [PopoverAction actionWithTitle:fontName handler:^(PopoverAction *action) {
            NSLog(@"fontName = %@", fontName);
            [btn setTitle:[NSString stringWithFormat:@"%@\U0000E601", fontName] forState:UIControlStateNormal];
        }];
        [popOverActions addObject:action];
    }
    
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.style = PopoverViewStyleDark;
    popoverView.hideAfterTouchOutside = YES; // 点击外部时允许隐藏
    [popoverView showToView:btn withActions:popOverActions];
}
- (IBAction)queryBtnAction:(UIButton *)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:[[CheckPeccancyResultVC alloc] init] animated:YES];
}

- (VerifyCodeView *)codeView {
    if (_codeView) {
        return _codeView;
    }
    _codeView = [[VerifyCodeView alloc] initWithFrame:CGRectMake(0, 0, self.verificationCodeView.frame.size.width, self.verificationCodeView.frame.size.height)];
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
