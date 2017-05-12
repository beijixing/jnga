//
//  PoliceWeiboVC.m
//  PoliceApp
//
//  Created by horse on 16/9/18.
//  Copyright © 2016年 zgl. All rights reserved.
//

#import "PoliceWeiboVC.h"
#import "DistrictDemoViewController.h"
#import "HomeVC.h"
@interface PoliceWeiboVC ()

@end

@implementation PoliceWeiboVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)gotoSearchController:(id)sender {
    DistrictDemoViewController *ctl = [[DistrictDemoViewController alloc] init];
    
    
    [self.navigationController pushViewController:ctl animated:YES];
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
