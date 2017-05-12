//
//  ChangePasswordVC.m
//  PoliceService
//
//  Created by horse on 2017/3/1.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "ChangePasswordVC.h"
#import "GlobalVariableManager.h"
#import "RequestService.h"
#import "Validator.h"
#import "WJHUD.h"
@interface ChangePasswordVC ()
{
    dispatch_source_t _timer;
}
@property (strong, nonatomic) IBOutlet UITextField *passwordTF;
@property (strong, nonatomic) IBOutlet UITextField *PasswordNewTF;
@property (strong, nonatomic) IBOutlet UITextField *confrimPasswordTF;
@property (strong, nonatomic) IBOutlet UILabel *firstLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdLabel;
@property(nonatomic, assign) NSInteger timerCount;
@property(nonatomic, strong) NSString *verifyCode;
@property (strong, nonatomic) IBOutlet UIButton *codeButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *codeButtonWidthConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *passwordTFTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationViewHeightConstraint;

@end

@implementation ChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    [self setUpLeftNavbarItem];
    
    if([GlobalVariableManager manager].userId != nil){
        //已登录
        self.codeButtonWidthConstraint.constant = 0;
        self.passwordTFTrailingConstraint.constant = 15;
        self.navigationViewHeightConstraint.constant = 0;
        self.firstLabel.text = @"手机号";
        self.passwordTF.placeholder = @"请输入手机号";
        self.secondLabel.text = @"原密码";
        self.PasswordNewTF.placeholder = @"请输入原密码";
        self.thirdLabel.text = @"新密码";
        self.confrimPasswordTF.placeholder = @"请输入新密码";
    }else{
        //未登录
        self.codeButtonWidthConstraint.constant = 92;
        self.passwordTFTrailingConstraint.constant = 115;
        self.firstLabel.text = @"手机号";
        self.passwordTF.placeholder = @"请输入手机号";
        self.secondLabel.text = @"验证码";
        self.PasswordNewTF.placeholder = @"请输入验证码";
        self.thirdLabel.text = @"新密码";
        self.confrimPasswordTF.placeholder = @"请输入新密码";
    }

}

- (void)setUpLeftNavbarItem {
//    typeof(self) __weak wself = self;
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
        
    }];
}


- (IBAction)commitAction:(UIButton *)sender {
    if ([GlobalVariableManager manager].userId != nil) {
        //已登录
        if ([self isEmpty:@[self.passwordTF, self.PasswordNewTF, self.confrimPasswordTF]]) {
            [WJHUD showText:@"输入不能为空" onView:self.view];
            return;
        }
        
        [RequestService changePasswordWithParamDict:@{@"phone":self.passwordTF.text,
                                                      @"origPwd":self.PasswordNewTF.text,
                                                      @"newPwd":self.confrimPasswordTF.text
                                                      } resultBlock:^(BOOL success, id object) {
            if (success) {
                NSDictionary *dataDict = (NSDictionary *)object;
                if ([[dataDict objectForKey:@"code"] integerValue] == 1) {
                    [WJHUD showText:@"修改成功！" onView:self.view];
                }else {
                    [WJHUD showText:[dataDict objectForKey:@"message"] onView:self.view];
                }
            }else {
                NSLog(@"object=%@", object);
            }
            
        }];
    }else{
        //未登录
        if ([self isEmpty:@[self.passwordTF, self.PasswordNewTF, self.confrimPasswordTF]]) {
            [WJHUD showText:@"输入不能为空" onView:self.view];
            return;
        }
        
        if (![self.PasswordNewTF.text isEqualToString:self.verifyCode]){
            [WJHUD showText:@"验证码不正确" onView:self.view];
            return;
        }
        
        [self resetTimerInfo];
        
        [RequestService changePasswordWithParamDict:@{@"phone":self.passwordTF.text,
                                                      @"verify_code":self.verifyCode,
                                                      @"newPwd":self.confrimPasswordTF.text
                                                      } resultBlock:^(BOOL success, id object) {
            if (success) {
                NSDictionary *dataDict = (NSDictionary *)object;
                if ([[dataDict objectForKey:@"code"] integerValue] == 1) {
                    [WJHUD showText:@"修改成功！" onView:self.view];
                }else {
                    [WJHUD showText:[dataDict objectForKey:@"message"] onView:self.view];
                }
            }else {
                NSLog(@"object=%@", object);
            }
            
        }];
    
    }
}

- (BOOL)isEmpty:(NSArray *)tfArr {
    __block BOOL flag = NO;
    [tfArr enumerateObjectsUsingBlock:^(UITextField *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([Validator isSpaceOrEmpty:obj.text]) {
            flag = YES;
            *stop = YES;
        }
    }];
    
    return flag;
}

- (IBAction)getVerifyCodeAction:(UIButton*)sender {
    if (![Validator isValidPhone:self.passwordTF.text]) {
        [WJHUD showText:@"输入的手机号格式不正确" onView:self.view];
        return;
    }
    
    typeof(self) __weak wself = self;
    [RequestService getVerifyCodeWithParamDict:@{@"phone":self.passwordTF.text} resultBlock:^(BOOL success, id object) {
        if(success) {
            NSDictionary *dataDict = (NSDictionary *)object;
            if ([[dataDict objectForKey:@"code"] integerValue] ==1 ) {
                wself.verifyCode = [dataDict objectForKey:@"verify_code"];
                NSLog(@"wself.verifyCode=%@", wself.verifyCode);
            }else {
                [WJHUD showText:[dataDict objectForKey:@"message"] onView:wself.view];
            }
            
        }else {
            NSLog(@"object = %@", object);
        }
    }];
    
    sender.enabled = NO;
    self.timerCount = 120;
    [sender setTitle:[NSString stringWithFormat:@"%ld", self.timerCount] forState:UIControlStateNormal];
    [self startCountDownTimer];
}

- (void)startCountDownTimer {
    NSTimeInterval period = 1; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    typeof(self) __weak wself = self;
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself timerAction];
        });
    });
    dispatch_resume(_timer);
}

- (void)timerAction {
    self.timerCount--;
    if (self.timerCount<=0) {
        dispatch_source_cancel(_timer);
        [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.codeButton.enabled = YES;
    }else {
        [self.codeButton setTitle:[NSString stringWithFormat:@"%lds后重发", self.timerCount] forState:UIControlStateNormal];
    }
    
}

- (void)resetTimerInfo {
    dispatch_source_cancel(_timer);
    [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.codeButton.enabled = YES;

}
- (IBAction)backBtnAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
