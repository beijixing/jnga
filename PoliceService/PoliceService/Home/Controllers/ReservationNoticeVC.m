//
//  ReservationNoticeVC.m
//  PoliceService
//
//  Created by horse on 2017/3/7.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "ReservationNoticeVC.h"
#import "ReservationDetailVC.h"
#import "ReservationOnlineVC.h"
#import "GlobalVariableManager.h"
@interface ReservationNoticeVC ()

@end

@implementation ReservationNoticeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"业务须知";
    UITapGestureRecognizer *tapGsture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(donnotAgree:)];
    [self.view addGestureRecognizer:tapGsture];
    
    [self setUpLeftNavbarItem];
}


- (void)setUpLeftNavbarItem {
    typeof(self) __weak wself = self;
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)donnotAgree:(UITapGestureRecognizer *)gesture{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)agreeAction:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    UIViewController *vc = [[ReservationDetailVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
