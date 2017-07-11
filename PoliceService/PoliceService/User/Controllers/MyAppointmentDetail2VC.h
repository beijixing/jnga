//
//  MyAppointmentDetail2VC.h
//  PoliceService
//
//  Created by fosung on 2017/6/28.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "BaseViewController.h"

@interface MyAppointmentDetail2VC : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *policeStationLabel;
@property (weak, nonatomic) IBOutlet UILabel *appointmentBusinessLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyTimeLabel;
@property (weak, nonatomic) IBOutlet UITextView *replyContentTextView;

@property (copy, nonatomic) NSString *detailID;

@end
