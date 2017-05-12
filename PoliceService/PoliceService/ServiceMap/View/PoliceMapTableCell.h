//
//  PoliceMapTableCell.h
//  PoliceService
//
//  Created by horse on 2017/2/22.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PoliceMapTableCellEventCallBack)(void);

@interface PoliceMapTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *subbureauNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *mapTipImageView;
@property (strong, nonatomic) IBOutlet UIView *navigationTipView;
@property (strong, nonatomic) IBOutlet UILabel *tellLabel;
@property (strong, nonatomic) IBOutlet UIImageView *telImageView;
@property (strong, nonatomic) IBOutlet UILabel *specificPositionLabel;
@property (copy, nonatomic) PoliceMapTableCellEventCallBack telCallBack;
@property (copy, nonatomic) PoliceMapTableCellEventCallBack showMapCallBack;
@property (copy, nonatomic) PoliceMapTableCellEventCallBack navigationCallBack;
@end
