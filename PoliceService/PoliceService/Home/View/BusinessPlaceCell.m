//
//  BusinessPlaceCell.m
//  PoliceService
//
//  Created by fosung on 2017/5/26.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "BusinessPlaceCell.h"

@implementation BusinessPlaceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setContentWithObject:(NSDictionary *)dic{
    self.businessPlaceNameLabel.text = [dic objectForKey:@"name"];
    self.businessPlaceAddressLabel.text = [dic objectForKey:@"address"];
    self.businessPlacePhoneLabel.text = [dic objectForKey:@"tel"];
}

@end
