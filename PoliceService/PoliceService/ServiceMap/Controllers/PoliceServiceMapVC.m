//
//  PoliceServiceMapVC.m
//  PoliceService
//
//  Created by horse on 2017/2/21.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "PoliceServiceMapVC.h"
#import "FSMacro.h"
#import "PoliceMapTableCell.h"
#import "UIFactory.h"
#import "ServiceMapDataModel.h"
#import "RequestService.h"
#import "UIApplication+CallSystemApp.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "MyAnimatedAnnotationView.h"
#import <MapKit/MapKit.h>
#import "GlobalVariableManager.h"
#import "MJRefresh.h"
#import "WJHUD.h"
@interface PoliceServiceMapVC ()<UITableViewDelegate, UITableViewDataSource, BMKMapViewDelegate, BMKLocationServiceDelegate>
@property(nonatomic, strong)UITableView *mainTableView;
@property(nonatomic, strong) NSArray *titleArr;
@property(nonatomic, strong) NSArray *contentArr;
@property(nonatomic, strong) ServiceMapDataModel *dataModel;
@property(nonatomic, strong) BMKUserLocation *currentUserLocation;
@property(nonatomic, strong) BMKLocationService *locService;
@property(nonatomic, strong) BMKMapView *mapView;
@property(nonatomic, strong) BMKPointAnnotation *animatedAnnotation;
@property(nonatomic, strong) MapInfoItemDataModel *selectedCellDataModel;
@property(nonatomic, assign) NSInteger pageNumber;
@property(nonatomic, assign) BOOL hasUpdatePosition;
@property(nonatomic, assign) BOOL notFirstLoad;
@end

@implementation PoliceServiceMapVC

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    self.mapView.delegate = self;
    self.hasUpdatePosition = NO;//根据位置更新
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    self.mapView.delegate = nil;
    [GlobalVariableManager manager].mapViewShowBackBtn = NO;
}

- (BMKLocationService *)locService {
    if (_locService) {
        return _locService;
    }
    _locService = [[BMKLocationService alloc] init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    return _locService;
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    self.currentUserLocation = userLocation;
    
    if (!self.hasUpdatePosition) {
        self.hasUpdatePosition = YES;
        self.pageNumber = 1;//重新请求距离最近的数据
        self.dataModel = nil;
        [self getServerData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"警务地图";
    self.view.backgroundColor = COLOR_WITH_RGB(240, 244, 249);
    [self setupTipLabel];
    [self locService];
    [self.view addSubview:self.mainTableView];
   
    [self.view addSubview:self.mapView];
    
    if ([GlobalVariableManager manager].mapViewShowBackBtn) {
        [self setUpLeftNavbarItem];
    }
}

- (void)setUpLeftNavbarItem {
//    typeof(self) __weak wself = self;
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
        
    }];
}

- (BMKMapView *)mapView {
    if (_mapView) {
        return _mapView;
    }
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREN_WIDTH, SCREN_HEIGHT-64-49)];
    _mapView.hidden = YES;
    
    _mapView.zoomLevel = 15;
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
    
    UIButton *quitBtn = [UIFactory createButtonWith:CGRectMake(0, 0, 50, 40) selector:@selector(hideMapView:) target:self titleColor:[UIColor redColor] title:@"退出"];
    [_mapView addSubview:quitBtn];
    return _mapView;
}

- (void)addAnimatedAnnotationWithCoordinate:(CLLocationCoordinate2D)coor title:(NSString*)title {
//    if (self.animatedAnnotation == nil) {
        self.animatedAnnotation = [[BMKPointAnnotation alloc]init];
        self.animatedAnnotation.coordinate = coor;
        self.animatedAnnotation.title = title;
//    }
    [_mapView addAnnotation:self.animatedAnnotation];
    _mapView.centerCoordinate = coor;
}


// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    //普通annotation
//    if (annotation == pointAnnotation) {
//        NSString *AnnotationViewID = @"renameMark";
//        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
//        if (annotationView == nil) {
//            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
//            // 设置颜色
//            annotationView.pinColor = BMKPinAnnotationColorPurple;
//            // 从天上掉下效果
//            annotationView.animatesDrop = YES;
//            // 设置可拖拽
//            annotationView.draggable = YES;
//        }
//        return annotationView;
//    }
    
    //动画annotation
    NSString *AnnotationViewID = @"AnimatedAnnotation";
    MyAnimatedAnnotationView *annotationView = nil;
    if (annotationView == nil) {
        annotationView = [[MyAnimatedAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 1; i < 4; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"poi_%d.png", i]];
        [images addObject:image];
    }
    annotationView.annotationImages = images;
    return annotationView;
    
}

// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    NSLog(@"paopaoclick");
}


- (void)showMapViewWithCoordinate:(CLLocationCoordinate2D)coor title:(NSString*)title  {
    self.mapView.frame = CGRectZero;
    typeof(self) __weak wself = self;
    self.mapView.hidden = NO;
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        wself.mapView.frame = CGRectMake(0, 0, SCREN_WIDTH, SCREN_HEIGHT-64-49);
        
    } completion:^(BOOL finished) {
         [wself addAnimatedAnnotationWithCoordinate:coor title:title];
    }];
}

