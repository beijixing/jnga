//
//  NotifiDetailVC.m
//  PoliceService
//
//  Created by fosung on 2017/6/19.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "NotifiDetailVC.h"
#import "WJHUD.h"
#import "RequestService.h"
#import "NotifiDetailCell.h"

@interface NotifiDetailVC ()

@property (strong, nonatomic) NSDictionary *myDic;

@end

@implementation NotifiDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"通知详情";
    [self setUpLeftNavbarItem];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self getData];
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
- (void)getData{
    
    [WJHUD showOnView:self.view];
    [RequestService getNotifiDetailWithParamDict:@{@"id":_notifiID} resultBlock:^(BOOL success, id  _Nullable object) {
           [WJHUD hideFromView:self.view];
           if (success) {
               if (!_myDic) {
                   self.myDic = [NSDictionary new];
               }
               self.myDic = [object objectForKey:@"data"];
           }
           [self.tableView reloadData];
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NotifiDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotifiDetailCellID" forIndexPath:indexPath];
    [cell setContentWithObject:_myDic];
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
