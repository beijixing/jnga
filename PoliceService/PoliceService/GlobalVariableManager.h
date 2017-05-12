//
//  GlobalVariable.h
//  PoliceService
//
//  Created by horse on 2017/3/7.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalVariableManager : NSObject
+(instancetype)manager;

//@property(nonatomic, copy) NSString *reservationDetailTitle;
//@property(nonatomic, assign) NSInteger reservationNoticeGoViewId; //0 ,交管预约页面；1,网上预约列表页
@property(nonatomic, assign) BOOL mapViewShowBackBtn;
@property(nonatomic, copy) NSString *loginToken;
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *phone;
//@property(nonatomic, copy) NSString *reservationBusinessId;
@property(nonatomic, copy) NSString *pswd;

@end
