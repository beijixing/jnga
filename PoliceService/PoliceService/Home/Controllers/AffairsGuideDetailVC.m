//
//  AffairsGuideDetailVC.m
//  PoliceService
//
//  Created by horse on 2017/2/21.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "AffairsGuideDetailVC.h"
#import "FSMacro.h"
#import "AffairsDetailViewCell.h"
#import "RequestService.h"
#import "WJHUD.h"
#import "GlobalVariableManager.h"
#import "SuggestionVC.h"

@interface AffairsGuideDetailVC ()<UITableViewDelegate, UITableViewDataSource >
@property(nonatomic, strong)UITableView *mainTableView;
@property(nonatomic, strong) NSArray *titleArr;
@property(nonatomic, strong) NSMutableArray *contentArr;
@end

@implementation AffairsGuideDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"办事详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpLeftNavbarItem];
    [self setUpRightNavbarItem];
    [self.view addSubview:self.mainTableView];
}

- (void)setUpLeftNavbarItem {
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
        
    }];
}

- (void)setUpRightNavbarItem {
    typeof(self) __weak wself = self;
    
    [self setRightNavigationBarButtonItemWithTitle:@"\U0000E66E" titleColor:[UIColor whiteColor] font:[UIFont fontWithName:@"iconfont" size:25.0]  andAction:^{
        SuggestionVC *appvc = [[SuggestionVC alloc] init];
        appvc.dataType = @"4";
        appvc.title = @"我要咨询";
        wself.hidesBottomBarWhenPushed = YES;
        [wself.navigationController pushViewController:appvc animated:YES];
        wself.hidesBottomBarWhenPushed = NO;
    }];
}

#pragma mark - UITableviewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArr.count;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    AffairsDetailViewCell* showCell = (AffairsDetailViewCell*)cell;
    showCell.titleLabel.text = self.titleArr[indexPath.row];
    showCell.contentLabel.text = self.contentArr[indexPath.row];
    showCell.contentLabel.numberOfLines = 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  [self heightForBasicCellAtIndexPath:indexPath];
}

- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath {
    static AffairsDetailViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.mainTableView dequeueReusableCellWithIdentifier:@"cell"];
    });
    
    sizingCell.titleLabel.text = self.titleArr[indexPath.row];
    sizingCell.contentLabel.text = self.contentArr[indexPath.row];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    if (size.height < 44) {
        return 44;
    }else {
        return size.height + 1.0f; // Add 1.0f for the cell separator height
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
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
    _mainTableView.estimatedRowHeight = 44;
//    _mainTableView.rowHeight = UITableViewAutomaticDimension;
    [_mainTableView registerNib:[UINib nibWithNibName:@"AffairsDetailViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    return _mainTableView;
}

-(NSArray *)titleArr {
    if (_titleArr) {
        return _titleArr;
    }
    _titleArr = @[@"事项名称:",@"办理条件:", @"办理材料:", @"办理程序:", @"办理期限:", @"收费标准:", @"办理地点:"];
    return _titleArr;
}

-(NSMutableArray *)contentArr {
    if (_contentArr) {
        return _contentArr;
    }
    
    
    _contentArr = [[NSMutableArray alloc] init];
    [_contentArr addObject:self.dataDict[@"itemName"]];
    [_contentArr addObject:self.dataDict[@"handlingConditions"]];
    [_contentArr addObject:self.dataDict[@"processingMaterials"]];
    [_contentArr addObject:self.dataDict[@"managementProcedures"]];
    [_contentArr addObject:self.dataDict[@"deadline"]];
    [_contentArr addObject:self.dataDict[@"chargeStandard"] ?:@"无收费标准"];
    [_contentArr addObject:self.dataDict[@"locationManagement"]];
    return _contentArr;
}


@end
