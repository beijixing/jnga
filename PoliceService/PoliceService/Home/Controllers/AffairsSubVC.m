//
//  AffairsSubVC.m
//  PoliceService
//
//  Created by horse on 2017/2/21.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "AffairsSubVC.h"
#import "FSMacro.h"
#import "AffairsSubViewTableCell.h"
#import "SimilarNameQueryVC.h"
#import "CheckOpenCaseVC.h"
#import "AffairsGuideDetailVC.h"
#import "AffairsGuideSubDataModel.h"
#import "WJHUD.h"
#import "RequestService.h"
#import "GlobalVariableManager.h"
@interface AffairsSubVC ()<UITableViewDelegate, UITableViewDataSource >
@property(nonatomic, strong)UITableView *mainTableView;
@property(nonatomic, strong) NSArray *titleArr;
@property(nonatomic, strong) NSArray *dataArr;
@end

@implementation AffairsSubVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"业务选择";
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
    [WJHUD showOnView:self.view];
    typeof(self) __weak wself = self;
    [RequestService getGuideListWithParamDict:@{@"parentid":self.parentId} resultBlock:^(BOOL success, id object) {
        [WJHUD hideFromView:wself.view];
        if (success) {
            NSDictionary *dataDict = (NSDictionary *)object;
            if ([[dataDict objectForKey:@"code"] integerValue] == 1) {
                NSLog(@"%@", dataDict);
                wself.dataArr = dataDict[@"data"];
                [wself.mainTableView reloadData];
            }else {
                [WJHUD showText:[dataDict objectForKey:@"message"] onView:wself.view];
            }
        }
        else {
            NSLog(@"object=%@", object);
        }
    }];
}

#pragma mark - UITableviewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    AffairsSubViewTableCell* showCell = (AffairsSubViewTableCell*)cell;
    NSDictionary *dModel = self.dataArr[indexPath.row];
    showCell.titleLabel.text = dModel[@"itemName"] ?: @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.view.frame.size.height > 568) {
        return 80*KSCALE;
    }else {
        return 50;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dModel = self.dataArr[indexPath.row];
    AffairsGuideDetailVC *detailVc = [[AffairsGuideDetailVC alloc] init];
    detailVc.dataDict = dModel;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
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
    _mainTableView.backgroundColor = COLOR_WITH_RGB(255, 255, 255);
    [_mainTableView registerNib:[UINib nibWithNibName:@"AffairsSubViewTableCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    return _mainTableView;
}

-(NSArray *)titleArr {
    if (_titleArr) {
        return _titleArr;
    }
    _titleArr = @[@"爆破作业单位许可证(非营业性)", @"爆破作业人员许可证", @"典当行特种行业许可证", @"大型群众性活动许可证", @"公章刻制业特种行业许可证", @"烟花爆竹道路运输许可证", @"剧毒化学品购买许可证"];
    return _titleArr;
}

//-(AffairsGuideSubDataModel *)dataModel {
//    if (_dataModel) {
//        return _dataModel;
//    }
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"actguidelist_item" ofType:@"txt"];
//    NSError *error;
//    NSString *str = [NSString stringWithContentsOfFile:path encoding: NSUTF8StringEncoding error:&error];
//    if (error) {
//        NSLog(@"error = %@", error);
//    }
//    
//    if (str) {
//        NSLog(@"str= %@", str);
//    }
//    _dataModel = [[AffairsGuideSubDataModel alloc] initWithString:str error:nil];
//    
//    return _dataModel;
//}
@end
