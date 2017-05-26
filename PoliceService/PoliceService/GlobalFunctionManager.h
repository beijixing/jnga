//
//  GlobalFunctionManager.h
//  PoliceService
//
//  Created by horse on 2017/3/10.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class OperationItemModel;
@interface GlobalFunctionManager : NSObject
//+(instancetype)manager;

+(void)pushReservationSubViewWithViewController:(UIViewController *)vc;
+(void)presentLoginViewWithViewController:(UIViewController *)vc;
+(void)pushQuerySubviewWithController:(UIViewController *)vc switchId:(NSInteger)idx;
+(void)pushPeopleAppealSubviewWithController:(UIViewController *)vc switchId:(NSInteger)idx;

+(void)handleServerDataWithController:(UIViewController *)vc result:(BOOL)result dataObj:(id)data successBlock:(void(^)())sucessCallback;
+(void)checkVersionOnViewController:(UIViewController *)vc;
//自动登录或者跳转到登录页面登录
+(void)autoLoginOrLoginOnViewController:(UIViewController *)vc callBack:(void(^)())callBack;

+(void)pushViewControllerWithItem:(OperationItemModel *)item fromVC:(UIViewController *)vc;

/**
 页面跳转

 @param controllerName 页面类名
 @param dict 页面参数
 @param vc 来自页面对象
 */
+ (void)pushViewControllerWithName:(NSString *)controllerName pagram:(NSDictionary *)dict fromVC:(UIViewController *)vc;
@end
