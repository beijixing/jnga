//
//  MyAppointment2Cell.h
//  PoliceService
//
//  Created by fosung on 2017/6/22.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAppointment2Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *appointBusinessLabel;
@property (weak, nonatomic) IBOutlet UILabel *appointTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UILabel *appointTimeQuantumLabel;

@end
