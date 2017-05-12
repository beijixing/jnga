//
//  QueryLostMenDetailTableCell.h
//  PoliceService
//
//  Created by horse on 2017/3/1.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QueryLostMenDetailTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *sexLabel;
@property (strong, nonatomic) IBOutlet UILabel *heightLabel;
@property (strong, nonatomic) IBOutlet UILabel *featureLabel;
@property (strong, nonatomic) IBOutlet UILabel *clothesLabel;
@property (strong, nonatomic) IBOutlet UILabel *belongingsLabel;
@property (strong, nonatomic) IBOutlet UILabel *lostAddressLabel;
@property (strong, nonatomic) IBOutlet UILabel *lostTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *policeTelLabel;

@end
