//
//  DeedsCell.h
//  PoliceApp
//
//  Created by horse on 16/9/26.
//  Copyright © 2016年 zgl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeedsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *iconWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomMarginConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topMarginConstraint;

@end
