//
//  ReservationDetailVC.m
//  PoliceService
//
//  Created by horse on 2017/2/17.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "ReservationDetailVC.h"
#import "FSMacro.h"
#import "UIFactory.h"
#import "UIView+CornerRadius.h"
#import "PopoverView.h"
#import "GlobalVariableManager.h"
#import "ReservationSuccessVC.h"
#import "RequestService.h"
#import "WJHUD.h"
#import "GlobalFunctionManager.h"
#import "ReservationHandle.h"


@interface ReservationDetailVC ()
    

@property (strong, nonatomic) IBOutlet UILabel *subbureauLabel;
@property (strong, nonatomic) IBOutlet UILabel *policeSubstationLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *durationLabel;
@property (strong, nonatomic) UIView *dateContainerView;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *policeCategoryLabel;

@property (nonatomic, strong) NSString *selectedArchBusicClassId;
@property(nonatomic, strong) NSString *selectedPoliceSubstationId;
@property(nonatomic, strong) NSString *selectedSubbureauId;
@property(nonatomic, strong) NSString *selectedDurationId;
@property(nonatomic, strong) NSString *selectedDateStr;
@property(nonatomic, strong) NSArray *compListArr;
@property(nonatomic, strong) NSArray *departmentArr;
@property(nonatomic, strong) NSArray *departmentTimeArr;
@property(nonatomic, strong) NSString *maxAdvanceDays;
@property(nonatomic, strong) NSString *businessId;
@property(nonatomic, strong) NSArray *businessInfoArr;
@property(nonatomic, strong) NSString *selectedBusiness;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *businessHeightConstraint;
@property (strong, nonatomic) IBOutlet UIView *jgywView;
@property (strong, nonatomic) IBOutlet UILabel *businessLabel;
@property (nonatomic) BOOL isSelectDate;

//vm
@property (nonatomic, strong) ReservationHandle *handle;

@end

@implementation ReservationDetailVC

