//
//  MyAppointment2Cell.m
//  PoliceService
//
//  Created by fosung on 2017/6/22.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "MyAppointment2Cell.h"

@implementation MyAppointment2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setContentWithDic:(NSDictionary *)dic{
    
    self.appointBusinessLabel.text = [dic objectForKey:@"fbusioness"];
    self.appointTimeLabel.text = [dic objectForKey:@"fdate"];
    self.progressLabel.text = [dic objectForKey:@"fstate"];
    self.appointTimeQuantumLabel.text = [dic objectForKey:@"fperiod"];
}

@end
