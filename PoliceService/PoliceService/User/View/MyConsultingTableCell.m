//
//  MyConsultingTableCell.m
//  PoliceService
//
//  Created by horse on 2017/2/14.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "MyConsultingTableCell.h"

@implementation MyConsultingTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setContentWithDic:(NSDictionary *)dic{
    self.titleLabel.text = @"";
    self.consultTimeLabel.text = @"";
    self.replyTimeLabel.text = @"";
    self.nameLabel.text = @"";
}
@end
