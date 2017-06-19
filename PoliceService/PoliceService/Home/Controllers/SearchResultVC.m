//
//  SearchResultVC.m
//  PoliceService
//
//  Created by horse on 2017/3/2.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "SearchResultVC.h"
#import "FSMacro.h"
#import "SearchResultTableCell.h"
#import "SearchResultDataSource.h"
#import "RequestService.h"
#import "WJHUD.h"
#import "GlobalFunctionManager.h"
#import "AffairsGuideDetailVC.h"
@interface SearchResultVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)UITableView *mainTableView;
@property(nonatomic, strong) NSMutableArray *searchList;
@property(nonatomic, strong) NSMutableArray *dataList;
@end

@implementation SearchResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索结果";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpLeftNavbarItem];
    [self.view addSubview:self.mainTableView];
    [self getData];
}

- (void)getData {
    typeof(self) __weak wself = self;
    [WJHUD showOnView:self.view];
    [RequestService getSearchResultWithParamDict:@{@"name" : self.keyboard ?: @""} resultBlock:^(BOOL success, id object) {
        [WJHUD hideFromView:wself.view];
        [GlobalFunctionManager handleServerDataWithController:wself result:success dataObj:object successBlock:^{
            NSLog(@"object = %@", object);
            wself.dataList = object[@"data"];
            [wself.mainTableView reloadData];
        }];
    }];

}
- (void)setUpLeftNavbarItem {
//    typeof(self) __weak wself = self;
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
    return self.dataList.count;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchResultTableCell *showCell = (SearchResultTableCell *)cell;
    NSDictionary *dataDict = self.dataList[indexPath.row];
    showCell.titleLabel.text = dataDict[@"name"];
    
    if (dataDict[@"itemName"]) {
        showCell.indicatorImage.hidden = NO;
    }else {
        showCell.indicatorImage.hidden = YES;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.view.frame.size.height > 568) {
        return 80*KSCALE;
    }else {
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AffairsGuideDetailVC *detailVc = [[AffairsGuideDetailVC alloc] init];
    NSDictionary *dataDict = self.dataList[indexPath.row];
    if (dataDict[@"itemName"]) {
        detailVc.dataDict = dataDict;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVc animated:YES];
    }
}


#pragma mark - PrivateMethods
- (UITableView *)mainTableView {
    if (_mainTableView) {
        return _mainTableView;
    }
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREN_WIDTH, SCREN_HEIGHT-64) style:UITableViewStylePlain];
//    SearchResultDataSource *dataSource = [[SearchResultDataSource alloc] init];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.backgroundColor = COLOR_WITH_RGB(240, 244, 249);
    [_mainTableView registerNib:[UINib nibWithNibName:@"SearchResultTableCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    return _mainTableView;
}
@end
