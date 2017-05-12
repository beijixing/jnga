//
//  PoliceMapTableCell.m
//  PoliceService
//
//  Created by horse on 2017/2/22.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "PoliceMapTableCell.h"

@implementation PoliceMapTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *teltap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(telAction:)];
    [self.tellLabel addGestureRecognizer:teltap];
    
    UITapGestureRecognizer *locationTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationTapAction:)];
    [self.mapTipImageView addGestureRecognizer:locationTap];
    
    UITapGestureRecognizer *navigationTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navigationTapAction:)];
    [self.navigationTipView addGestureRecognizer:navigationTap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)telAction:(UITapGestureRecognizer *)sender {
    if (self.telCallBack) {
        self.telCallBack();
    }
}

- (void)locationTapAction:(UITapGestureRecognizer *)sender {
    if (self.showMapCallBack) {
        self.showMapCallBack();
    }
}

- (void)navigationTapAction:(UITapGestureRecognizer *)sender {
    if (self.navigationCallBack) {
        self.navigationCallBack();
    }
}
@end
