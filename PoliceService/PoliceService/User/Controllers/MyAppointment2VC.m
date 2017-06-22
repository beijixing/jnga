//
//  MyAppointment2VC.m
//  PoliceService
//
//  Created by fosung on 2017/6/21.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "MyAppointment2VC.h"
#import "WJHUD.h"
#import "RequestService.h"
#import "GlobalVariableManager.h"
#import "UDIDManager.h"

@interface MyAppointment2VC ()

@end

@implementation MyAppointment2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的预约";
    [self setUpLeftNavbarItem];
    [self getData];
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
-(void)getData{
    [WJHUD showOnView:self.view];
    [RequestService getMyAppointment2WithParamDict:@{@"fcard":@"370983198805100579",
                                                     @"uuid":@"99000558707271",
                                                     @"token":@"dea4358328494df1852776392dc35751G170622416"
                                                     } resultBlock:^(BOOL success, id  _Nullable object) {
                                                         [WJHUD hideFromView:self.view];
                                                         if (success) {
                                                             
                                                         }
                                                     }];
//    [RequestService getMyAppointment2WithParamDict:@{@"fcard":[GlobalVariableManager manager].codeId,
//                                                 @"uuid":[UDIDManager getUDID],
//                                                 @"token":[GlobalVariableManager manager].loginToken
//                                                 } resultBlock:^(BOOL success, id  _Nullable object) {
//                                                     [WJHUD hideFromView:self.view];
//                                                     if (success) {
//                                                         
//                                                     }
//                                                 }];
    
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
