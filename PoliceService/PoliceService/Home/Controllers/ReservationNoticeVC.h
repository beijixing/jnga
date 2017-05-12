//
//  ReservationNoticeVC.h
//  PoliceService
//
//  Created by horse on 2017/3/7.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^NoticeAgreeCallBackBlcok)();
@interface ReservationNoticeVC : BaseViewController
@property (nonatomic,copy) NoticeAgreeCallBackBlcok noticeAgreeCallBackBlcok;
@end
