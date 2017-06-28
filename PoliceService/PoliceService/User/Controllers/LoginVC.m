//
//  LoginVC.m
//  PoliceService
//
//  Created by horse on 2017/2/10.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "LoginVC.h"
#import "RegisterVC.h"
#import "ReservationNoticeVC.h"
#import "Constant.h"
#import "Validator.h"
#import "WJHUD.h"
#import "RequestService.h"
#import "GlobalVariableManager.h"
#import "ChangePasswordVC.h"
#import "UDIDManager.h"
@interface LoginVC ()

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.phoneTF.text = [GlobalVariableManager manager].phone;
//    self.passwdTF.text= [GlobalVariableManager manager].pswd;
}
- (IBAction)backBtnAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
- (IBAction)registerBtnAction:(id)sender {
    RegisterVC *regVc = [[RegisterVC alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self presentViewController:regVc animated:YES completion:nil];
}


- (IBAction)loginAction:(id)sender {
    
    if (![Validator isValidPhone:self.phoneTF.text]) {
        [WJHUD showText:@"请输入正确的手机号" onView:self.view];
        return;
    }
    
    if (self.passwdTF.text.length < 6) {
         [WJHUD showText:@"请输入至少6位密码" onView:self.view];
        return;
    }
    
    typeof(self) __weak wself = self;
    [RequestService loginWithParamDict:@{@"phone":self.phoneTF.text,
                                             @"password":self.passwdTF.text,
                                         @"uuid":    [UDIDManager getUDID]
                                         }
    resultBlock:^(BOOL success, id object) {
                if (success) {
                    NSDictionary *dataDict = (NSDictionary *)object;
                    if ([[dataDict objectForKey:@"code"] integerValue] == 1) {
                        //临时设置 phone/loginToken作为登录用
                        [GlobalVariableManager manager].phone = wself.phoneTF.text;
                        [GlobalVariableManager manager].pswd = wself.passwdTF.text;
                        [GlobalVariableManager manager].codeId =[dataDict objectForKey:@"code_id"];
                        
                            [GlobalVariableManager manager].userId = [dataDict objectForKey:@"user_id"];
                            [GlobalVariableManager manager].loginToken = [dataDict objectForKey:@"token"];
                        
                            [wself dismissViewControllerAnimated:YES completion:^{
                            }];
                            [[NSNotificationCenter defaultCenter] postNotificationName:LoginSucessNotificationKey object:nil];
                        
                            if (wself.loginSuccessCallback) {
                                wself.loginSuccessCallback();
                            }
                        }else {
                            [WJHUD showText:[dataDict objectForKey:@"message"] onView:wself.view];
                        }
                }else {
                    NSLog(@"object = %@",object);
                }
      }];
    
}

- (IBAction)forgetPasswdAction:(id)sender {
    ChangePasswordVC *changePassWordVc = [[ChangePasswordVC alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self presentViewController:changePassWordVc animated:YES completion:nil];
}
- (IBAction)registerAction:(UIButton *)sender {
    RegisterVC *regVc = [[RegisterVC alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self presentViewController:regVc animated:YES completion:^{
    }];
}
@end
