//
//  MemberCenterCell.m
//  PoliceService
//
//  Created by horse on 2017/2/10.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "MemberCenterCell.h"
#import "UITableViewCell+TableDataBase.h"
@implementation MemberCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configCellWithEntity:(id)entity {
    if (entity) {
        NSDictionary *dataDict = (NSDictionary *)entity;
        self.titleLabel.text = dataDict[@"title"];
        self.iconImageView.image = [UIImage imageNamed:dataDict[@"icon"]];
    }
}

@end
