//
//  BusinessPlaceCell.h
//  PoliceService
//
//  Created by fosung on 2017/5/26.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessPlaceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *businessPlaceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *businessPlaceAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *businessPlacePhoneLabel;

-(void)setContentWithObject:(NSDictionary *)dic;

@end
