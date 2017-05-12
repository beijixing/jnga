//
//  ReservationSuccessVC.m
//  PoliceService
//
//  Created by horse on 2017/3/7.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "ReservationSuccessVC.h"

@interface ReservationSuccessVC ()

@end

@implementation ReservationSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)quitBtnAction:(UIButton *)sender {
    typeof(self) __weak wself = self;
    [self dismissViewControllerAnimated:YES completion:^{
        if (wself.quitBtnActionCallBack) {
            wself.quitBtnActionCallBack();
        }
    }];
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
