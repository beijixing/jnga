//
//  HighWayStatusCell.m
//  PoliceService
//
//  Created by fosung on 2017/6/13.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "HighWayStatusCell.h"

@implementation HighWayStatusCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setContentWithObject:(NSDictionary *)dic{
    self.nameLabel.text = [dic objectForKey:@"title"];
    self.timeLabel.text = [dic objectForKey:@"createTime"];
    self.contentLabel.text = [dic objectForKey:@"content"];
}
@end
