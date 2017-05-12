//
//  GlobalFunctionManager.m
//  PoliceService
//
//  Created by horse on 2017/3/10.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "GlobalFunctionManager.h"
//#import "ReservationNoticeVC.h"
#import "GlobalVariableManager.h"
#import "LoginVC.h"
#import "SimilarNameQueryVC.h"
#import "UIApplication+CallSystemApp.h"
#import "WJHUD.h"
#import "RequestService.h"
#import "SuggestionVC.h"
@implementation GlobalFunctionManager
//+(instancetype)manager {
//    static GlobalFunctionManager *manager;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        manager = [[GlobalFunctionManager alloc] init];
//    });
//    return manager;
//}

+(void)pushReservationSubViewWithViewController:(UIViewController *)vc {
    [self pushViewControllerWithName:@"ReservationNoticeVC" from:vc];
}

+(void)presentLoginViewWithViewController:(UIViewController *)vc {
    LoginVC *loginVc = [[LoginVC alloc] init];
    [vc presentViewController:loginVc animated:YES completion:^{
        
    }];
}

+(void)pushQuerySubviewWithController:(UIViewController *)vc switchId:(NSInteger)idx {
    switch (idx) {
        case 0:
        {
            [self pushViewControllerWithName:@"SimilarNameQueryVC" from:vc];
        }
            break;
        case 1:
        {
            [self pushViewControllerWithName:@"QueryLostMenVC" from:vc];
        }
            break;
        case 2:
        {
            [self pushViewControllerWithName:@"QueryLostThingsVC" from:vc];
        }
            break;
            
        case 3:
        {
            [self pushViewControllerWithName:@"CheckOpenCaseVC" from:vc];
        }
            break;
            
        case 4:
        {
            [self pushViewControllerWithName:@"CheckPeccancyVC" from:vc];
        }
            break;
            
        case 5:
        {
            [self pushViewControllerWithName:@"QueryDriverPeccancyVC" from:vc];
        }
            break;
            
        case 6:
        {
            [GlobalVariableManager manager].mapViewShowBackBtn = YES;
            [self pushViewControllerWithName:@"PoliceServiceMapVC" from:vc];
        }
            break;
            
        default:
            break;
    }
}

+(void)pushPeopleAppealSubviewWithController:(UIViewController *)vc switchId:(NSInteger)idx {
    switch (idx) {
        case 0:{
            [[UIApplication sharedApplication] callWithViewController:vc telNumber:@"9600110"];
        }
            break;
        case 1:
        {
            [self pushSuggestionVCViewControllerWithTitle:@"我要举报" dataType:@"1" from:vc];
        }
            break;
        case 2:
        {
            [self pushSuggestionVCViewControllerWithTitle:@"我要建议" dataType:@"2" from:vc];
           
        }
            break;
        case 3:
        {
            [self pushSuggestionVCViewControllerWithTitle:@"我要投诉" dataType:@"3" from:vc];
        }
            break;
        case 4:
        {
            [self pushSuggestionVCViewControllerWithTitle:@"我要咨询" dataType:@"4" from:vc];
        }
            break;
        case 5:
        {
            [self pushSuggestionVCViewControllerWithTitle:@"我要信访" dataType:@"5" from:vc];
        }
            break;
        case 6:
        {
            [self pushViewControllerWithName:@"CommentPoliceVC" title:@"我要评警" from:vc];
        }
            break;
            
        default:
            break;
    }

}

+ (void)pushSuggestionVCViewControllerWithTitle:(NSString *)title dataType:(NSString *)dataType from:(UIViewController *)vc{
    SuggestionVC *pushVc = [[NSClassFromString(@"SuggestionVC") alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    pushVc.dataType = dataType;
    pushVc.title = title;
    [vc.navigationController pushViewController:pushVc animated:YES];
}


+ (void)pushViewControllerWithName:(NSString *)controllerName from:(UIViewController *)vc{
    UIViewController *pushVc = [[NSClassFromString(controllerName) alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [vc.navigationController pushViewController:pushVc animated:YES];
}

+ (void)pushViewControllerWithName:(NSString *)controllerName title:(NSString *)title from:(UIViewController *)vc{
    UIViewController *pushVc = [[NSClassFromString(controllerName) alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    pushVc.title = title;
    [vc.navigationController pushViewController:pushVc animated:YES];
}

+(void)handleServerDataWithController:(UIViewController *)vc result:(BOOL)result dataObj:(id)data successBlock:(void(^)())sucessCallback {
    if (result) {
        NSDictionary *dataDict = (NSDictionary *)data;
        if ([dataDict objectForKey:@"code"]) {
            sucessCallback();
        }else {
            [WJHUD showText:[dataDict objectForKey:@"message"] onView:vc.view];
        }
    }else {
        NSLog(@"object=%@", data);
    }
}

+(void)checkVersionOnViewController:(UIViewController *)vc {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    typeof(vc) __weak wvc = vc;
    typeof(self) __weak wself = self;
    [RequestService getAppVersionInfoWithParamDict:@{@"appname":@"济宁公安",
                                                         @"appversion":appVersion,
                                                         @"appostype":@"ios"} resultBlock:^(BOOL success, id object)
    {
      [wself handleServerDataWithController:wvc result:success dataObj:object successBlock:^{
               NSLog(@"object = %@", object);
          NSDictionary *dataDict = object[@"data"];
          [wself showVersionInfo:dataDict onVC:wvc];
      }];
    }];
}

+ (void)showVersionInfo:(NSDictionary *)info onVC:(UIViewController *)vc {
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *des = info[@"description"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"版本检测" message:des preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *status = info[@"status"];
        if ([status floatValue] > 0) {
            NSString *appDownloadUrl = info[@"url"];
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:appDownloadUrl]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appDownloadUrl]];
            }
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    [vc presentViewController:alertController animated:YES completion:^{
    }];
}

+(void)autoLoginOrLoginOnViewController:(UIViewController *)vc callBack:(void(^)())callBack {
    typeof(self) __weak wself = self;
    typeof(vc) __weak wvc = vc;
    [WJHUD showOnView:vc.view];
    [RequestService autoLoginWithResultBlock:^(BOOL success, id object) {
        [WJHUD hideFromView:wvc.view];
        [wself handleServerDataWithController:wvc result:success dataObj:object successBlock:^{
            NSString *code = object[@"code"];
            if ([code isEqualToString:@"1"]) {
                [GlobalVariableManager manager].loginToken = object[@"token"];
                [GlobalVariableManager manager].userId = object[@"user_id"];
                [GlobalVariableManager manager].phone = object[@"phone"];
                //自动登录成功，
                callBack();
            }else{
                //否则重新登录
                LoginVC *loginVc = [[LoginVC alloc] init];
                loginVc.loginSuccessCallback = ^() {
                    callBack();
                };
                [wvc presentViewController:loginVc animated:YES completion:^{
                    
                }];
            }
        }];
    }];

}

@end
