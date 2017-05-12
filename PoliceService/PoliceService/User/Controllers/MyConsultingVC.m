//
//  MyConsultingVC.m
//  PoliceService
//
//  Created by horse on 2017/2/14.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "MyConsultingVC.h"
#import "FSMacro.h"
#import "UIFactory.h"
#import "MyConsultingTableCell.h"
#import "GlobalFunctionManager.h"
#import "RequestService.h"
#import "GlobalVariableManager.h"
#import "WJHUD.h"
#import "MJRefresh.h"
#import "MyConsultingDataModel.h"
#import "MyConsultingDetailVC.h"
@interface MyConsultingVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSArray *mainTableDataArr;
@property (nonatomic, strong) UIView *segmentView;
@property (nonatomic) NSInteger unAnwseredViewId;
@property (nonatomic) NSInteger anwseredViewId;
@property (strong, nonatomic) CAShapeLayer *segmentLayer;
@property (strong, nonatomic) UILabel *unAnwseredLabel;
@property (strong, nonatomic) UILabel *anwseredLabel;
@property (nonatomic, assign) BOOL  showAnwserInfo;
@property(nonatomic, strong) NSString *ztdm;
@property(nonatomic, assign) NSInteger pageCount;
@property(nonatomic, strong) MyConsultingDataModel *dataModel;

@end
NSString *conCellIdentifer = @"cell";
@implementation MyConsultingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.unAnwseredViewId = 1001;
    self.anwseredViewId = 1002;
    self.title = @"我的咨询";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpLeftNavbarItem];
    [self.view addSubview:self.segmentView];
    [self.view addSubview:self.mainTableView];
    
    [self setupUnanwseredView];
    self.ztdm = @"0";//未回复
    self.pageCount = 1;
    [self getServerData];
    self.showAnwserInfo = NO;
}

- (void)getServerData {
    typeof(self) __weak wself = self;
    self.segmentView.userInteractionEnabled = NO;
    [WJHUD showOnView:self.view];
    [RequestService postAppListByPhoneZtWithParamDict:@{
                                                        @"phone":[GlobalVariableManager manager].phone ,
                                                        @"ztdm": self.ztdm,
                                                        @"pageNo": [NSNumber numberWithInteger:self.pageCount],
                                                        @"pageSize":@10
                                                        } resultBlock:^(BOOL success, id object) {
                                                            [WJHUD hideFromView:wself.view];
        [GlobalFunctionManager handleServerDataWithController:wself result:success dataObj:object successBlock:^{
            NSLog(@"object = %@", object);
            if (!wself.dataModel) {
                NSError *error;
                wself.dataModel = [[MyConsultingDataModel alloc] initWithDictionary:[object objectForKey:@"data"] error:&error];
                NSLog(@"error=%@", error);
            }else {
                MyConsultingDataModel *tmpDataModel = [[MyConsultingDataModel alloc] initWithDictionary:[object objectForKey:@"data"] error:nil];
                [wself.dataModel.list addObjectsFromArray:tmpDataModel.list];
            }
            
            if (wself.dataModel.list.count == wself.dataModel.count) {
                [wself.mainTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [wself.mainTableView.mj_footer endRefreshing];
            }
            [wself.mainTableView reloadData];
            wself.segmentView.userInteractionEnabled = YES;
        }];
    }];
}

- (void)setupUnanwseredView {
    if (self.segmentLayer) {
        [self.segmentLayer removeFromSuperlayer];
    }
    self.segmentLayer = [self getSegmentLayerWithFrontColor:COLOR_WITH_RGB(115, 198, 250) backgroundColor:COLOR_WITH_RGB(204, 204, 204)];
    self.anwseredLabel.textColor = [UIColor blackColor];
    self.unAnwseredLabel.textColor = [UIColor whiteColor];
}

- (void)setupAnwseredView {
    if (self.segmentLayer) {
        [self.segmentLayer removeFromSuperlayer];
    }
    self.segmentLayer = [self getSegmentLayerWithFrontColor:COLOR_WITH_RGB(204, 204, 204) backgroundColor:COLOR_WITH_RGB(115, 198, 250)];
    self.anwseredLabel.textColor = [UIColor whiteColor];
    self.unAnwseredLabel.textColor = [UIColor blackColor];
}


- (void)setUpLeftNavbarItem {
//    typeof(self) __weak wself = self;
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
        
    }];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataModel.list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:conCellIdentifer];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark  UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100*KSCALE;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyConsultingTableCell *showCell = (MyConsultingTableCell*)cell;
    MyConsultingItemModel *dModel = self.dataModel.list[indexPath.row];
    NSInteger idx = [dModel.type integerValue];
    showCell.nameLabel.text = dModel.name;
    showCell.titleLabel.text = self.mainTableDataArr[idx-1];
    showCell.consultTimeLabel.text = [dModel.cjsj substringToIndex:10];
    if (self.showAnwserInfo) {
        showCell.replyTimeLabel.hidden = NO;
        showCell.replyTimeLabel.text = [dModel.finishTime substringToIndex:10];
    }else {
        showCell.replyTimeLabel.hidden = YES;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MyConsultingItemModel *dModel = self.dataModel.list[indexPath.row];
    MyConsultingDetailVC *detailVc = [[MyConsultingDetailVC alloc] init];
    detailVc.dataItemModel = dModel;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (CAShapeLayer *)getSegmentLayerWithFrontColor:(UIColor *)fColor backgroundColor:(UIColor *)bgColor {
    
    CAShapeLayer *leftLayer = [CAShapeLayer layer];
    leftLayer.frame = CGRectMake(0, 0, SCREN_WIDTH, 50);
    leftLayer.lineWidth = 2.0;
    leftLayer.fillColor = fColor.CGColor;
    
    leftLayer.backgroundColor =bgColor.CGColor;
    //    leftLayer.strokeColor = [UIColor greenColor].CGColor;
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(SCREN_WIDTH/2, 0)];
    [path addLineToPoint:CGPointMake(SCREN_WIDTH/2, 44)];
    [path addLineToPoint:CGPointMake(0, 44)];
    [path closePath];
    leftLayer.path = path.CGPath;
    [self.segmentView.layer insertSublayer:leftLayer atIndex:0];
    return leftLayer;
}