-(void)viewWillAppear:(BOOL)animated {
  
    [super viewWillAppear: animated];
    if([self.keyword isEqualToString:@"jgyy"]){
        self.businessHeightConstraint.constant = 55;
        self.jgywView.hidden = NO;
        [self getJgyyBusinessInfo];
    }else if ([self.keyword isEqualToString:@"hzhyy"]){
        
    }
    else {
        self.businessHeightConstraint.constant = 0;
        self.jgywView.hidden = YES;
    }
    [self.view addSubview:self.dateContainerView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = [GlobalVariableManager manager].reservationDetailTitle;
    [self setUpLeftNavbarItem];
    [self getDepartmentData];
    [self getBusinessNotice];
    
    self.handle = [ReservationHandle new];
    self.handle.keyword = self.keyword;
}

- (void)getJgyyBusinessInfo {
    typeof(self) __weak wself = self;
    [RequestService getAppDataDictWithParamDict:@{@"type":@"jgyy"} resultBlock:^(BOOL success, id object) {
        [GlobalFunctionManager handleServerDataWithController:wself result:success dataObj:object successBlock:^{
            wself.businessInfoArr = object[@"data"];
        }];
    }];
    
}

- (void)setDefaultData {
    if(self.compListArr.count>0){
        NSDictionary *dataDict = self.compListArr[0];
        self.subbureauLabel.text = [dataDict objectForKey:@"name"];
        self.selectedSubbureauId = [dataDict objectForKey:@"id"];
    }
    
    if (self.departmentArr.count>0) {
        NSDictionary *dataDict = self.departmentArr[0];
        self.policeSubstationLabel.text = [dataDict objectForKey:@"name"];
        self.selectedPoliceSubstationId = [dataDict objectForKey:@"id"];
    }
    
    if (self.departmentTimeArr.count>0) {
        NSDictionary *dataDict = self.departmentTimeArr[0];
        NSString *durationStr = [self getFormatDurationTimeWith:dataDict[@"start_time"] endTime:dataDict[@"end_time"]];
        self.durationLabel.text = durationStr;
        self.maxAdvanceDays = dataDict[@"ahead_schedule_days"];
        self.selectedDurationId = [dataDict objectForKey:@"id"];
    }
    
}

- (void)getDepartmentData {
    typeof(self) __weak wself = self;
    [WJHUD showOnView:self.view];
    [RequestService getWrapBookingPageDataWithParamDict:@{@"code":self.keyword} resultBlock:^(BOOL success, id object) {
        [WJHUD hideFromView:wself.view];
        if (success) {
            NSDictionary *dataDict = (NSDictionary *)object;
            if ([[dataDict objectForKey:@"code"] integerValue] == 1) {
                NSDictionary *data = [dataDict objectForKey:@"data"];
                NSLog(@"data=%@", data);
                wself.businessId = [data objectForKey:@"business_id"];
                wself.compListArr = [data objectForKey:@"compList"];
                wself.departmentArr = [data objectForKey:@"departList"];
                wself.departmentTimeArr = [data objectForKey:@"departtimeList"];
                [wself setDefaultData];
            }else {
                [WJHUD showText:[dataDict objectForKey:@"message"] onView:wself.view];
            }
        }else {
            NSLog(@"object=%@", object);
        }
    }];
}

- (void)getBusinessNotice {
    typeof(self) __weak wself = self;
    [RequestService getBusinessNotesWithParamDict:@{@"keyword" : self.keyword} resultBlock:^(BOOL success, id object) {
        [GlobalFunctionManager handleServerDataWithController:wself result:success dataObj:object successBlock:^{
            NSLog(@"object= %@", object);
            NSArray *dataArr = object[@"data"];
            if (dataArr.count>0) {
                NSDictionary *dataDict = dataArr[0];
                [wself showNotice:dataDict[@"businesscontent"]];
            }
        }];
    }];
}

- (void)showNotice:(NSString *)content {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"业务须知" message:content preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    [self presentViewController:alertController animated:YES completion:^{
    }];
}

- (void)setUpLeftNavbarItem {
//    typeof(self) __weak wself = self;
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
        
    }];
}

/*
 depart_id String 部门id
 user_id String 用户id
 business_id String 业务id
 book_depart_time_id String 预约部门时间段id
 book_date String 预约日期
 max_days_advance int
 */
- (IBAction)commitReservationAction:(id)sender {
    typeof(self) __weak wself = self;
    
    if (self.selectedDateStr == nil) {
        [WJHUD showText:@"请选择预约时间" onView:self.view];
        return;
    }
    
    [WJHUD showOnView:self.view];
    [RequestService saveBookingInfoWithParamDict:@{@"depart_id":self.selectedPoliceSubstationId ?: @"",
                                                   @"func_classification": self.selectedBusiness ?: @"",
                                                   @"user_id":[GlobalVariableManager manager].userId ?: @"",
                                                   @"business_id":self.businessId ?:@"",
                                                   @"book_depart_time_id":self.selectedDurationId ?:@"",
                                                   @"book_date":self.selectedDateStr ?: @"",
                                                   @"max_days_advance":self.maxAdvanceDays ?: @""
                                                       } resultBlock:^(BOOL success, id object) {
                                                           [WJHUD hideFromView:wself.view];
        if (success) {
            NSDictionary *dataDcit = (NSDictionary *)object;
            if([[dataDcit objectForKey:@"code"] integerValue] == 1){
                [wself commitSuccess];
            }else {
                [WJHUD showText:[dataDcit objectForKey:@"message"] onView:wself.view];
            }
            
        }else {
            NSLog(@"object=%@", object);
        }
    }];
    
}
- (void)commitSuccess {
    ReservationSuccessVC *successVc = [[ReservationSuccessVC alloc] init];
    typeof(self) __weak wself = self;
    successVc.quitBtnActionCallBack = ^(){
//        [wself.navigationController popToRootViewControllerAnimated:YES];
    };
    successVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:successVc animated:YES completion:^{
        
    }];
}

