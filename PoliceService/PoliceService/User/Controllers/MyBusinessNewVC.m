//
//  MyBusinessNewVC.m
//  PoliceService
//
//  Created by fosung on 2017/6/28.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "MyBusinessNewVC.h"

@interface MyBusinessNewVC ()

@end

@implementation MyBusinessNewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.title = @"我的业务";
    [self setUpLeftNavbarItem];
}

- (void)setUpLeftNavbarItem {
    //    typeof(self) __weak wself = self;
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
