//
//  AppSquareHeaderView.h
//  PoliceService
//
//  Created by horse on 2017/2/17.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HeaderTapAction)();
@interface AppSquareHeaderView : UICollectionReusableView
@property (nonatomic, copy) HeaderTapAction tapAction;
@property (strong, nonatomic) UILabel *titleLabel;
@end
