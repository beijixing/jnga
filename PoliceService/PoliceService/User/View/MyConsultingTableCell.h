//
//  MyConsultingTableCell.h
//  PoliceService
//
//  Created by horse on 2017/2/14.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyConsultingTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *consultTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *replyTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
-(void)setContentWithDic:(NSDictionary *)dic;
@end
