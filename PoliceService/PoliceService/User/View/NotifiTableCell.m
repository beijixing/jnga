//
//  NotifiTableCell.m
//  PoliceService
//
//  Created by fosung on 2017/6/19.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "NotifiTableCell.h"

@implementation NotifiTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setContentWithObject:(NSDictionary *)dic{
    self.titleLabel.text = [dic objectForKey:@"title"];
    self.timeLabel.text = [dic objectForKey:@"createDate"];
}
@end