- (IBAction)policeCategoryLabelAction:(UITapGestureRecognizer *)sender {
    
    typeof(self) __weak wself = self;
//    [RequestService getArchBusicClassWithParamDict:@{} resultBlock:^(BOOL success, id object) {
//        if (success) {
//            if ([[object objectForKey:@"error_code"] integerValue] == 0) {
//                NSArray *ary = [object objectForKey: @"data"];
//                NSMutableArray *popOverActions = [[NSMutableArray alloc] init];
//                
//                for (NSDictionary* subbureauDict in ary) {
//                    PopoverAction *action = [PopoverAction actionWithTitle:subbureauDict[@"text"] handler:^(PopoverAction *action) {
//                        wself.policeCategoryLabel.text = action.title;
//                        wself.selectedArchBusicClassId = subbureauDict[@"value"];
//                    }];
//                    [popOverActions addObject:action];
//                }
//                [self showPopoverViewWithView:sender.view actions:popOverActions];
//            }
//        }
//        
//    }];
    
    [self.handle getBusiClassAry:^(id ary, BOOL success) {
        if (success) {
            NSMutableArray *popOverActions = [[NSMutableArray alloc] init];
            
            for (NSDictionary* subbureauDict in ary) {
                PopoverAction *action = [PopoverAction actionWithTitle:subbureauDict[@"text"] handler:^(PopoverAction *action) {
                    wself.policeCategoryLabel.text = action.title;
                    wself.selectedArchBusicClassId = subbureauDict[@"value"];
                    wself.handle.busiClassId = subbureauDict[@"value"];
                }];
                [popOverActions addObject:action];
            }
            [wself showPopoverViewWithView:sender.view actions:popOverActions];
        }
    }];

    
   
}

- (IBAction)subbureauLabelAction:(UITapGestureRecognizer * )sender {
        NSMutableArray *popOverActions = [[NSMutableArray alloc] init];
        typeof(self) __weak wself = self;
    
        for (NSDictionary* subbureauDict in self.compListArr) {
            PopoverAction *action = [PopoverAction actionWithTitle:subbureauDict[@"name"] handler:^(PopoverAction *action) {
                NSLog(@"fontName = %@", subbureauDict);
                wself.subbureauLabel.text = action.title;
                wself.selectedSubbureauId = subbureauDict[@"id"];
            }];
            [popOverActions addObject:action];
        }
    
   [self showPopoverViewWithView:sender.view actions:popOverActions];
    


}
- (IBAction)policeSubstationLabelAcion:(UITapGestureRecognizer *)sender {
        NSMutableArray *popOverActions = [[NSMutableArray alloc] init];
        typeof(self) __weak wself = self;
        for (NSDictionary* substationDict in self.departmentArr) {
            PopoverAction *action = [PopoverAction actionWithTitle:substationDict[@"name"] handler:^(PopoverAction *action) {
                NSLog(@"fontName = %@", substationDict);
                wself.policeSubstationLabel.text = action.title;
                wself.selectedPoliceSubstationId = substationDict[@"id"];
            }];
            [popOverActions addObject:action];
        }
    
    [self showPopoverViewWithView:sender.view actions:popOverActions];
}

- (void)showPopoverViewWithView:(UIView *)view  actions:(NSArray *)actions{
    if (actions.count == 0) {
        NSLog(@"showPopoverViewWithView actions 为空");
        return;
    }
    PopoverView* popoverView = [PopoverView popoverView];
    popoverView.style = PopoverViewStyleDefault;
    popoverView.hideAfterTouchOutside = YES; // 点击外部时允许隐藏
    [popoverView showToView:view withActions:actions];
}

