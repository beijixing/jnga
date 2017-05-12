//
//  UIApplication+CallSystemApp.h
//  PoliceService
//
//  Created by horse on 2017/3/6.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (CallSystemApp)
- (void)callWithViewController:(UIViewController *)vc telNumber:(NSString *)tel;
@end
