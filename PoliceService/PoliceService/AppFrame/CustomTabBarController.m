//
//  CustomTabBarController.m
//  WoJK
//
//  Created by Megatron on 16/4/14.
//  Copyright (c) 2016年 zhilong. All rights reserved.
//

#import "CustomTabBarController.h"
#import "BlueNavigationController.h"
#import "HomeVC.h"
#import "PoliceWeiboVC.h"
#import "InteractionVC.h"
#import "MemberCenterVC.h"
#import "FSMacro.h"
#import "RecommendVC.h"
#import "PoliceServiceMapVC.h"
@interface CustomTabBarController ()

@end

@implementation CustomTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BlueNavigationController *homeNavi = [[BlueNavigationController alloc] initWithRootViewController:[[HomeVC alloc] init]];
    homeNavi.tabBarItem.title = @"首页";
    homeNavi.tabBarItem.image = [[UIImage imageNamed:@"home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeNavi.tabBarItem.selectedImage = [[UIImage imageNamed:@"home_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    BlueNavigationController *interactionNavi = [[BlueNavigationController alloc] initWithRootViewController:[[RecommendVC alloc] init]];
    interactionNavi.tabBarItem.title = @"推荐应用";
    interactionNavi.tabBarItem.image = [[UIImage imageNamed:@"recomend"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    interactionNavi.tabBarItem.selectedImage = [[UIImage imageNamed:@"recomend_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    BlueNavigationController *policeWeiboNavi = [[BlueNavigationController alloc] initWithRootViewController:[[PoliceServiceMapVC alloc] init]];
    policeWeiboNavi.tabBarItem.title = @"警务地图";
    policeWeiboNavi.tabBarItem.image = [[UIImage imageNamed:@"map"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    policeWeiboNavi.tabBarItem.selectedImage = [[UIImage imageNamed:@"map_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    

    BlueNavigationController *userInfoNavi = [[BlueNavigationController alloc] initWithRootViewController:[[MemberCenterVC alloc] init]];
    userInfoNavi.tabBarItem.title = @"我的";
    userInfoNavi.tabBarItem.image = [[UIImage imageNamed:@"user"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    userInfoNavi.tabBarItem.selectedImage = [[UIImage imageNamed:@"user_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:COLOR_WITH_RGB(160, 160, 160), NSForegroundColorAttributeName, [UIFont fontWithName:@"Helvetica" size:11.0f], NSFontAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:COLOR_WITH_RGB(212, 40, 51), NSForegroundColorAttributeName, [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil] forState:UIControlStateSelected];
    
    self.viewControllers = @[homeNavi, interactionNavi, policeWeiboNavi, userInfoNavi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    UIViewController *currentDisplayVC = [self getCurrentDisplayViewController];
    return [currentDisplayVC shouldAutorotate];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    UIViewController *currentDisplayVC = [self getCurrentDisplayViewController];
    return [currentDisplayVC supportedInterfaceOrientations];
}


-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    UIViewController *currentDisplayVC = [self getCurrentDisplayViewController];
    return [currentDisplayVC preferredInterfaceOrientationForPresentation];
}


- (UIViewController *)getCurrentDisplayViewController {
    if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)self.selectedViewController;
            return [nav.viewControllers lastObject];
    } else {
            return self.selectedViewController;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