- (IBAction)dateLabelAction:(id)sender {
    self.isSelectDate = YES;//选择日期
    self.dateContainerView.hidden = NO;
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
        self.dateContainerView.center = CGPointMake(SCREN_WIDTH/2, (SCREN_HEIGHT-64)/2);
    } completion:^(BOOL finished) {
        
    }];
}
- (IBAction)durationLabelAction:(UITapGestureRecognizer *)sender {
    NSMutableArray *popOverActions = [[NSMutableArray alloc] init];
    typeof(self) __weak wself = self;
    for (NSDictionary* durationDict in self.departmentTimeArr) {
        NSString *durationStr = [self getFormatDurationTimeWith:durationDict[@"start_time"] endTime:durationDict[@"end_time"]];
        
        PopoverAction *action = [PopoverAction actionWithTitle:durationStr handler:^(PopoverAction *action) {
            NSLog(@"fontName = %@", durationDict);
            wself.durationLabel.text = action.title;
            wself.selectedDurationId = durationDict[@"id"];
            wself.maxAdvanceDays = durationDict[@"ahead_schedule_days"];
        }];
        [popOverActions addObject:action];
    }
    
    [self showPopoverViewWithView:sender.view actions:popOverActions];
    
//    self.isSelectDate = NO;//选择时间段
//    self.dateContainerView.hidden = NO;
//    self.datePicker.datePickerMode = UIDatePickerModeTime;
//    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
//        self.dateContainerView.center = CGPointMake(SCREN_WIDTH/2, (SCREN_HEIGHT-64)/2);
//    } completion:^(BOOL finished) {
//        
//    }];
    
}
- (IBAction)selectBusinessAction:(UITapGestureRecognizer *)sender {
    //选择业务
    NSLog(@"selectBusiness");
//    NSMutableArray *popOverActions = [[NSMutableArray alloc] init];
    typeof(self) __weak wself = self;
//    for (NSDictionary*businessDict in self.businessInfoArr) {
//        NSString *des = businessDict[@"label"];
//        
//        PopoverAction *action = [PopoverAction actionWithTitle:des handler:^(PopoverAction *action) {
//            wself.businessLabel.text = action.title;
//            wself.selectedBusiness = businessDict[@"value"];
//        }];
//        [popOverActions addObject:action];
//    }
//    
//    [self showPopoverViewWithView:sender.view actions:popOverActions];
    
    [self.handle getSubBusiClassAry:^(id ary, BOOL success) {
        if (success) {
            NSMutableArray *popOverActions = [[NSMutableArray alloc] init];
            for (NSDictionary* subbureauDict in ary) {
                PopoverAction *action = [PopoverAction actionWithTitle:subbureauDict[@"text"] handler:^(PopoverAction *action) {
                    wself.businessLabel.text = action.title;
                    wself.selectedBusiness = subbureauDict[@"value"];
                }];
                [popOverActions addObject:action];
            }
            [wself showPopoverViewWithView:sender.view actions:popOverActions];
        }
    }];
    
}

- (NSString *)getFormatDurationTimeWith:(NSString *)startTime endTime:(NSString *)endTime {
    //to index 不包含index 对应的字符
    NSString *durationTime = [NSString stringWithFormat:@"%@-%@",[startTime substringToIndex:5], [endTime substringToIndex:5]];
   return durationTime;
}

- (void)confirmAction:(UIButton *)btn {
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
        self.dateContainerView.center = CGPointMake(SCREN_WIDTH*1.5, (SCREN_HEIGHT-64)/2);
    } completion:^(BOOL finished) {
        self.dateContainerView.hidden = YES;
        self.dateContainerView.center = CGPointMake(-SCREN_WIDTH/2, (SCREN_HEIGHT-64)/2);
    }];
}

- (void)cancelAction:(UIButton *)btn {
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
        self.dateContainerView.center = CGPointMake(SCREN_WIDTH*1.5, (SCREN_HEIGHT-64)/2);
    } completion:^(BOOL finished) {
        self.dateContainerView.hidden = YES;
        self.dateContainerView.center = CGPointMake(-SCREN_WIDTH/2, (SCREN_HEIGHT-64)/2);
    }];
}