- (void)hideMapView:(UIButton *)btn {
    typeof(self) __weak wself = self;
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        wself.mapView.frame = CGRectZero;
    } completion:^(BOOL finished) {
        self.mapView.hidden = YES;
    }];
}

- (void)getServerData{
    [WJHUD showOnView:self.view];
    NSString *latitude = [NSString stringWithFormat:@"%6lf", self.currentUserLocation.location.coordinate.latitude];
    
    NSString *longitude = [NSString stringWithFormat:@"%6lf", self.currentUserLocation.location.coordinate.longitude];
    
    NSDictionary *paramDict = @{
                            @"latitude": latitude,
                            @"longitude":longitude,
                            @"pageNo": [NSNumber numberWithInteger:self.pageNumber],
                            @"pageSize":@4
                                };
    typeof(self) __weak wself = self;
    [RequestService getPoliceServiceMapDataWithParamDict:paramDict resultBlock:^(BOOL success, id object) {
        [WJHUD hideFromView:wself.view];
        if (success) {
            NSDictionary *dataDict = (NSDictionary*)object;
            if ([[dataDict objectForKey:@"code"] integerValue] == 1) {
                NSDictionary *data = [dataDict objectForKey:@"data"];
                if (!wself.dataModel) {
                    NSError *error;
                    wself.dataModel = [[ServiceMapDataModel alloc] initWithDictionary:data error:&error];
                    NSLog(@"error=%@", error);
                }else {
                    ServiceMapDataModel *tmpDataModel = [[ServiceMapDataModel alloc] initWithDictionary:data error:nil];
                    [wself.dataModel.list addObjectsFromArray:tmpDataModel.list];
                }
                
                if (wself.dataModel.list.count == wself.dataModel.count) {
                    [wself.mainTableView.mj_footer endRefreshingWithNoMoreData];
                }else {
                    [wself.mainTableView.mj_footer endRefreshing];
                }
                [wself.mainTableView reloadData];
            }else {
                [WJHUD showText:[dataDict objectForKey:@"message"] onView:self.view];
            }
        }
        else {
            NSLog(@"object=%@", object);
        }
        
    }];
}


- (void)setupTipLabel {
    UILabel *tipLabel = [UIFactory createLabelWith:CGRectMake(15, 7.5, SCREN_WIDTH-40, 30) textColor:COLOR_WITH_RGB(171, 172, 173) text:@"以下是距您最近的公安机关："];
    tipLabel.backgroundColor = COLOR_WITH_RGB(240, 244, 249);
    [self.view addSubview:tipLabel];
}
#pragma mark - UITableviewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PoliceMapTableCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return self.dataModel.list.count;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    PoliceMapTableCell* showCell = (PoliceMapTableCell*)cell;
    
    MapInfoItemDataModel *dModel = self.dataModel.list[indexPath.section];
    showCell.subbureauNameLabel.text = dModel.name;
    showCell.distanceLabel.text = [NSString stringWithFormat:@"%.2f千米", [dModel.distance doubleValue]];
    showCell.specificPositionLabel.text = dModel.address;
    showCell.tellLabel.text = dModel.tel;
    
    typeof(self) __weak wself = self;
    showCell.telCallBack = ^() {
        [[UIApplication sharedApplication] callWithViewController:wself telNumber:@"9600110"];
    };
    
    
    showCell.showMapCallBack = ^() {
        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([dModel.latitude doubleValue], [dModel.longitude doubleValue]);
        [wself showMapViewWithCoordinate:coor title:dModel.address];
    };
    
    showCell.navigationCallBack = ^(){
        wself.selectedCellDataModel = dModel;
        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([dModel.latitude doubleValue], [dModel.longitude doubleValue]);
        [wself showMapAlertWithDestination:coor];
    };
    
    
}

- (void)showMapAlertWithDestination:(CLLocationCoordinate2D)coordinate {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
     typeof(self) __weak weakSelf = self;
    UIAlertAction *appleMapAction = [UIAlertAction actionWithTitle:@"苹果自带地图" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf appleMapNavigationWithDestination:coordinate];
    }];
    
   
    UIAlertAction *bMapAction = [UIAlertAction actionWithTitle:@"百度地图" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf baiduMapNavigationWithDestination:coordinate];
    }];
    
    UIAlertAction *aMapAction = [UIAlertAction actionWithTitle:@"高德地图" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf aMapNavigationWithDestination:coordinate];
        
    }];
    
    UIAlertAction *tcMapAction = [UIAlertAction actionWithTitle:@"腾讯地图" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf tcMapNavigationWithDestination:coordinate];
        
    }];
    
