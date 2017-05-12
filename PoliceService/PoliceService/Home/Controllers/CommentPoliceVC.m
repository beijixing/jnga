//
//  CommentPoliceVC.m
//  PoliceService
//
//  Created by horse on 2017/2/21.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "CommentPoliceVC.h"
#import "WJTextView.h"
#import "PopoverView.h"
#import "FSMacro.h"
#import "RequestService.h"
#import "Validator.h"
#import "GlobalFunctionManager.h"
#import "GlobalVariableManager.h"
#import "WJHUD.h"

@interface CommentPoliceVC ()
@property (strong, nonatomic) IBOutlet UITextField *nameTF;
@property (strong, nonatomic) IBOutlet UITextField *phoneTF;
@property (strong, nonatomic) IBOutlet UITextField *idcardNumberTF;
@property (strong, nonatomic) IBOutlet UITextField *addressTF;
@property (strong, nonatomic) IBOutlet UITextField *commentManNameTF;
@property (strong, nonatomic) IBOutlet UILabel *areaLabel;
@property (strong, nonatomic) IBOutlet WJTextView *contentTV;

@end

@implementation CommentPoliceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我要评警";
    [self setUpLeftNavbarItem];
    self.contentTV.placeHolder = @"请输入...";
    self.contentTV.fontOfPlaceHolder = [UIFont fontWithName:@"Arial" size:15.0];
    
    [self setupAreaAndClassLabel];
}

- (void)setupAreaAndClassLabel {
    self.areaLabel.font = [UIFont fontWithName:@"iconfont" size:15.0];
    self.areaLabel.text = @"请选择地区 \U0000E601";
}

- (void)setUpLeftNavbarItem {
//    typeof(self) __weak wself = self;
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
        
    }];
}
- (IBAction)selectAreaLableAction:(UITapGestureRecognizer *)sender {
    
    
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

- (IBAction)commitAction:(UIButton *)sender {
    /*
     String place;  // 所在地区（必填）
     默认为济宁
     String commentName; //评论对象姓名（必填）
     String content;  // 内容（必填）
     String name;  // 评论人姓名（必填）
     String phone;  // 评论人手机号（必填）
     String email;  // 评论人邮箱
     String idcard;  // 评论人身份证
     String location;  //评论人联系地址
     */
    
    if ([Validator isSpaceOrEmpty:self.nameTF.text]) {
        [WJHUD showText:@"请输入姓名" onView:self.view];
        return;
    }
    
    if (![Validator isValidPhone:self.phoneTF.text]) {
        [WJHUD showText:@"请输入正确的手机号" onView:self.view];
        return;
    }
    
    [WJHUD showOnView:self.view];
    typeof(self) __weak wself = self;
    [RequestService postPeopleappealOneWithParamDict:@{ @"type" : @"6",
                                                        @"name" : self.nameTF.text ?: @"",
                                                        @"phone" : self.phoneTF.text ?: @"",
                                                        @"commentName" : self.commentManNameTF.text ?: @"",
                                                        @"idcard" : self.idcardNumberTF.text ?: @"",
                                                        @"location" : self.addressTF.text ?: @"",
                                                        @"place" : self.areaLabel.text ?: @"济宁",
                                                        @"content" : self.contentTV.text ?: @""
                                                        } resultBlock:^(BOOL success, id object)
    {
        [WJHUD hideFromView:wself.view];
        [GlobalFunctionManager handleServerDataWithController:wself result:success dataObj:object successBlock:^{
            [WJHUD showText:@"提交成功" onView:wself.view];
        }];
    }];
    
}


@end