-(UIView *)dateContainerView {
    if (_dateContainerView) {
        return _dateContainerView;
    }
    
    _dateContainerView = [UIFactory createViewWith:CGRectMake(0, 0, SCREN_WIDTH-30, 240)];
    _dateContainerView.cornerRadius = 8;
    _dateContainerView.hidden = YES;
    _dateContainerView.backgroundColor = COLOR_WITH_RGB(61, 161, 229);
    _dateContainerView.center = CGPointMake(-SCREN_WIDTH/2, (SCREN_HEIGHT-64)/2);
    [_dateContainerView addSubview:self.datePicker];
    
    UIButton *confirmbtn = [UIFactory createButtonWith:CGRectMake(SCREN_WIDTH-30-60, 0, 40, 40) selector:@selector(confirmAction:) target:self titleColor:COLOR_WITH_RGB(255, 255, 255) title:@"确定"];
    UIButton *cancelbtn = [UIFactory createButtonWith:CGRectMake(20, 0, 40, 40) selector:@selector(cancelAction:) target:self titleColor:COLOR_WITH_RGB(255, 255, 255) title:@"取消"];
    
    [_dateContainerView addSubview:cancelbtn];
    [_dateContainerView addSubview:confirmbtn];
    
    return _dateContainerView;
}

- (void)dateChanged:(UIDatePicker *)datePicker {
    
    NSLog(@"date = %@",datePicker.date );
    
   // [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+0900"]]; // 只能够修改该程序的defaultTimeZone，不能修改系统的，更不能修改其他程序的。
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if(self.isSelectDate) {
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        self.dateLabel.text = [dateFormatter stringFromDate:datePicker.date];
    }else {
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString *timeDuration =  [dateFormatter stringFromDate:datePicker.date];
        
        self.durationLabel.text = timeDuration;
    }
    
    NSDate *now = [datePicker date];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.selectedDateStr = [dateFormatter stringFromDate:now];
    NSLog(@"now:%@", [dateFormatter stringFromDate:now]);
    
    // 也可直接修改NSDateFormatter的timeZone变量
    //dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
}

-(UIDatePicker *)datePicker {
    if (_datePicker) {
        return _datePicker;
    }
    //创建一个UIPickView对象
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,40,SCREN_WIDTH-30, 200)];
    //显示方式是只显示年月日
    _datePicker.datePickerMode = UIDatePickerModeDate;
    //设置背景颜色
    _datePicker.backgroundColor = COLOR_WITH_RGB(255, 255, 255);
    [_datePicker setMinimumDate:[NSDate date]];
//    _datePicker.hidden = YES;
    //datePicker.center = self.center;
    //设置本地化支持的语言（在此是中文)
    _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    _datePicker.timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
    //放在盖板上
//    [self.view addSubview:datePicker];
    return _datePicker;
}

//- (PopoverView *)popoverView {
//    if (_popoverView) {
//        return _popoverView;
//    }
//    NSMutableArray *popOverActions = [[NSMutableArray alloc] init];
//    NSArray *titleArr = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
//    
//    for (NSString* fontName in titleArr) {
//        PopoverAction *action = [PopoverAction actionWithTitle:fontName handler:^(PopoverAction *action) {
//            NSLog(@"fontName = %@", fontName);
//            [btn setTitle:[NSString stringWithFormat:@"%@\U0000E601", fontName] forState:UIControlStateNormal];
//        }];
//        [popOverActions addObject:action];
//    }
    
//    _popoverView = [PopoverView popoverView];
//    _popoverView.style = PopoverViewStyleDefault;
//    _popoverView.hideAfterTouchOutside = YES; // 点击外部时允许隐藏
//    [popoverView showToView:btn withActions:popOverActions];
//    return _popoverView;
//}

@end
