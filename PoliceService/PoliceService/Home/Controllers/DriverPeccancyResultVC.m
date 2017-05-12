//
//  DriverPeccancyVC.m
//  PoliceService
//
//  Created by horse on 2017/3/2.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "DriverPeccancyResultVC.h"

@interface DriverPeccancyResultVC ()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *clearDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *driveCardNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *driverCardCityLabel;
@property (strong, nonatomic) IBOutlet UILabel *lostScoreLabel;

@end

@implementation DriverPeccancyResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"驾驶证查询";
    [self setUpLeftNavbarItem];
}

- (void)setUpLeftNavbarItem {
//    typeof(self) __weak wself = self;
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
        
    }];
}

@end
