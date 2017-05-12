//
//  LoginVC.h
//  PoliceService
//
//  Created by horse on 2017/2/10.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef void(^LoginSuccessCallbackBlock)();
@interface LoginVC : BaseViewController
@property (strong, nonatomic) IBOutlet UITextField *phoneTF;
@property (strong, nonatomic) IBOutlet UITextField *passwdTF;
@property (strong, nonatomic) IBOutlet UIButton *forgetPasswdBtn;
@property (nonatomic,copy) LoginSuccessCallbackBlock loginSuccessCallback;
@end
