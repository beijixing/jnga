//
//  AppDelegate.m
//  PoliceApp
//
//  Created by horse on 16/9/8.
//  Copyright © 2016年 zgl. All rights reserved.
//

#import "AppDelegate.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "IQKeyboardManager.h"
#import "CustomTabBarController.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "Constant.h"
BMKMapManager* _mapManager;
@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"zPm6LfKIVxU5Vus2K9FoeGKnMR8h58ji" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    [WXApi registerApp:WeiXinKey];
    [[TencentOAuth alloc] initWithAppId:QQKey andDelegate:nil]; //注册
    [self performSelector:@selector(testLog) withObject:nil afterDelay:3];
    [IQKeyboardManager sharedManager].enable = YES;
    self.window.rootViewController = [[CustomTabBarController alloc] init];
    return YES;
}

- (void) testLog
{
    NSLog(@"startstart");
    for (int i = 0; i < 1; i++)
    {
        [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"wx795fbcef1070b5be://%d",i]]];
    }
    NSLog(@"sss1111:%@", [NSString stringWithFormat:@"%d",[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"wx795fbcef1070b5be://sss"]]]]);
}
#pragma mark - wx
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    if ([[NSString stringWithFormat:@"%@",url] rangeOfString:WeiXinKey].location !=NSNotFound) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    if ([[NSString stringWithFormat:@"%@",url] rangeOfString:QQKey].location !=NSNotFound) {
       return [TencentOAuth HandleOpenURL:url];
    }
    return YES;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([[NSString stringWithFormat:@"%@",url] rangeOfString:WeiXinKey].location !=NSNotFound) {
       return [WXApi handleOpenURL:url delegate:self];
    }
    if ([[NSString stringWithFormat:@"%@",url] rangeOfString:QQKey].location !=NSNotFound) {
      return [TencentOAuth HandleOpenURL:url];
    }
    return YES;
}
- (BOOL)application:(UIApplication*)application openURL:(NSURL *)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation{
    
    return[TencentOAuth HandleOpenURL:url];
    
}
- (void)onResp:(BaseResp *)resp {
    NSString *strResult = nil;
    if (resp.errCode == 0) {
        strResult = @"分享成功";
    }else if(resp.errCode == -2) {
        strResult = @"取消分享";
    }else{
        strResult = @"分享失败";
    }
    
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"分享结果" message:strResult delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [alertview show];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
