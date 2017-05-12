//
//  GesturePasswordView.h
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TentacleView.h"

@protocol GesturePasswordDelegate <NSObject>

- (void)forget;
- (void)change;

@end

@interface GesturePasswordView : UIView<TouchBeginDelegate, TouchEndDelegate>

@property (nonatomic,strong) TentacleView * tentacleView;

@property (nonatomic,strong) UILabel * state;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic,weak) id<GesturePasswordDelegate> gesturePasswordDelegate;

@property (nonatomic,strong) UIImageView * headIconImgView;
@property (nonatomic,strong) UIButton * forgetButton;
@property (nonatomic,strong) UIButton * changeButton;

@end
