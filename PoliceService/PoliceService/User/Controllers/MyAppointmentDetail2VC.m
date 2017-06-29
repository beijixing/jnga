//
//  MyAppointmentDetail2VC.m
//  PoliceService
//
//  Created by fosung on 2017/6/28.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "MyAppointmentDetail2VC.h"
#import "RequestService.h"
#import "WJHUD.h"
#import "GlobalVariableManager.h"
#import "UDIDManager.h"

@interface MyAppointmentDetail2VC ()
@property (strong, nonatomic) NSDictionary *dataDic;
@end

@implementation MyAppointmentDetail2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"预约详情";
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
    
    [RequestService getMyAppointmentDetail2WithParamDict:
     @{
       @"fcard":[GlobalVariableManager manager].codeId,
       @"id":_detailID,
       @"uuid":[UDIDManager getUDID],
       @"token":[GlobalVariableManager manager].loginToken
       } resultBlock:^(BOOL success, id  _Nullable object) {
           [WJHUD hideFromView:self.view];
           if (success) {
               if (!_dataDic) {
                   self.dataDic = [NSDictionary new];
               }
               self.dataDic = [object objectForKey:@"data"];
               [self setContent];
           }
       }];
}

-(void)setContent{
    
    self.policeStationLabel.text = [_dataDic objectForKey:@"fstation"];
    self.appointmentBusinessLabel.text = [_dataDic objectForKey:@"fbusioness"];
    self.bookDateLabel.text = [_dataDic objectForKey:@"fdate"];
    self.bookTimeLabel.text = [_dataDic objectForKey:@"fperiod"];
    self.progressLabel.text = [_dataDic objectForKey:@"fstate"];
    self.replyTimeLabel.text = [_dataDic objectForKey:@"ftimeR"];
    self.replyContentTextView.text = [_dataDic objectForKey:@"fdetail"];
    
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