//    UIAlertAction *googleMapAction = [UIAlertAction actionWithTitle:@"谷歌地图" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//        [weakSelf googleMapNavigationWithDestination:coordinate];
//    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:appleMapAction];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        [alertController addAction:bMapAction];
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        [alertController addAction:aMapAction];
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        [alertController addAction:tcMapAction];
    }
    
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
//        [alertController addAction:googleMapAction];
//    }
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:^{
    }];
}


- (void)appleMapNavigationWithDestination:(CLLocationCoordinate2D)coordinate{
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil]];
    [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                   MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
}

/*
 这里面要注意几点：
 1，origin={{我的位置}}, 这个是不能被修改的，不然无法把出发位置设置为当前位置
 2，destination = latlng:%f,%f|name = 目的地
 这里面的 name 的字段不能省略，否则导航会失败，而后面的文字则可以随意，赋个你的目的地的值给他就可以了。
 3，coord_type = gcj02
 coord_type 允许的值为 bd09ll、gcj02、wgs84，如果你 APP 的地图 SDK 用的是百度地图 SDK，请填 bd09ll，否则就填gcj02，wgs84的话基本是用不上了
 */
- (void)baiduMapNavigationWithDestination:(CLLocationCoordinate2D)coordinate{
    NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%5lf,%6lf|name=%@&mode=driving&coord_type=bd09ll",coordinate.latitude, coordinate.longitude, self.selectedCellDataModel.name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

/*
 sourceApplication=%@&backScheme=%@
 sourceApplication代表你自己APP的名称 会在之后跳回的时候显示出来 所以必须填写 backScheme是你APP的URL Scheme 不填是跳不回来的哟
 dev=0
 这里填0就行了，跟上面的gcj02一个意思 1代表wgs84 也用不上
 */

- (void)aMapNavigationWithDestination:(CLLocationCoordinate2D)coordinate{
    NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%5lf&lon=%6lf&dev=0&style=2",@"济宁公安",@"PoliceService",coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

- (void)tcMapNavigationWithDestination:(CLLocationCoordinate2D)coordinate{
    NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%5lf,%6lf&to=终点&coord_type=1&policy=0" ,coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

/*
 要注意几点
 
 x-source=%@&x-success=%@
 跟高德一样 这里分别代表APP的名称和URL Scheme
 saddr=
 这里留空则表示从当前位置触发。
 */
- (void)googleMapNavigationWithDestination:(CLLocationCoordinate2D)coordinate{
    NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",@"济宁公安",@"PoliceService",coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (SCREN_HEIGHT < 600) {
        return 160;
    }else {
        return 220*KSCALE;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [UIFactory createViewWith:CGRectMake(0, 0, SCREN_WIDTH, 20) backgroundColor:COLOR_WITH_RGB(240, 244, 249)];
    return footer;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 20;
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    ReservationDetailVC *detailVc = [[ReservationDetailVC alloc] init];
    //    self.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:detailVc animated:YES];
    //    self.hidesBottomBarWhenPushed = NO;
    switch (indexPath.row) {
        case 0:
        {
//            self.hidesBottomBarWhenPushed = YES;
            //            SimilarNameQueryVC *similarNameVc =  [[SimilarNameQueryVC alloc] init];
            //            [self.navigationController pushViewController:similarNameVc animated:YES];
        }
            break;
            
        case 3:
        {
//            self.hidesBottomBarWhenPushed = YES;
            //            CheckOpenCaseVC *openCaseVc =  [[CheckOpenCaseVC alloc] init];
            //            [self.navigationController pushViewController:openCaseVc animated:YES];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - PrivateMethods
- (UITableView *)mainTableView {
    if (_mainTableView) {
        return _mainTableView;
    }
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, SCREN_WIDTH, SCREN_HEIGHT-64-30-49) style:UITableViewStylePlain];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.backgroundColor = COLOR_WITH_RGB(240, 244, 249);
    [_mainTableView registerNib:[UINib nibWithNibName:@"PoliceMapTableCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PoliceMapTableCell"];
    
    typeof(self) __weak wself = self;
    _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        wself.pageNumber++;
        [wself getServerData];
    }];
    
    return _mainTableView;
}

-(NSArray *)titleArr {
    if (_titleArr) {
        return _titleArr;
    }
    _titleArr = @[@"爆破作业单位许可证(非营业性)", @"爆破作业人员许可证", @"典当行特种行业许可证", @"大型群众性活动许可证", @"公章刻制业特种行业许可证", @"烟花爆竹道路运输许可证", @"剧毒化学品购买许可证"];
    return _titleArr;
}

//-(ServiceMapDataModel *)dataModel {
//    if (_dataModel) {
//        return _dataModel;
//    }
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"map_result" ofType:@"txt"];
//    NSError *error;
//    NSString *str = [NSString stringWithContentsOfFile:path encoding: NSUTF8StringEncoding error:&error];
//    if (error) {
//        NSLog(@"error = %@", error);
//    }
//    
//    if (str) {
//        NSLog(@"str= %@", str);
//    }
//  
//      _dataModel = [[ServiceMapDataModel alloc] init];
//    return _dataModel;
//}

@end
