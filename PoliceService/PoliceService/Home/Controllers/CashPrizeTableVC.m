//
//  CashPrizeTableVC.m
//  PoliceService
//
//  Created by fosung on 2017/5/17.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "CashPrizeTableVC.h"
#import "PopoverView.h"
#import "Validator.h"
#import "RequestService.h"
#import "WJHUD.h"

@interface CashPrizeTableVC (){
    NSArray *typeArray;//存放cell
    NSArray *wxArray;
    NSArray *phoneArray;
    NSArray *bankArray;
    NSArray *cashArray;
}
@property (weak, nonatomic) IBOutlet UITextField *wechatTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *bankNameTF;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *cardNumTF;
@property (weak, nonatomic) IBOutlet UITextField *cashCodeTF;
@property (weak, nonatomic) IBOutlet UILabel *acceptTypeLabel;

@end

@implementation CashPrizeTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self setUpLeftNavbarItem];
    [self setupAreaAndClassLabel];
    self.title = @"有奖举报兑奖";
    
    typeArray = @[_cashTypeCell];
    wxArray   = @[_wxTitleCell,_wxAccountCell];
    phoneArray= @[_phoneTitleCell,_phoneNumCell];
    bankArray = @[_bankTitleCell,_bankNameCell,_userNameCell,_bankCardNumCell];
    cashArray = @[_cashTitleCell,_cashPrizeCell,_cutLineCell];
    
    showType = CashPrizeTypeDefault;
    
}
- (void)setUpLeftNavbarItem {
    //    typeof(self) __weak wself = self;
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
        
    }];
}
- (void)setupAreaAndClassLabel {
    self.acceptTypeLabel.font = [UIFont fontWithName:@"iconfont" size:15.0];
    self.acceptTypeLabel.text = @"请选择领奖方式 \U0000E601";

}
- (IBAction)submit:(UITapGestureRecognizer *)sender {
    
    if (showType == CashPrizeTypeWX) {
        if ([Validator isSpaceOrEmpty:self.wechatTF.text]) {
            [WJHUD showText:@"请输入微信号" onView:self.view];
            return;
        }
    }else if (showType == CashPrizeTypePhone){
        if ([Validator isSpaceOrEmpty:self.phoneTF.text]) {
            [WJHUD showText:@"请输入手机号" onView:self.view];
            return;
        }
        
    }else if (showType == CashPrizeTypeBank){
        if ([Validator isSpaceOrEmpty:self.bankNameTF.text]) {
            [WJHUD showText:@"请输入银行名称" onView:self.view];
            return;
        }
        if ([Validator isSpaceOrEmpty:self.userNameTF.text]) {
            [WJHUD showText:@"请输入姓名" onView:self.view];
            return;
        }
        if ([Validator isSpaceOrEmpty:self.cardNumTF.text]) {
            [WJHUD showText:@"请输入卡号" onView:self.view];
            return;
        }
    }
    if ([Validator isSpaceOrEmpty:self.cashCodeTF.text]) {
        [WJHUD showText:@"请输入兑奖密码" onView:self.view];
        return;
    }
    
    [RequestService cashAwardWithParamDict:@{@"verification_code":_cashCodeTF.text ?: @"",
                                             @"award_way":@"",
                                             @"recharge_phone":_phoneTF.text ? :@"",
                                             @"weixinnum":_wechatTF.text ? :@"",
                                             @"bankcard":_cardNumTF.text ? :@"",
                                             @"name":_userNameTF.text ? :@"",
                                             @"phone":_bankNameTF.text ? :@""
                                             } resultBlock:^(BOOL success, id object) {
                                                 if (success) {
                                                     
                                                 }else{
                                                 }
    }];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)chooseType:(UITapGestureRecognizer *)sender {
    NSMutableArray *popOverActions = [[NSMutableArray alloc] init];
    NSArray *titleArr = @[@"微信红包", @"手机号充值", @"银行转账"];
    
    typeof(self) __weak wself = self;
    [titleArr enumerateObjectsUsingBlock:^(NSString  *businessName, NSUInteger idx, BOOL * _Nonnull stop) {
        
        PopoverAction *action = [PopoverAction actionWithTitle:businessName handler:^(PopoverAction *action) {
            NSLog(@"fontName = %@", businessName);
            wself.acceptTypeLabel.text = [NSString stringWithFormat:@"%@ \U0000E601", businessName];
            

            switch (idx) {
                case 0:
                    showType = CashPrizeTypeWX;
                    break;
                case 1:
                  showType = CashPrizeTypePhone;
                    break;
                case 2:
                    showType = CashPrizeTypeBank;
                    break;
                default:
                    break;
            }
            [self.tableView reloadData];
            
        }];
        [popOverActions addObject:action];
    }];
    
    
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.style = PopoverViewStyleDark;
    popoverView.hideAfterTouchOutside = YES; // 点击外部时允许隐藏
    [popoverView showToView:self.acceptTypeLabel withActions:popOverActions];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if (showType == CashPrizeTypeDefault) {
        return 2;
    }
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return indexPath.section !=0 && indexPath.row == 0 ? 30:50;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    switch (showType) {
        case CashPrizeTypeDefault:
        {
            return cashArray.count;
        }
        case CashPrizeTypeWX:
        {
            return section == 1? wxArray.count :cashArray.count;
        }
            break;
        case CashPrizeTypePhone:
        {
            return section == 1? phoneArray.count :cashArray.count;
        }
        case CashPrizeTypeBank:
        {
            return section == 1? bankArray.count :cashArray.count;
        }
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return typeArray[indexPath.row];
    }
    switch (showType) {
        case CashPrizeTypeDefault:
        {
            return cashArray[indexPath.row];
        }
        case CashPrizeTypeWX:
        {
            return indexPath.section == 1? wxArray[indexPath.row] :cashArray[indexPath.row];
        }
            break;
        case CashPrizeTypePhone:
        {
            return indexPath.section == 1? phoneArray[indexPath.row] :cashArray[indexPath.row];
        }
        case CashPrizeTypeBank:
        {
            return indexPath.section == 1? bankArray[indexPath.row] :cashArray[indexPath.row];
        }
    }
    
    return nil;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
