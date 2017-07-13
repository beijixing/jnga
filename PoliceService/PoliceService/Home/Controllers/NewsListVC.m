//
//  NewsListVC.m
//  PoliceService
//
//  Created by horse on 2017/4/7.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "NewsListVC.h"
#import "ScrollImage.h"
#import "RoundButton.h"
#import "DeedsCell.h"
#import "FSMacro.h"
#import "UIImage+CreateEmptyImage.h"
#import "WJHUD.h"
#import "RequestService.h"
#import "GlobalFunctionManager.h"
#import "GlobalVariableManager.h"
#import "NewsCenterServerDataModel.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "NewsDetailVC.h"
#define SCROLL_HEADER_HEIGHT (320*KSCALE)
#define MODULE_HEADER_HEIGHT (280*KSCALE)
#define DEEDS_HEADER_HEIGHT (40*KSCALE)

@interface NewsListVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray *titleArr;
@property(nonatomic, strong)NSArray *mainTableDataArr;
@property(nonatomic, assign) NSInteger pageCount;
@property(nonatomic, strong) NewsCenterServerDataModel *dataModel;
@end

@implementation NewsListVC

#pragma mark --ViewController life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageCount = 1;
    [self.view addSubview:self.tableView];
    [self getServerData];
}

- (void)getServerData {
    [WJHUD showOnView:self.view];
    typeof(self) __weak wself = self;
    [RequestService getNewsListWithParamDict:@{@"type":self.newsType, @"pageNo":[NSNumber numberWithInteger:self.pageCount], @"pageSize":@10} resultBlock:^(BOOL success, id object) {
        [WJHUD hideFromView:wself.view];
        [GlobalFunctionManager handleServerDataWithController:wself result:success dataObj:object successBlock:^{
            NSLog(@"object=%@", object);
            if (!wself.dataModel) {
                NSError *error;
                wself.dataModel = [[NewsCenterServerDataModel alloc] initWithDictionary:[object objectForKey:@"data"] error:&error];
                NSLog(@"error=%@", error);
            }else {
                NewsCenterServerDataModel *tmpDataModel = [[NewsCenterServerDataModel alloc] initWithDictionary:[object objectForKey:@"data"] error:nil];
                [wself.dataModel.list addObjectsFromArray:tmpDataModel.list];
            }
            
            if (wself.dataModel.list.count == wself.dataModel.count) {
                [wself.tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [wself.tableView.mj_footer endRefreshing];
            }
            [wself.tableView reloadData];
        }];
    }];
}


#pragma mark --UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataModel.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.newsType integerValue] == 1){
        return 140*KSCALE;
    }else {
        return 100*KSCALE;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deedsCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    DeedsCell *showCell = (DeedsCell *)cell;
    NewsItemDataModel *dModel = self.dataModel.list[indexPath.row];
    showCell.titleLabel.text = dModel.title;
    [showCell.iconImageView sd_setImageWithURL:[NSURL URLWithString:dModel.image] placeholderImage:[UIImage imageNamed:@"deedsTest"]];
    if ([self.newsType integerValue] != 1) {
        showCell.iconWidthConstraint.constant = 0;
        showCell.topMarginConstraint.constant = 4;
        showCell.bottomMarginConstraint.constant = 4;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsItemDataModel *dModel = self.dataModel.list[indexPath.row];
    NewsDetailVC *detailVc = [[NewsDetailVC alloc] init];
    detailVc.itemNewsModel = dModel;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark --Getters

- (UITableView *)tableView {
    if (_tableView) {
        return _tableView;
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREN_WIDTH, SCREN_HEIGHT-64-44) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = COLOR_WITH_RGB(255, 255, 255);
    [_tableView registerNib:[UINib nibWithNibName:@"DeedsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"deedsCell"];
    
    typeof(self) __weak wself = self;
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        wself.pageCount++;
        [wself getServerData];
    }];
    return _tableView;
}

@end
