//
//  MyAppointmentVC.m
//  PoliceService
//
//  Created by horse on 2017/2/14.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "MyAppointmentVC.h"
#import "FSMacro.h"
#import "MyAppointmentTableCell.h"
#import "MyAppointmentDetailVC.h"
#import "WJHUD.h"
#import "GlobalVariableManager.h"
#import "GlobalFunctionManager.h"
#import "RequestService.h"
#import "MJRefresh.h"
#import "MyAppointmentDataModel.h"
@interface MyAppointmentVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSArray *statusDataArr;
@property(nonatomic, assign) NSInteger pageCount;
@property(nonatomic, strong) MyAppointmentDataModel *dataModel;

@end
NSString *apCellIdentifer = @"cell";
@implementation MyAppointmentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的预约";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpLeftNavbarItem];
    [self.view addSubview:self.mainTableView];
    [self getServerData];
}
- (void)setUpLeftNavbarItem {
//    typeof(self) __weak wself = self;
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
        
    }];
}

- (void)getServerData {
    /*
     pageNo String 页号
     pageSize String 页大小
     userId String 预约记录id
     */
    typeof(self) __weak wself = self;
    [WJHUD showOnView:self.view];
    [RequestService getUserBookingListWithParamDict:@{@"pageNo":@1,
                                                      @"pageSize":@10,
                                                      @"userId":[GlobalVariableManager manager].userId
                                                      } resultBlock:^(BOOL success, id object)
    {
        NSLog(@"object = %@", object);
        [WJHUD hideFromView:wself.view];
        [GlobalFunctionManager handleServerDataWithController:wself result:success dataObj:object successBlock:^{
            if (!wself.dataModel) {
                NSError *error;
                wself.dataModel = [[MyAppointmentDataModel alloc] initWithDictionary:[object objectForKey:@"data"] error:&error];
                NSLog(@"error=%@", error);
            }else {
                MyAppointmentDataModel *tmpDataModel = [[MyAppointmentDataModel alloc] initWithDictionary:[object objectForKey:@"data"] error:nil];
                [wself.dataModel.list addObjectsFromArray:tmpDataModel.list];
            }
            
            if (wself.dataModel.list.count == wself.dataModel.count) {
                [wself.mainTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [wself.mainTableView.mj_footer endRefreshing];
            }
            [wself.mainTableView reloadData];
        }];
        
    }];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataModel.list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:apCellIdentifer];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark  UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100*KSCALE;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyAppointmentTableCell *showCell = (MyAppointmentTableCell*)cell;
    MyAppointmentItemModel *dModel = self.dataModel.list[indexPath.row];
    showCell.titleLabel.text = dModel.depart.name;
    showCell.resultLabel.text = self.statusDataArr[dModel.status-1];
    showCell.typeLbel.text = dModel.businessType;
    showCell.appointTimeLabel.text = dModel.bookDate;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MyAppointmentDetailVC *detailVc = [[MyAppointmentDetailVC alloc] init];
    MyAppointmentItemModel *dModel = self.dataModel.list[indexPath.row];
    detailVc.itemModel = dModel;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVc animated:YES];
}

-(UITableView *)mainTableView {
    if(_mainTableView){
        return _mainTableView;
    }
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, SCREN_HEIGHT-44) style:UITableViewStylePlain];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.backgroundColor = COLOR_WITH_RGB(240, 244, 249);
    typeof(self) __weak wself = self;
    [_mainTableView registerNib:[UINib nibWithNibName:@"MyAppointmentTableCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:apCellIdentifer];
    //    [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:mycellIdentifier];
    _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        wself.pageCount++;
        [wself getServerData];
    }];
    return _mainTableView;
}

-(NSArray *)statusDataArr {
    if (_statusDataArr) {
        return _statusDataArr;
    }
    _statusDataArr = @[@"正在预约", @"处理中", @"处理完成", @"取消预约"];
    
    return _statusDataArr;

}
@end
