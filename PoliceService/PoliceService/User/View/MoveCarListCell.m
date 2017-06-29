//
//  MoveCarListCell.m
//  PoliceService
//
//  Created by fosung on 2017/6/28.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "MoveCarListCell.h"

@implementation MoveCarListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setContentWithDic:(NSDictionary *)dic{
    
    self.carNumLabel.text = [NSString stringWithFormat:@"车牌号：鲁%@",[dic objectForKey:@"cphm"]];
    self.timeLabel.text = [dic objectForKey:@"createTime"];
    self.addressLabel.text = [dic objectForKey:@"address"];
}
@end
