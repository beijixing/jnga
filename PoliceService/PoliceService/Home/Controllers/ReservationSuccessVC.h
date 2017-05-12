//
//  ReservationSuccessVC.h
//  PoliceService
//
//  Created by horse on 2017/3/7.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^QuitBtnActionCallBackBlcok)();
@interface ReservationSuccessVC : UIViewController
@property (nonatomic,copy) QuitBtnActionCallBackBlcok quitBtnActionCallBack;
@end
