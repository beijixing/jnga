//
//  SuggestionVC.m
//  PoliceService
//
//  Created by horse on 2017/2/21.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "SuggestionVC.h"
#import "WJTextView.h"
#import "PopoverView.h"
#import "WJHUD.h"
#import "RequestService.h"
#import "GlobalVariableManager.h"
#import "GlobalFunctionManager.h"
#import "Validator.h"

@interface SuggestionVC ()
@property (strong, nonatomic) IBOutlet UITextField *nameTF;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (strong, nonatomic) IBOutlet UITextField *idcardNUmberTF;
@property (strong, nonatomic) IBOutlet UITextField *addressTF;
@property (strong, nonatomic) IBOutlet UILabel *areaLabel;

@property (strong, nonatomic) IBOutlet UILabel *classLabel;
@property(nonatomic, strong) NSString *businessType;
@property (strong, nonatomic) IBOutlet WJTextView *contentTV;

@end

@implementation SuggestionVC

- (void)viewDidLoad {

    [super viewDidLoad];
    [self setUpLeftNavbarItem];
    self.contentTV.placeHolder = @"请输入...";
    self.contentTV.fontOfPlaceHolder = [UIFont fontWithName:@"Arial" size:15.0];
    
    [self setupAreaAndClassLabel];
}

- (void)setupAreaAndClassLabel {
    self.areaLabel.font = [UIFont fontWithName:@"iconfont" size:15.0];
    self.areaLabel.text = @"请选择地区 \U0000E601";
    self.classLabel.font = [UIFont fontWithName:@"iconfont" size:15.0];
    self.classLabel.text = @"请选择业务分类 \U0000E601";
}
- (void)setUpLeftNavbarItem {
    typeof(self) __weak wself = self;
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
        
    }];
}

- (IBAction)selectAreaLabelAction:(UITapGestureRecognizer *)sender {
    
    NSMutableArray *popOverActions = [[NSMutableArray alloc] init];
    NSArray *titleArr = @[@"高新区",@"市中区",@"历下区",@"历城区",@"天桥区",@"章丘区",@"槐荫区"];
   
    typeof(self) __weak wself = self;
    
    
    for (NSString* fontName in titleArr) {
        PopoverAction *action = [PopoverAction actionWithTitle:fontName handler:^(PopoverAction *action) {
            NSLog(@"fontName = %@", fontName);
            wself.areaLabel.text = [NSString stringWithFormat:@"%@ \U0000E601", fontName];
        }];
        [popOverActions addObject:action];
    }
    
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.style = PopoverViewStyleDark;
    popoverView.hideAfterTouchOutside = YES; // 点击外部时允许隐藏
    [popoverView showToView:sender.view withActions:popOverActions];
    
}

- (IBAction)selectClassLabelAction:(UITapGestureRecognizer *)sender {
    
    NSMutableArray *popOverActions = [[NSMutableArray alloc] init];
    NSArray *titleArr = @[@"1治安", @"2民政", @"3交警", @"4消防", @"5出入境",
                          @"6网安", @"7法制", @"8刑侦", @"9技防", @"10禁毒", @"11经侦", @"12其他"];
   
    typeof(self) __weak wself = self;
    [titleArr enumerateObjectsUsingBlock:^(NSString  *businessName, NSUInteger idx, BOOL * _Nonnull stop) {
        PopoverAction *action = [PopoverAction actionWithTitle:businessName handler:^(PopoverAction *action) {
            NSLog(@"fontName = %@", businessName);
            wself.classLabel.text = [NSString stringWithFormat:@"%@ \U0000E601", businessName];
            wself.businessType = [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:idx]];
        }];
        [popOverActions addObject:action];
    }];
  
    
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.style = PopoverViewStyleDark;
    popoverView.hideAfterTouchOutside = YES; // 点击外部时允许隐藏
    [popoverView showToView:sender.view withActions:popOverActions];
}

- (IBAction)commitAction:(id)sender {
    /*
     String type;  // 类型（必填）
     (民生诉求分类：1-5分别为  我要举报、 建议 、投诉、咨询、 信访)
     String name;  // 姓名（必填）
     String phone;  // 手机号（必填）
     String email;  // 邮箱
     String idcard;  // 身份证
     String location;  // 联系地址
     String place;  // 所在地区（必填）
     默认为济宁
     String business;  // 业务分类（必填）
     业务分类：1治安2民政3交警4消防5出入境
     6网安7法制8刑侦9技防 10禁毒11经侦12其他
     String content;  // 内容（必填）
     */
    
    if ([Validator isSpaceOrEmpty:self.nameTF.text]) {
        [WJHUD showText:@"请输入姓名" onView:self.view];
        return;
    }
    
    if (![Validator isValidPhone:self.phoneNumTF.text]) {
        [WJHUD showText:@"请输入正确的手机号" onView:self.view];
        return;
    }
    
    if (!self.businessType ) {
        [WJHUD showText:@"请输选择业务类型" onView:self.view];
        return;
    }
    
    if (!self.contentTV.text) {
        [WJHUD showText:@"请输入提交内容" onView:self.view];
        return;
    }
    
    [WJHUD showOnView:self.view];
    typeof(self) __weak wself = self;
    [RequestService postPeopleappealMostWithParamDict:@{@"type" : self.dataType ?: @"1",
                                                        @"name" : self.nameTF.text ?: @"",
                                                        @"phone" : self.phoneNumTF.text ?: @"",
                                                        @"idcard" : self.idcardNUmberTF.text ?: @"",
                                                        @"location" : self.addressTF.text ?: @"",
                                                        @"place" : self.areaLabel.text ?: @"济宁",
                                                        @"business" : self.businessType ?: @"12",
                                                        @"content" : self.contentTV.text ?: @""
                                                        } resultBlock:^(BOOL success, id object) {
                                                            [WJHUD hideFromView:wself.view];
        [GlobalFunctionManager handleServerDataWithController:wself result:success dataObj:object successBlock:^{
            [WJHUD showText:@"提交成功" onView:wself.view];
        }];
    }];
}

@end
