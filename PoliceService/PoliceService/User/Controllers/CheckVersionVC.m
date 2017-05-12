//
//  CheckVersionVC.m
//  PoliceService
//
//  Created by horse on 2017/3/1.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "CheckVersionVC.h"

@interface CheckVersionVC ()
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation CheckVersionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"版本检测";
    [self setUpLeftNavbarItem];
}

- (void)setUpLeftNavbarItem {
//    typeof(self) __weak wself = self;
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
        
    }];
}

@end
