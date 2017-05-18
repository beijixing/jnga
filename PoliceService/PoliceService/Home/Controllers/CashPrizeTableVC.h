//
//  CashPrizeTableVC.h
//  PoliceService
//
//  Created by fosung on 2017/5/17.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "BaseTableViewController.h"

typedef enum _CashPrizeType {
    CashPrizeTypeWX  = 0,
    CashPrizeTypePhone,
    CashPrizeTypeBank,
    CashPrizeTypeDefault
} CashPrizeType;

@interface CashPrizeTableVC : BaseTableViewController{
    CashPrizeType showType;
}
@property (weak, nonatomic) IBOutlet UITableViewCell *cashTypeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *wxTitleCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *wxAccountCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *phoneTitleCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *phoneNumCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *bankTitleCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *bankNameCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *userNameCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *bankCardNumCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *cashTitleCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *cashPrizeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *cutLineCell;
@end
