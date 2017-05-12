//
//  ChangePhoneNumberVC.m
//  PoliceService
//
//  Created by horse on 2017/2/14.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "ChangePhoneNumberVC.h"
#import "RequestService.h"
#import "Validator.h"
#import "WJHUD.h"
#import "GlobalVariableManager.h"
@interface ChangePhoneNumberVC ()
{
    dispatch_source_t _timer;
}
@property (strong, nonatomic) IBOutlet UIView *stepOneView;
@property (strong, nonatomic) IBOutlet UIView *stepTwoView;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTF;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (strong, nonatomic) IBOutlet UITextField *verifyCodeTF;
@property (strong, nonatomic) IBOutlet UILabel *timeCountDownLabel;
@property (strong, nonatomic) NSString *verifyCode;
@property (nonatomic, assign) NSInteger timerCount;

@end

@implementation ChangePhoneNumberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改手机号";
    [self setUpLeftNavbarItem];
}

- (void)setUpLeftNavbarItem {
//    typeof(self) __weak wself = self;
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
        
    }];
}
- (IBAction)nextStepOneAction:(id)sender {
    if (![Validator isValidPhone:self.phoneNumberTF.text]) {
        [WJHUD showText:@"输入的手机号格式不正确" onView:self.view];
        return;
    }
    
    [self getVerificationCode];
    
    self.stepOneView.hidden = YES;
    self.stepTwoView.hidden = NO;
    
    [self showPhoneNumber];
}

- (void)showPhoneNumber {
    self.phoneNumberLabel.text = [NSString stringWithFormat:@"%@******%@",[self.phoneNumberTF.text substringToIndex:3],[self.phoneNumberTF.text substringFromIndex:7]];
}

- (void)startCountDownTimer {
    NSTimeInterval period = 1; //设置时间间隔
    self.timeCountDownLabel.userInteractionEnabled = NO;
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
        self.timeCountDownLabel.text = @"重新发送";
        self.timeCountDownLabel.userInteractionEnabled = YES;
    }else {
      self.timeCountDownLabel.text = [NSString stringWithFormat:@"%lds后重发", self.timerCount];
    }
    
}

- (IBAction)nextStepTwoAction:(id)sender {
    //下一步 验证验证码
    if (![self.verifyCode isEqualToString:self.verifyCodeTF.text]) {
        [WJHUD showText:@"验证码不正确" onView:self.view];
        return;
    }
    
    [RequestService changePhoneWithParamDict:@{@"newPhone":self.phoneNumberTF.text,
                                               @"oldPhone":[GlobalVariableManager manager].phone,
                                               @"verify_code":self.verifyCode
                                               } resultBlock:^(BOOL success, id object) {
        if (success) {
            NSDictionary *dataDict = (NSDictionary *)object;
            if ([[dataDict objectForKey:@"code"] integerValue] == 1) {
                
            }else {
                [WJHUD showText:[dataDict objectForKey:@"message"] onView:self.view];
            }
        }else {
            NSLog(@"object=%@", object);
        }
    }];
}


- (IBAction)resendVerifyCodeAction:(id)sender {
    //重新发送验证码
    NSLog(@"重新发送验证码");
    
    [self getVerificationCode];
}

- (void)getVerificationCode {
    typeof(self) __weak wself = self;
    [WJHUD showOnView:self.view];
    [RequestService getVerifyCodeWithParamDict:@{@"phone":[GlobalVariableManager manager].phone} resultBlock:^(BOOL success, id object) {
        [WJHUD hideFromView:wself.view];
        if(success) {
            NSDictionary *dataDict = (NSDictionary *)object;
            if ([[dataDict objectForKey:@"code"] integerValue] ==1 ) {
                wself.verifyCode = [dataDict objectForKey:@"verify_code"];
                NSLog(@"wself.verifyCode=%@", wself.verifyCode);
                [wself startCountDownTimer];
            }else {
                [WJHUD showText:[dataDict objectForKey:@"message"] onView:wself.view];
            }
            
        }else {
            NSLog(@"object = %@", object);
        }
    }];

}

@end
