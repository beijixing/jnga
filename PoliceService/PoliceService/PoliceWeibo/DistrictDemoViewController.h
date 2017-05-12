//
//  DistrictDemoViewController.h
//  PoliceService
//
//  Created by horse on 2017/2/9.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
@interface DistrictDemoViewController : UIViewController<BMKMapViewDelegate>

@property (strong, nonatomic) IBOutlet BMKMapView *mapView;


@end
