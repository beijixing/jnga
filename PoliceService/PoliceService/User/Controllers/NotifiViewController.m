//
//  NotifiViewController.m
//  PoliceService
//
//  Created by fosung on 2017/6/19.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "NotifiViewController.h"
#import "NotifiTableCell.h"
#import "WJHUD.h"
#import "RequestService.h"
#import "MJRefresh.h"
#import "NotifiDetailVC.h"
@interface NotifiViewController (){
    int page;
}
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation NotifiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"通知公告";
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self.tableView.mj_footer resetNoMoreData];
        [self getData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [self getData];
    }];
    [self.tableView.mj_header beginRefreshing];
    [self setUpLeftNavbarItem];
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

-(void)getData{
    [WJHUD showOnView:self.view];
    [RequestService getNotifiListWithParamDict:
     @{@"pageNo":[NSString stringWithFormat:@"%d",page],
       @"pageSize":@"10"} resultBlock:^(BOOL success, id  _Nullable object) {
           [WJHUD hideFromView:self.view];
        if (success) {
            NSDictionary *dic = [object objectForKey:@"data"];
            if (![[dic objectForKey:@"list"] isEqual:@""]) {
                NSMutableArray *contentAry = [dic objectForKey:@"list"];
                if (contentAry.count>0) {
                    
                    if (page == 1) {
                        if (!_dataArray) {
                            self.dataArray  = [NSMutableArray new];
                        }
                        self.dataArray = [contentAry mutableCopy];
                    }else{
                        [self.dataArray addObjectsFromArray:contentAry];
                    }
                    
                }
            }else{
                page--;
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
           if ([self.tableView.mj_header isRefreshing]) {
               [self.tableView.mj_header endRefreshing];
           }
           if ([self.tableView.mj_footer isRefreshing]) {
               [self.tableView.mj_footer endRefreshing];
           }
           [self.tableView reloadData];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NotifiTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotifiTableCellID" forIndexPath:indexPath];
    [cell setContentWithObject:_dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _dataArray[indexPath.row];
    NSString *idString = [dic objectForKey:@"id"];
    [self performSegueWithIdentifier:@"PushToDetail" sender:idString];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"PushToDetail"]) {
        NotifiDetailVC *vc = segue.destinationViewController;
        vc.notifiID = sender;
    }
}


@end
