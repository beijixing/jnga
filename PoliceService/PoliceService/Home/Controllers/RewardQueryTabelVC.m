//
//  RewardQueryTabelVC.m
//  PoliceService
//
//  Created by fosung on 2017/5/17.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "RewardQueryTabelVC.h"
#import "Validator.h"
#import "RequestService.h"
#import "WJHUD.h"
#import "CashPrizeTableVC.h"
@interface RewardQueryTabelVC ()
@property (weak, nonatomic) IBOutlet UITextField *acceptNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *acceptCodeTF;

@end

@implementation RewardQueryTabelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self setUpLeftNavbarItem];
    self.title = @"有奖举报查询";
}
- (void)setUpLeftNavbarItem {
    //    typeof(self) __weak wself = self;
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)submit:(id)sender {
    
    if ([Validator isSpaceOrEmpty:self.acceptNumberTF.text]) {
        [WJHUD showText:@"请输入受理编号" onView:self.view];
        return;
    }
    
    [RequestService queryAwardWithParamDict:
     @{@"verificationCode":_acceptNumberTF.text
       } resultBlock:^(BOOL success, id object) {
           [self delMessageWithObject:object withStatus:success];
       }];
    
}
-(void)delMessageWithObject:(id)object withStatus:(BOOL)success{
    
    NSString *des = [object objectForKey:@"message"];
    NSDictionary *dataDic = [object objectForKey:@"data"];
    
//    BOOL isTrue = [dataDic objectForKey:@"isNewRecord"];
    if (success) {
        if ([dataDic objectForKey:@"auditOption"] != NULL && ![[dataDic objectForKey:@"auditOption"] isEqualToString:@""]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:des preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *goCash = [UIAlertAction actionWithTitle:@"去兑奖" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self performSegueWithIdentifier:@"PushToCashPrize" sender:nil];
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:goCash];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您的举报未被审核采纳或未达到奖励标准,请再接再厉哦~" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
