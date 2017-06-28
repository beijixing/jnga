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
#import "RequestService.h"
#import "WJHUD.h"
#import "UDIDManager.h"

@interface CheckPeccancyVC ()
@property (strong, nonatomic) IBOutlet UITextField *carNumberTF;
@property (strong, nonatomic) IBOutlet UITextField *engineNumberTF;
@property (strong, nonatomic) IBOutlet UIButton *carTypeButton;
@property (strong, nonatomic) IBOutlet UITextField *verificationCodeTF;
@property (strong, nonatomic) IBOutlet UIImageView *verificationCodeView;
@property (strong, nonatomic) VerifyCodeView *codeView;
@property (strong, nonatomic) NSArray *carTypeArray;
@property (nonatomic, strong) NSString *carType;

@end

@implementation CheckPeccancyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"违章查询";
    [self setUpLeftNavbarItem];
    [self setupCarNumberTFLeftView];
    [self getCarType];
    [self.verificationCodeView addSubview:self.codeView];
}

- (void)setUpLeftNavbarItem {
//    typeof(self) __weak wself = self;
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
        
    }];
}

- (void)getCarType{
    [RequestService  getAppDataDictWithParamDict:@{@"type":@"plate_type"} resultBlock:^(BOOL success, id object) {
        if (success) {
            if ([[object objectForKey:@"code"] isEqualToString:@"1"]) {
                self.carTypeArray = object[@"data"];
            }
        }
    }];
}
- (IBAction)chooseCarType:(id)sender {
    NSMutableArray *popOverActions = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.carTypeArray.count; i ++ ) {
        NSDictionary *dict = self.carTypeArray[i];
        PopoverAction *pop = [PopoverAction actionWithTitle:dict[@"label"] handler:^(PopoverAction *action) {
            self.carType = action.title;
            [self.carTypeButton setTitle:action.title forState:UIControlStateNormal];
            self.carType = dict[@"value"];
        }];
        [popOverActions addObject:pop];
    }
    [self showPopoverViewWithView:sender actions:popOverActions];
}
- (void)showPopoverViewWithView:(UIView *)view  actions:(NSArray *)actions{
    if (actions.count == 0) {
        NSLog(@"showPopoverViewWithView actions 为空");
        return;
    }
    PopoverView* popoverView = [PopoverView popoverView];
    popoverView.style = PopoverViewStyleDefault;
    popoverView.hideAfterTouchOutside = YES; // 点击外部时允许隐藏
    [popoverView showToView:view withActions:actions];
}
- (void)setupCarNumberTFLeftView {
    UIView *leftView = [UIFactory createViewWith:CGRectMake(0, 0, 40, 30) backgroundColor:[UIColor clearColor]];
    
    UIButton *chooseAreaCodeBtn = [UIFactory createButtonWith:CGRectMake(0, 2.5, 40, 25) selector:nil target:self titleColor:COLOR_WITH_RGB(90, 90, 90) title:@"H"];
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
    
//    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:[[CheckPeccancyResultVC alloc] init] animated:YES];
    [self queryInfo];
}

-(void)queryInfo{
    
    if ([_carType isEqualToString:@""]) {
        [WJHUD showText:@"请选择车型" onView:self.view];
        return;
    }
    if ([_carNumberTF.text isEqualToString:@""]) {
        [WJHUD showText:@"请输入车牌号" onView:self.view];
        return;
    }
    if ([_engineNumberTF.text isEqualToString:@""]) {
        [WJHUD showText:@"请输入发动机号" onView:self.view];
        return;
    }
    [WJHUD showOnView:self.view];
    [RequestService queryPeccancyWithParamDict:@{@"type":_carType,
                                                 @"plateNumber":[NSString stringWithFormat:@"鲁H%@",_carNumberTF.text],
                                                 @"engineNumber":_engineNumberTF.text,
                                                 @"imei":[UDIDManager getUDID]} resultBlock:^(BOOL success, id  _Nullable object) {
                                                     [WJHUD hideFromView:self.view];
                                                     if (success) {
                                                         NSArray *infoAry = [object objectForKey:@"data"];
                                                         if (infoAry.count!=0) {
                                                             
                                                         }else{
                                                             [WJHUD showText:[object objectForKey:@"message"] onView:self.view];
                                                         }
                                                     }
    }];
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
