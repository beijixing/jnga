//
//  FSMacro.h
//  E-attendance
//
//  Created by Kevin on 14-9-19.
//  Copyright (c) 2014年 bitwayapp. All rights reserved.
//

#ifndef E_attendance_FSMacro_h
#define E_attendance_FSMacro_h

#define IS_PAD [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad
#define IS_PHONE [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone

#ifdef DEBUG
#define DLOG(format, ...) NSLog((@"%s [Line %d]" format), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DEBUG_LOG(format, ...)
#endif

// ---------------------------------------------
#pragma mark -目录相关
#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

// ---------------------------------------------
#pragma mark -颜色相关
#define COLOR_WITH_RGB(R,G,B) [UIColor colorWithRed:(R/255.0f) green:(G/255.0f) blue:(B/255.0f) alpha:1.0f]
#define COLOR_WITH_RGBA(R,G,B,A) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]
#define MAIN_COLOR  COLOR_WITH_RGB(61,161,230)

// -------------取得AppDelegate单例--------------
#define SHARED_DELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])

// ---------------------------------------------
#pragma mark  - UI相关
#define SCREN_HEIGHT  [[UIScreen mainScreen] bounds].size.height
#define SCREN_WIDTH   [[UIScreen mainScreen] bounds].size.width



// ---------------------------------------------
#pragma mark  - 帮助宏
#define ABOVE_IOS7_1 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.1)
#define ABOVE_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define ABOVE_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)

#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 9.0)
#define iOS_VERSION [[[UIDevice currentDevice] systemVersion] doubleValue]

//按照640x1136的屏幕大小作为标准分辨率来适配
#define KSCALE SCREN_WIDTH/550

#endif
