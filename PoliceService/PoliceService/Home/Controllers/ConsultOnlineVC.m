//
//  ConsultOnlineVC.m
//  PoliceService
//
//  Created by fosung on 2017/5/24.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "ConsultOnlineVC.h"
#import "WJTextView.h"
#import "ReservationHandle.h"
#import "PopoverView.h"
#import "WJHUD.h"
#import "Validator.h"
#import "RequestService.h"
#import "GlobalVariableManager.h"

@interface ConsultOnlineVC ()
@property (weak, nonatomic) IBOutlet UILabel *substationLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UITextField *themTF;
@property (weak, nonatomic) IBOutlet WJTextView *contentTV;
@property (nonatomic, strong) ReservationHandle *handle;

@property (nonatomic, strong) NSString *selectedArchBusicClassId;
@property(nonatomic, strong) NSString *selectedPoliceSubstationId;
@property(nonatomic, strong) NSString *selectedSubbureauId;

@end

@implementation ConsultOnlineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.handle = [ReservationHandle new];
    [self setupSelectLabel];
    [self setUpLeftNavbarItem];
//    self.contentTV.placeHolder = @"请输入...";
    self.title = @"在线咨询";
}

- (void)setupSelectLabel {
    self.substationLabel.font = [UIFont fontWithName:@"iconfont" size:15.0];
    self.substationLabel.text = @"请选择分局 \U0000E601";
    
    self.unitLabel.font = [UIFont fontWithName:@"iconfont" size:15.0];
    self.unitLabel.text = @"请选择单位 \U0000E601";
}
- (void)setUpLeftNavbarItem {
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)submit:(id)sender {
    
    
    if ([Validator isSpaceOrEmpty:_selectedSubbureauId]) {
        [WJHUD showText:@"请选择分局" onView:self.view];
        return;
    }
    
    if ([Validator isSpaceOrEmpty:_selectedPoliceSubstationId]) {
        [WJHUD showText:@"请选择单位" onView:self.view];
        return;
    }
    if ([Validator isSpaceOrEmpty:_themTF.text]) {
        [WJHUD showText:@"请输入主题" onView:self.view];
        return;
    }
    if ([Validator isSpaceOrEmpty:_contentTV.text]) {
        [WJHUD showText:@"请输入内容" onView:self.view];
        return;
    }

    [RequestService consultOnlineWithParamDict:
                                                @{@"fcard":[GlobalVariableManager manager].codeId ?:@"",
                                                 @"id":_selectedPoliceSubstationId ?:@"",
                                                 @"ftitle":_themTF.text?:@"",
                                                 @"fdetail":_contentTV.text?:@""}
                                   resultBlock:^(BOOL success, id object) {
                                       if (success) {
                                           [WJHUD showText:@"提交成功" onView:self.view];
                                       }else{

                                       }
    }];
    
}
- (IBAction)selectSubstation:(UITapGestureRecognizer *)sender {
    [self.handle getPoliceAry:^(id ary, BOOL success) {
        if (success) {
            NSMutableArray *popOverActions = [[NSMutableArray alloc] init];
            
            for (NSDictionary* subbureauDict in ary) {
                PopoverAction *action = [PopoverAction actionWithTitle:subbureauDict[@"text"] handler:^(PopoverAction *action) {
                    self.substationLabel.text = action.title;
                    self.selectedSubbureauId = subbureauDict[@"value"];
                    self.handle.police = subbureauDict[@"value"];
                    self.selectedPoliceSubstationId = @"";
                    self.unitLabel.text = @"请选择单位 \U0000E601";
                }];
                [popOverActions addObject:action];
            }
            [self showPopoverViewWithView:sender.view actions:popOverActions];
        }
    }];

}

- (IBAction)selectUnit:(UITapGestureRecognizer *)sender {
    [self.handle getStationAry:^(id ary, BOOL success) {
        if (success) {
            NSMutableArray *popOverActions = [[NSMutableArray alloc] init];
            
            for (NSDictionary* subbureauDict in ary) {
                PopoverAction *action = [PopoverAction actionWithTitle:subbureauDict[@"text"] handler:^(PopoverAction *action) {
                    self.unitLabel.text = action.title;
                    self.selectedPoliceSubstationId = subbureauDict[@"value"];
                    self.handle.station = subbureauDict[@"value"];
                }];
                [popOverActions addObject:action];
            }
            [self showPopoverViewWithView:sender.view actions:popOverActions];
        }
    }];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
