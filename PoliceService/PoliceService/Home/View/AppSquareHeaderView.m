//
//  AppSquareHeaderView.m
//  PoliceService
//
//  Created by horse on 2017/2/17.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "AppSquareHeaderView.h"
#import "UIFactory.h"
#import "FSMacro.h"
@implementation AppSquareHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_WITH_RGB(240, 244, 249);
        [self addSubview:self.titleLabel];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTapAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (_titleLabel) {
        return _titleLabel;
    }
    _titleLabel = [UIFactory createLabelWith:CGRectZero textColor:[UIColor blackColor] text:@""];
    _titleLabel.font = [UIFont fontWithName:@"Arial" size:14.0];
    return _titleLabel;
}

-(void)layoutSubviews {
    self.titleLabel.frame = CGRectMake(15, 0, self.frame.size.width-30, self.frame.size.height);
}


- (void)selfTapAction {
    if (self.tapAction) {
        self.tapAction();
    }
}

@end
