//
//  QueryLostMenVC.m
//  PoliceService
//
//  Created by horse on 2017/3/1.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "QueryLostMenVC.h"
#import "PopoverView.h"
#import "QueryLostMenDetailVC.h"
@interface QueryLostMenVC ()
@property (strong, nonatomic) IBOutlet UITextField *nameTF;
@property (strong, nonatomic) IBOutlet UILabel *sexLabel;
@property (strong, nonatomic) IBOutlet UITextField *heightLabel;
@property (strong, nonatomic) IBOutlet UITextField *featureTF;
@property (strong, nonatomic) IBOutlet UITextField *clothesDesTF;
@property (strong, nonatomic) IBOutlet UITextField *BelongingsTF;
@property (strong, nonatomic) IBOutlet UITextField *lostAddressTF;
@property(nonatomic, strong)  NSDictionary *serverDataDict;
@property(nonatomic, strong) NSString *sex;
@end

@implementation QueryLostMenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"走失人口查询";
    [self setUpLeftNavbarItem];
}
- (void)setUpLeftNavbarItem {
//    typeof(self) __weak wself = self;
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
        
    }];
}


- (IBAction)selectSexAction:(UITapGestureRecognizer *)sender {
    
    NSMutableArray *popOverActions = [[NSMutableArray alloc] init];
    NSArray *titleArr = @[@"男",@"女"];
    typeof(self) __weak wself = self;
    for (NSString* fontName in titleArr) {
        PopoverAction *action = [PopoverAction actionWithTitle:fontName handler:^(PopoverAction *action) {
            wself.sexLabel.text = fontName;
            if ([wself.sexLabel.text isEqualToString:@"男"]) {
                wself.sex = @"1";
            }else {
                wself.sex = @"0";
            }
        }];
        [popOverActions addObject:action];
    }
    
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.style = PopoverViewStyleDark;
    popoverView.hideAfterTouchOutside = YES; // 点击外部时允许隐藏
    [popoverView showToView:self.sexLabel withActions:popOverActions];
}
- (IBAction)queryBtnAction:(id)sender {
    NSDictionary *paramDict = @{@"strayMan":self.nameTF.text !=nil ? self.nameTF.text : @"",
                                @"sex":self.sex != nil ? self.sex : @"1",
                                @"height":self.heightLabel.text !=nil ? self.heightLabel.text : @"" ,
                                @"characteristic":self.featureTF.text  !=nil ? self.featureTF.text : @"" ,
                                @"dress":self.clothesDesTF.text  !=nil ? self.clothesDesTF.text : @"",
                                @"personalEffects":self.BelongingsTF.text  !=nil ? self.BelongingsTF.text : @"",
                                @"lostPlace":self.lostAddressTF.text  !=nil ? self.lostAddressTF.text : @""
                                };
    QueryLostMenDetailVC *detailVc = [[QueryLostMenDetailVC alloc] init];
    detailVc.queryParamDict = paramDict;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVc animated:YES];
}

@end
