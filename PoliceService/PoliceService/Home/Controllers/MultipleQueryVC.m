//
//  MultipleQueryVC.m
//  PoliceService
//
//  Created by horse on 2017/2/20.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "MultipleQueryVC.h"
#import "FSMacro.h"
#import "ReservationOnlineTableCell.h"
#import "SimilarNameQueryVC.h"
#import "CheckOpenCaseVC.h"
#import "MultipleQueryDataModel.h"
#import "QueryLostMenVC.h"
#import "QueryDriverPeccancyVC.h"
#import "QueryLostThingsVC.h"
#import "CheckPeccancyVC.h"
#import "PoliceServiceMapVC.h"
#import "GlobalFunctionManager.h"
@interface MultipleQueryVC ()<UITableViewDelegate, UITableViewDataSource >
@property(nonatomic, strong)UITableView *mainTableView;
@property(nonatomic, strong) NSArray *titleArr;
@property(nonatomic, strong) MultipleQueryDataModel *dataModel;
@end

@implementation MultipleQueryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"综合查询";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpLeftNavbarItem];
    [self.view addSubview:self.mainTableView];
}

- (void)setUpLeftNavbarItem {
    typeof(self) __weak wself = self;
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
        
    }];
}
#pragma mark - UITableviewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataModel.datas.count;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    ReservationOnlineTableCell* showCell = (ReservationOnlineTableCell*)cell;
    OperationItemModel *dModel = self.dataModel.datas[indexPath.row];
    showCell.titleLabel.text = dModel.operate_name;
    showCell.iconImageView.image = [UIImage imageNamed:dModel.img_url];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.view.frame.size.height > 568) {
        return 80*KSCALE;
    }else {
        return 50;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [GlobalFunctionManager pushQuerySubviewWithController:self switchId:indexPath.row];
}


#pragma mark - PrivateMethods
- (UITableView *)mainTableView {
    if (_mainTableView) {
        return _mainTableView;
    }
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREN_WIDTH, SCREN_HEIGHT-64) style:UITableViewStylePlain];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.backgroundColor = COLOR_WITH_RGB(240, 244, 249);
    [_mainTableView registerNib:[UINib nibWithNibName:@"ReservationOnlineTableCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    return _mainTableView;
}

-(NSArray *)titleArr {
    if (_titleArr) {
        return _titleArr;
    }
    _titleArr = @[@"重名查询", @"走失人口查询", @"失物招领、挂失查询", @"执法办案公开查询", @"机动车违法信息查询", @"驾驶人交通那个违法查询", @"警务地图"];
    return _titleArr;
}

-(MultipleQueryDataModel *)dataModel {
    if (_dataModel) {
        return _dataModel;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:@"query_item" ofType:@"txt"];
    NSError *error;
    NSString *str = [NSString stringWithContentsOfFile:path encoding: NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"error = %@", error);
    }
    
    if (str) {
        NSLog(@"str= %@", str);
    }
    _dataModel = [[MultipleQueryDataModel alloc] initWithString:str error:nil];
    
    return _dataModel;
}

@end
