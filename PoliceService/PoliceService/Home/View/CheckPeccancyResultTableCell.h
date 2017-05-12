//
//  CheckPeccancyResultTableCell.h
//  PoliceService
//
//  Created by horse on 2017/3/2.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckPeccancyResultTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *reasonLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *resultLabel;

@end
