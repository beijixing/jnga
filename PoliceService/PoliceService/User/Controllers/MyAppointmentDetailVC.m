//
//  MyAppointmentDetailVC.m
//  PoliceService
//
//  Created by horse on 2017/3/7.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "MyAppointmentDetailVC.h"
#import "RequestService.h"
#import "GlobalFunctionManager.h"
#import "WJHUD.h"
@interface MyAppointmentDetailVC ()
@property (strong, nonatomic) IBOutlet UILabel *serviceTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *subbureauLabel;
@property (strong, nonatomic) IBOutlet UILabel *paichusuoLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *stateLabel;
@property (strong, nonatomic) IBOutlet UIButton *cancelBookingAction;
@property (nonatomic, strong) NSArray *statusDataArr;

@end

@implementation MyAppointmentDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预约详情";
    [self setUpLeftNavbarItem];
    [self setupDetailInfo];
}

- (void)setupDetailInfo {
    self.serviceTypeLabel.text = self.itemModel.businessType;
    self.subbureauLabel.text = self.itemModel.compName;
    self.paichusuoLabel.text = self.itemModel.depart.name;
    self.timeLabel.text = self.itemModel.createDate;
    self.stateLabel.text = self.statusDataArr[self.itemModel.status-1];
    
    if (self.itemModel.status  > 2) {
        self.cancelBookingAction.hidden = YES;
    }
}

- (void)setUpLeftNavbarItem {
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
        
    }];
}
- (IBAction)cancelBookingAction:(id)sender {
    typeof(self) __weak wself = self;
    [WJHUD showOnView:self.view];
    [RequestService cancelBookingWithParamDict:@{@"id" : self.itemModel.id ?: @"" } resultBlock:^(BOOL success, id object) {
        [WJHUD hideFromView:wself.view];
        [GlobalFunctionManager handleServerDataWithController:wself result:success dataObj:object successBlock:^{
            NSString *message = object[@"message"];
            [WJHUD showText:message onView:wself.view];
            wself.cancelBookingAction.hidden = YES;
            self.stateLabel.text = @"取消预约";
        }];
    }];
}

-(NSArray *)statusDataArr {
    if (_statusDataArr) {
        return _statusDataArr;
    }
    _statusDataArr = @[@"正在预约", @"处理中", @"处理完成", @"取消预约"];
    
    return _statusDataArr;
    
}

@end
