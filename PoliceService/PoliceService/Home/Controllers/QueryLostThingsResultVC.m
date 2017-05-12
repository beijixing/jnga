//
//  QueryLostThingsResultVC.m
//  PoliceService
//
//  Created by horse on 2017/3/2.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "QueryLostThingsResultVC.h"
#import "FSMacro.h"
#import "QueryLostThingsResultTableCell.h"
#import "RequestService.h"
#import "Validator.h"
#import "GlobalVariableManager.h"
#import "WJHUD.h"
#import "StrayManDetailCell.h"
#import "LostItemDataModel.h"
#import "LostItemServerDataModel.h"
#import "MJRefresh.h"
@interface QueryLostThingsResultVC ()<UITableViewDelegate, UITableViewDataSource >
@property(nonatomic, strong)UITableView *mainTableView;
@property(nonatomic, assign) NSInteger pageCount;
@property(nonatomic, strong) LostItemServerDataModel *dataModel;
@property(nonatomic, strong) NSArray *titleArr;
@end

@implementation QueryLostThingsResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"失物招领、挂失查询";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpLeftNavbarItem];
    [self.view addSubview:self.mainTableView];
    self.pageCount = 1;
    [self getQueryData];
}

- (void)getQueryData {
    [WJHUD showOnView:self.view];
    typeof(self) __weak wself = self;
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:self.queryParamDict];
    dictionary[@"pageNo"] = [NSNumber numberWithInteger:self.pageCount];
    dictionary[@"pageSize"] = @3;
    
    [RequestService getLostItemListWithParamDict:dictionary resultBlock:^(BOOL success, id object) {
        [WJHUD hideFromView:wself.view];
        if (success) {
            NSDictionary *dataDict = (NSDictionary *)object;
            if ([[dataDict objectForKey:@"code"] integerValue] == 1) {
                NSDictionary *data = [dataDict objectForKey:@"data"];
                if (!wself.dataModel) {
                    NSError *error;
                    wself.dataModel = [[LostItemServerDataModel alloc] initWithDictionary:data error:&error];
                    NSLog(@"error=%@", error);
                }else {
                    LostItemServerDataModel *tmpDataModel = [[LostItemServerDataModel alloc] initWithDictionary:data error:nil];
                    [wself.dataModel.list addObjectsFromArray:tmpDataModel.list];
                }
                
                if (wself.dataModel.list.count == wself.dataModel.count) {
                    [wself.mainTableView.mj_footer endRefreshingWithNoMoreData];
                }else {
                    [wself.mainTableView.mj_footer endRefreshing];
                }
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
    return self.titleArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataModel.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  [self heightForBasicCellAtIndexPath:indexPath];
}

- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath {
    static StrayManDetailCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.mainTableView dequeueReusableCellWithIdentifier:@"cell"];
    });
    LostItemDataModel *itemModel = self.dataModel.list[indexPath.section];
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([itemModel class], &outCount);
    objc_property_t property = properties[indexPath.row];
    const char* char_f =property_getName(property);
    NSString *propertyName = [NSString stringWithUTF8String:char_f];
    sizingCell.titleLabel.text = self.titleArr[indexPath.row];
    sizingCell.contentLabel.text = [itemModel valueForKey:(NSString *)propertyName];
    free(properties);
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    StrayManDetailCell *showCell = (StrayManDetailCell *)cell;
    LostItemDataModel *itemModel = self.dataModel.list[indexPath.section];
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([itemModel class], &outCount);
    objc_property_t property = properties[indexPath.row];
    const char* char_f =property_getName(property);
    NSString *propertyName = [NSString stringWithUTF8String:char_f];
    showCell.titleLabel.text = self.titleArr[indexPath.row];
    showCell.contentLabel.text = [itemModel valueForKey:(NSString *)propertyName];

    if(indexPath.row == 0)
    {
        showCell.contentLabel.textColor = [UIColor redColor];
    }else {
        showCell.contentLabel.textColor = COLOR_WITH_RGB(53, 53, 53);
    }
    free(properties);
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
    [_mainTableView registerNib:[UINib nibWithNibName:@"StrayManDetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    typeof(self) __weak wself = self;
    _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        wself.pageCount++;
        [wself getQueryData];
    }];

    return _mainTableView;
}

- (NSArray *)titleArr {
    if (_titleArr) {
        return _titleArr;
    }
    _titleArr = @[@"物品遗失人",@"物品名称",@"遗失地点",@"物品详情", @"遗失时间", @"警方电话"];
    return _titleArr;
}
@end
