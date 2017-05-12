//
//  MyBusinessTableCell.m
//  PoliceService
//
//  Created by horse on 2017/2/14.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "MyBusinessTableCell.h"
#import "UITableViewCell+TableDataBase.h"

@implementation MyBusinessTableCell

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
        self.titleLabel.text = entity;
    }
}

@end