- (UIView *)segmentView {
    if (_segmentView) {
        return _segmentView;
    }
    _segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREN_WIDTH, 44)];
    [_segmentView addSubview:[self getTapGestureViewWithFrame:CGRectMake(0, 0, SCREN_WIDTH/2, 44) tag:self.unAnwseredViewId]];
    
    [_segmentView addSubview:[self getTapGestureViewWithFrame:CGRectMake(SCREN_WIDTH/2, 0, SCREN_WIDTH/2, 44) tag:self.anwseredViewId]];
    [_segmentView addSubview:self.unAnwseredLabel];
    [_segmentView addSubview:self.anwseredLabel];
    return _segmentView;
}


- (UIView *)getTapGestureViewWithFrame:(CGRect)frame tag:(NSInteger)tag {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.tag = tag;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(anwserAction:)];
    [view addGestureRecognizer:tapGesture];
    return view;
}

- (void)anwserAction:(UITapGestureRecognizer *)gesture {
    
    NSInteger viewTag = gesture.view.tag;
    NSLog(@"viewTag = %ld",viewTag);
    if (viewTag == self.unAnwseredViewId) {
        [self setupUnanwseredView];
        self.showAnwserInfo = NO;
        self.pageCount = 1;
        self.ztdm = @"0";
        self.dataModel = nil;
        [self getServerData];
        
    }else if(viewTag == self.anwseredViewId) {
        [self setupAnwseredView];
        self.showAnwserInfo = YES;
        self.ztdm = @"1";
        self.pageCount = 1;
        self.dataModel = nil;
        [self getServerData];
    }
}

- (UILabel *)unAnwseredLabel {
    if(_unAnwseredLabel) {
        return _unAnwseredLabel;
    }
    _unAnwseredLabel = [UIFactory createLabelWith:CGRectMake(0, 0, SCREN_WIDTH/2, 44) textColor:[UIColor whiteColor] text:@"未回复"];
    _unAnwseredLabel.textAlignment = NSTextAlignmentCenter;
    _unAnwseredLabel.center = CGPointMake(SCREN_WIDTH/4, 22);
    return _unAnwseredLabel;
}

- (UILabel *)anwseredLabel {
    if(_anwseredLabel) {
        return _anwseredLabel;
    }
    _anwseredLabel = [UIFactory createLabelWith:CGRectMake(0, 0, SCREN_WIDTH/2, 44) textColor:[UIColor blackColor] text:@"已回复"];
    _anwseredLabel.textAlignment = NSTextAlignmentCenter;
    _anwseredLabel.center = CGPointMake(SCREN_WIDTH/4*3, 22);
    return _anwseredLabel;
}

-(UITableView *)mainTableView {
    if(_mainTableView){
        return _mainTableView;
    }
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, SCREN_HEIGHT-44) style:UITableViewStylePlain];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.backgroundColor = COLOR_WITH_RGB(240, 244, 249);
    //    if(SCREN_HEIGHT > 568.0){
    //        _operationTableview.scrollEnabled = NO;
    //    }
    
    [_mainTableView registerNib:[UINib nibWithNibName:@"MyConsultingTableCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:conCellIdentifer];
    //    [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:mycellIdentifier];
    typeof(self) __weak wself = self;
    _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        wself.pageCount++;
        [wself getServerData];
    }];
    return _mainTableView;
}

-(NSArray *)mainTableDataArr {
    if (_mainTableDataArr) {
        return _mainTableDataArr;
    }
    _mainTableDataArr = @[@"我要举报", @"我要建议", @"我要投诉", @"我要咨询", @"我要信访", @"我要评警"];
    return _mainTableDataArr;
    
}
@end
