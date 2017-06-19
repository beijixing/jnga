//
//  ReservationOnlineViC.m
//  PoliceService
//
//  Created by horse on 2017/2/17.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "ReservationOnlineVC.h"
#import "FSMacro.h"
#import "ReservationOnlineTableCell.h"
#import "ReservationDetailVC.h"
#import "ReservationDataModel.h"
#import "GlobalVariableManager.h"
#import "ReservationNoticeVC.h"
#import "GlobalFunctionManager.h"
#import "WJHUD.h"
#import "RequestService.h"
#import "UIImageView+WebCache.h"
#import "CommonWebViewController.h"
@interface ReservationOnlineVC ()<UITableViewDelegate, UITableViewDataSource >
@property(nonatomic, strong)UITableView *mainTableView;
@property(nonatomic, strong) NSArray *titleArr;
@property(nonatomic, strong) ReservationDataModel *dataModel;
@end

@implementation ReservationOnlineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"网上预约";
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
    return self.dataModel.datas.count;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    ReservationOnlineTableCell* showCell = (ReservationOnlineTableCell*)cell;
    OperationItemModel *itemModel = self.dataModel.datas[indexPath.row];
    showCell.titleLabel.text = itemModel.title;
    showCell.iconImageView.image = [UIImage imageNamed:itemModel.img_url];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.view.frame.size.height > 568) {
        return 80*KSCALE;
    }else {
        return 50;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OperationItemModel *itemModel = self.dataModel.datas[indexPath.row];
    if (indexPath.row == 8) {
        self.hidesBottomBarWhenPushed = YES;
        CommonWebViewController *webViewVc = [[CommonWebViewController alloc] init];
        webViewVc.title = itemModel.title;
        webViewVc.urlString = @"http://www.sdcrj.com/";
        [self.navigationController pushViewController:webViewVc animated:YES];
        return;
    }
    if (indexPath.row == 7) {
        self.hidesBottomBarWhenPushed = YES;
        CommonWebViewController *webViewVc = [[CommonWebViewController alloc] init];
        webViewVc.title = itemModel.title;
        webViewVc.urlString = @"http://www.chinayzd.cn/yc/login.html";
        [self.navigationController pushViewController:webViewVc animated:YES];
        return;
    }
    if (indexPath.row == 8) {
        self.hidesBottomBarWhenPushed = YES;
        CommonWebViewController *webViewVc = [[CommonWebViewController alloc] init];
        webViewVc.title = itemModel.title;
        webViewVc.urlString = @"http://sdcrj.jnzhwl.com/jnshjts.php";
        [self.navigationController pushViewController:webViewVc animated:YES];
        return;
    }
    self.hidesBottomBarWhenPushed = YES;
    ReservationDetailVC *reservationDetailVc = [[ReservationDetailVC alloc] init];
    reservationDetailVc.keyword = itemModel.keyword;
    reservationDetailVc.title = itemModel.title;
    [self.navigationController pushViewController:reservationDetailVc animated:YES];
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
    _titleArr = @[@"交管预约", @"身份证办理预约", @"出生登记预约", @"户口登记项目变更预约", @"户口注销预约", @"市外嵌入预约", @"其他户口预约", @"出入境办理预约", @"消防审批预约"];
    return _titleArr;
}

-(ReservationDataModel *)dataModel {
    if (_dataModel) {
        return _dataModel;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:@"reservation_item" ofType:@"txt"];
    NSError *error;
    NSString *str = [NSString stringWithContentsOfFile:path encoding: NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"error = %@", error);
    }
    
    _dataModel = [[ReservationDataModel alloc] initWithString:str error:&error];
    
    if (error) {
        NSLog(@"error= %@", error);
    }
    
    return _dataModel;
}

@end
