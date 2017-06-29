//
//  MoveCarListCell.h
//  PoliceService
//
//  Created by fosung on 2017/6/28.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoveCarListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *carNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

-(void)setContentWithDic:(NSDictionary *)dic;

@end
