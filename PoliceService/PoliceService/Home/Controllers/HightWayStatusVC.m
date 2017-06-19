//
//  HightWayStatusVC.m
//  PoliceService
//
//  Created by fosung on 2017/5/17.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "HightWayStatusVC.h"
#import "RequestService.h"
#import "WJHUD.h"
#import "MJRefresh.h"
#import "HighWayStatusCell.h"

@interface HightWayStatusVC ()<UITableViewDelegate,UITableViewDataSource>{
    int page;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation HightWayStatusVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"高速路况";
    [self.tableView registerNib:[UINib nibWithNibName:@"HighWayStatusCell" bundle:nil] forCellReuseIdentifier:@"HighWayStatusCellID"];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.tableView.mj_footer resetNoMoreData];
        page = 1;
        [self getStatus];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [self getStatus];
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

-(void)getStatus{
    
    [WJHUD showOnView:self.view];
    [RequestService checkHightWayStatusWithParamDict:@{@"pageSize":@10,
                                                       @"pageNo":[NSString stringWithFormat:@"%d",page]}
                                         resultBlock:^(BOOL success, id  _Nullable object) {
                                             [WJHUD hideFromView:self.view];
                                             if (success) {
                                                 NSDictionary *dic = [object objectForKey:@"data"];
                                                 if (![[dic objectForKey:@"list"] isEqual:@""]) {
                                                     NSMutableArray *listAry = [dic objectForKey:@"list"];
                                                     
                                                     if (page == 1) {
                                                         if (!_dataArray) {
                                                             self.dataArray = [NSMutableArray new];
                                                         }
                                                         
                                                         self.dataArray = [listAry mutableCopy];
                                                         
                                                     }else{
                                                         [self.dataArray addObjectsFromArray:listAry];
                                                     }
                                                 }else{
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
    
    HighWayStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HighWayStatusCellID" forIndexPath:indexPath];
    [cell setContentWithObject:_dataArray[indexPath.row]];
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
