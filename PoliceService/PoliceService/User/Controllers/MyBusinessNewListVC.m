//
//  MyBusinessNewListVC.m
//  PoliceService
//
//  Created by fosung on 2017/6/28.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "MyBusinessNewListVC.h"
#import "RequestService.h"
#import "WJHUD.h"
#import "GlobalVariableManager.h"
#import "UDIDManager.h"
#import "MJRefresh.h"
#import "MoveCarListCell.h"

@interface MyBusinessNewListVC (){
    int page;
}
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation MyBusinessNewListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"移车服务列表";
    [self setUpLeftNavbarItem];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyBusinessTableCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MyBusinessTableCellID"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page=1;
        [self.tableView.mj_footer resetNoMoreData];
        [self getData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [self getData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
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
    
    [RequestService getMoveCarListWithParamDict:
     @{
       @"myphone":[GlobalVariableManager manager].phone,
       @"pageNo":[NSString stringWithFormat:@"%d",page],
       @"pageSize":@"10"
       } resultBlock:^(BOOL success, id  _Nullable object) {
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
           [self.tableView reloadData];
           if ([self.tableView.mj_header isRefreshing]) {
               [self.tableView.mj_header endRefreshing];
           }
           
           if ([self.tableView.mj_footer isRefreshing]) {
               [self.tableView.mj_footer endRefreshing];
           }
       }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MoveCarListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoveCarListCellID" forIndexPath:indexPath];
    [cell setContentWithDic:_dataArray[indexPath.row]];
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
