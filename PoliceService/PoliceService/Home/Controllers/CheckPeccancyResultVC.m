//
//  CheckPeccancyResultVC.m
//  PoliceService
//
//  Created by horse on 2017/3/2.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "CheckPeccancyResultVC.h"
#import "FSMacro.h"
#import "UIFactory.h"
#import "CheckPeccancyResultTableCell.h"
@interface CheckPeccancyResultVC ()<UITableViewDelegate, UITableViewDataSource >
@property(nonatomic, strong) UITableView *mainTableView;
@property(nonatomic, strong) UIView *headerView;
//@property(nonatomic, strong) MultipleQueryDataModel *dataModel;
@end

@implementation CheckPeccancyResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"违章记录";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpLeftNavbarItem];
    [self.view addSubview:self.mainTableView];
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
    return 10;//self.dataModel.datas.count;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 150;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
    [_mainTableView registerNib:[UINib nibWithNibName:@"CheckPeccancyResultTableCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    _mainTableView.tableHeaderView = self.headerView;
    return _mainTableView;
}

- (UIView *)headerView {
    if (_headerView) {
        return _headerView;
    }
    
    _headerView = [UIFactory createViewWith:CGRectMake(0, 0, SCREN_WIDTH, 260*KSCALE) backgroundColor:[UIColor whiteColor]];
    
    UIImageView *carImage = [UIFactory createImageViewWith:CGRectMake(15, 15*KSCALE, 160*KSCALE, 120*KSCALE) imageName:@"police1"];
    
    UILabel *carNumLabel = [UIFactory createLabelWith:CGRectMake(CGRectGetMaxX(carImage.frame)+10, 15*KSCALE, 300, 130*KSCALE) textColor:COLOR_WITH_RGB(122, 122, 122) text:@"鲁A12345678"];
    UIImageView *line = [UIFactory createImageViewWith:CGRectMake(0, CGRectGetMaxY(carImage.frame)+15*KSCALE, SCREN_WIDTH, 1) imageName:@""];
    line.backgroundColor = COLOR_WITH_RGB(234, 234, 234);
    UILabel *peccancyLabel = [UIFactory createLabelWith:CGRectMake(15, CGRectGetMaxY(line.frame)+20*KSCALE, SCREN_WIDTH/3.5, 60*KSCALE) textColor:COLOR_WITH_RGB(122, 122, 122) text:@"违章：20"];
    
    UILabel *peccancyLabel2 = [UIFactory createLabelWith:CGRectMake(CGRectGetMaxX(peccancyLabel.frame)+20*KSCALE, CGRectGetMaxY(line.frame)+20*KSCALE, SCREN_WIDTH/3.5, 60*KSCALE) textColor:COLOR_WITH_RGB(122, 122, 122) text:@"扣分：200"];
    
    UILabel *peccancyLabel3 = [UIFactory createLabelWith:CGRectMake(CGRectGetMaxX(peccancyLabel2.frame)+20*KSCALE, CGRectGetMaxY(line.frame)+20*KSCALE, SCREN_WIDTH/3, 60*KSCALE) textColor:COLOR_WITH_RGB(122, 122, 122) text:@"罚款：200"];
    UIView *decorationView = [UIFactory createViewWith:CGRectMake(0, CGRectGetMaxY(peccancyLabel3.frame), SCREN_WIDTH, 20) backgroundColor:COLOR_WITH_RGB(240, 244, 249)];

    [_headerView addSubview:carImage];
    [_headerView addSubview:carNumLabel];
    [_headerView addSubview:line];
    [_headerView addSubview:peccancyLabel];
    [_headerView addSubview:peccancyLabel2];
    [_headerView addSubview:peccancyLabel3];
    [_headerView addSubview:decorationView];
    return _headerView;
}
//-(MultipleQueryDataModel *)dataModel {
//    if (_dataModel) {
//        return _dataModel;
//    }
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"query_item" ofType:@"txt"];
//    NSError *error;
//    NSString *str = [NSString stringWithContentsOfFile:path encoding: NSUTF8StringEncoding error:&error];
//    if (error) {
//        NSLog(@"error = %@", error);
//    }
//    
//    if (str) {
//        NSLog(@"str= %@", str);
//    }
//    _dataModel = [[MultipleQueryDataModel alloc] initWithString:str error:nil];
//    
//    return _dataModel;
//}

@end
