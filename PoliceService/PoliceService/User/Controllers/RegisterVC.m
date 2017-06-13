//
//  RegisterVC.m
//  PoliceService
//
//  Created by horse on 2017/2/13.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "RegisterVC.h"
#import "FSMacro.h"
#import "RequestService.h"
#import "WJHUD.h"
#import "Validator.h"
#import "UDIDManager.h"
#import "GlobalVariableManager.h"
@interface RegisterVC ()
{
    dispatch_source_t _timer;
}
@property (strong, nonatomic) IBOutlet UIView *segmentView;
@property (strong, nonatomic) IBOutlet UILabel *registLabel;
@property (strong, nonatomic) IBOutlet UILabel *identifyLabel;
@property (strong, nonatomic) IBOutlet UIView *registerView;
@property (strong, nonatomic) IBOutlet UIView *identifyView;
@property (strong, nonatomic) IBOutlet UITextField *userNameTF;
@property (strong, nonatomic) IBOutlet UIButton *codeButton;
@property (strong, nonatomic) IBOutlet UITextField *idCardNumberTF;
@property (strong, nonatomic) CAShapeLayer *segmentLayer;
@property (nonatomic, assign) NSInteger timerCount;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTF;

@property (strong, nonatomic) IBOutlet UITextField *passwordTF;
@property (strong, nonatomic) IBOutlet UITextField *verificationCodeTF;
@property (strong, nonatomic) NSString *verifyCode;
@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    [self setUpLeftNavbarItem];
//    [self setupRegisterView];
}

//- (void)setupRegisterView {
//    self.segmentLayer = [self getSegmentLayerWithFrontColor:COLOR_WITH_RGB(115, 198, 250) backgroundColor:COLOR_WITH_RGB(204, 204, 204)];
//}
- (IBAction)backBtnAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (CAShapeLayer *)getSegmentLayerWithFrontColor:(UIColor *)fColor backgroundColor:(UIColor *)bgColor {
//    
//    CAShapeLayer *leftLayer = [CAShapeLayer layer];
//    leftLayer.frame = CGRectMake(0, 0, SCREN_WIDTH, 50);
//    leftLayer.lineWidth = 2.0;
//    leftLayer.fillColor = fColor.CGColor;
//    
//    leftLayer.backgroundColor =bgColor.CGColor;
////    leftLayer.strokeColor = [UIColor greenColor].CGColor;
//
//    UIBezierPath *path = [[UIBezierPath alloc] init];
//    [path moveToPoint:CGPointMake(0, 0)];
//    [path addLineToPoint:CGPointMake(SCREN_WIDTH/2, 0)];
//    [path addLineToPoint:CGPointMake(SCREN_WIDTH/2+25, 25)];
//    [path addLineToPoint:CGPointMake(SCREN_WIDTH/2, 50)];
//    [path addLineToPoint:CGPointMake(0, 50)];
//    [path closePath];
//    leftLayer.path = path.CGPath;
//    [self.segmentView.layer insertSublayer:leftLayer atIndex:0];
//    return leftLayer;
//}

- (void)setUpLeftNavbarItem {
//    typeof(self) __weak wself = self;
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
        
    }];
}

//- (void)setUpRightNavbarItem {
//    typeof(self) __weak wself = self;
//    [self setRightNavigationBarButtonItemWithTitle:@"跳过" titleColor:[UIColor whiteColor] andAction:^{
//        [wself.navigationController popToRootViewControllerAnimated:YES];
//    }];
//}

- (IBAction)getVerifyCodeAction:(UIButton*)sender {
    if (![Validator isValidPhone:self.phoneNumberTF.text]) {
        [WJHUD showText:@"输入的手机号格式不正确" onView:self.view];
        return;
    }
    
    typeof(self) __weak wself = self;
    [RequestService getVerifyCodeWithParamDict:@{@"phone":self.phoneNumberTF.text} resultBlock:^(BOOL success, id object) {
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

//- (void)setupIdentificationView {
//    self.registerView.hidden = YES;
//    self.identifyView.hidden = NO;
//    [self setUpRightNavbarItem];
//    [self.segmentLayer removeFromSuperlayer];
//    self.segmentLayer = [self getSegmentLayerWithFrontColor:COLOR_WITH_RGB( 204, 204, 204) backgroundColor:COLOR_WITH_RGB(115, 198, 250)];
//    self.registLabel.textColor = self.identifyLabel.textColor;
//    self.identifyLabel.textColor = [UIColor whiteColor];
//    
//    
//}

- (IBAction)registerAction:(id)sender {
//    [self setupIdentificationView];
    if (![self.verifyCode isEqualToString:self.verificationCodeTF.text]) {
        [WJHUD showText:@"输入的验证码不正确" onView:self.view];
        return;
    }
    
    if (self.passwordTF.text.length<6) {
        [WJHUD showText:@"输入的验证码不正确" onView:self.view];
        return;
    }
    if (self.userNameTF.text.length<2) {
        [WJHUD showText:@"请输入姓名" onView:self.view];
        return;
    }
    if (self.idCardNumberTF.text.length<6) {
        [WJHUD showText:@"请输入身份证号码" onView:self.view];
        return;
    }
    
    NSString *udid = [UDIDManager getUDID];
    
    NSDictionary *paramDict = @{@"phone":self.phoneNumberTF.text,
                                @"verify_code":self.verificationCodeTF.text,
                                @"password":self.passwordTF.text,
                                @"device_id":udid,
                                @"ternimal_type":@"ios",
                                @"name":self.userNameTF.text,
                                @"usercard":self.idCardNumberTF.text
                                };
    typeof(self) __weak wself = self;
    [RequestService registerWithParamDict:paramDict resultBlock:^(BOOL success, id object) {
        if (success) {
            NSDictionary *dataDict = (NSDictionary *)object;
            if ([[dataDict objectForKey:@"code"] integerValue] ==1 ) {
                [self dismissViewControllerAnimated:YES completion:NULL];
//                [GlobalVariableManager manager].userId = [dataDict objectForKey:@"user_id"];
//                [GlobalVariableManager manager].loginToken = [dataDict objectForKey:@"token"];
            }else {
                [WJHUD showText:[dataDict objectForKey:@"message"] onView:wself.view];
            }

        }else {
        
            NSLog(@"object%@", object);
        }
        
    }];
    
}

- (IBAction)applyIdentificationAction:(id)sender {
    
}

@end
