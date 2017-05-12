//
//  DistrictDemoViewController.m
//  PoliceService
//
//  Created by horse on 2017/2/9.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "DistrictDemoViewController.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "Colours.h"


@interface DistrictDemoViewController ()<BMKDistrictSearchDelegate> {
    BMKDistrictSearch *_districtSearch;
}
@property(nonatomic, strong) NSArray *districtArr;
@property(nonatomic, assign) NSInteger currentDistrictId;
@end

@implementation DistrictDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    
    self.currentDistrictId = 0;
    self.districtArr = @[@"济宁市",@"历下区",@"历城区",@"天桥区",@"市中区",@"槐荫区",@"济阳县", @"章丘市"];
    
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    _districtSearch = [[BMKDistrictSearch alloc] init];
    NSLog(@"%@", [BMKMapView class]);
}
-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _districtSearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    [self districtSearch:@"山东省" district: self.districtArr[self.currentDistrictId]];
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _districtSearch.delegate = nil; // 不用时，置nil
}

- (void)districtSearch:(NSString *)city district:(NSString *)district {
    BMKDistrictSearchOption *option = [[BMKDistrictSearchOption alloc] init];
    option.city = city;
    option.district = district;
    BOOL flag = [_districtSearch districtSearch:option];
    if (flag) {
        NSLog(@"district检索发送成功");
    } else {
        NSLog(@"district检索发送失败");
    }
}

/**
 *返回行政区域搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结BMKDistrictSearch果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetDistrictResult:(BMKDistrictSearch *)searcher result:(BMKDistrictResult *)result errorCode:(BMKSearchErrorCode)error {
    NSLog(@"onGetDistrictResult error: %d", error);
    if (error == BMK_SEARCH_NO_ERROR) {
        NSLog(@"\nname:%@\ncode:%d\ncenter latlon:%lf,%lf", result.name, (int)result.code, result.center.latitude, result.center.longitude);
        
        for (NSString *path in result.paths) {
            BMKPolygon* polygon = [self transferPathStringToPolygon:path];
            if (polygon) {
                [_mapView addOverlay:polygon]; // 添加overlay
                if (self.currentDistrictId == 0) {
                    [self mapViewFitPolygon:polygon];
                }
                if (self.currentDistrictId < self.districtArr.count-1) {
                    self.currentDistrictId++;
                    NSLog(@"%ld", self.currentDistrictId);
                    [self districtSearch:@"济南" district:self.districtArr[self.currentDistrictId]];
                }
            }
        }
    }
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolygon class]]) {
        BMKPolygonView *polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        UIColor *color = [UIColor randomColor:0.6];
        polygonView.strokeColor = color;
        color = [UIColor randomColor:0.4];
        polygonView.fillColor = color;
        polygonView.lineWidth = 1;
        polygonView.lineDash = YES;
        return polygonView;
    }
    return nil;
}

//根据polygone设置地图范围
- (void)mapViewFitPolygon:(BMKPolygon *) polygon {
    CGFloat ltX, ltY, rbX, rbY;
    if (polygon.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polygon.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polygon.pointCount; i++) {
        BMKMapPoint pt = polygon.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}

- (BMKPolygon*)transferPathStringToPolygon:(NSString*) path {
    if (path == nil || path.length < 1) {
        return nil;
    }
    NSArray *pts = [path componentsSeparatedByString:@";"];
    if (pts == nil || pts.count < 1) {
        return nil;
    }
    BMKMapPoint *points = new BMKMapPoint[pts.count];
    NSInteger index = 0;
    for (NSString *ptStr in pts) {
        if (ptStr && [ptStr rangeOfString:@","].location != NSNotFound) {
            NSRange range = [ptStr rangeOfString:@","];
            NSString *xStr = [ptStr substringWithRange:NSMakeRange(0, range.location)];
            NSString *yStr = [ptStr substringWithRange:NSMakeRange(range.location + range.length, ptStr.length - range.location - range.length)];
            if (xStr && xStr.length > 0 && [xStr respondsToSelector:@selector(doubleValue)]
                && yStr && yStr.length > 0 && [yStr respondsToSelector:@selector(doubleValue)]) {
                points[index] = BMKMapPointMake(xStr.doubleValue, yStr.doubleValue);
                index++;
            }
        }
    }
    BMKPolygon *polygon = nil;
    if (index > 0) {
        polygon = [BMKPolygon polygonWithPoints:points count:index];
    }
    delete [] points;
    return polygon;
}
@end
