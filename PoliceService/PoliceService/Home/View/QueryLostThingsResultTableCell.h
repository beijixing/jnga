//
//  QueryLostThingsResultTableCell.h
//  PoliceService
//
//  Created by horse on 2017/3/2.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QueryLostThingsResultTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *sexLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTV;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *telLabel;

@end
