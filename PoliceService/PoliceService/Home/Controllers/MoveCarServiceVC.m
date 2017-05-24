//
//  MoveCarServiceVC.m
//  PoliceService
//
//  Created by horse on 2017/2/17.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "MoveCarServiceVC.h"
#import "PopoverAction.h"
#import "PopoverView.h"
@interface MoveCarServiceVC ()
@property (strong, nonatomic) IBOutlet UIButton *callButton;
@property (strong, nonatomic) IBOutlet UILabel *carTypeLabel;
@property (strong, nonatomic) IBOutlet UITextField *carNumberTF;
@property (strong, nonatomic) IBOutlet UITextField *carColorTF;
@property (strong, nonatomic) IBOutlet UITextField *carBrandTF;


/**车类型*/
@property (nonatomic, strong) NSString *carType;

@end

@implementation MoveCarServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"移车服务";
    [self setUpLeftNavbarItem];
    [self.callButton setTitle:@"\U0000E603" forState:UIControlStateNormal];
    self.callButton.titleLabel.font = [UIFont fontWithName:@"iconfont" size:14.0];
}

- (void)setUpLeftNavbarItem {
//    typeof(self) __weak wself = self;
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
        
    }];
}

- (IBAction)clearTextField:(UIButton *)sender {
    switch (sender.tag) {
        case 1001:
        {
            self.carNumberTF.text = nil;
        }
            break;
        case 1002:
        {
            self.carColorTF.text = nil;
        }
            break;
        case 1003:
        {
            self.carBrandTF.text = nil;
        }
            break;
            
        default:
            break;
    }
}
- (IBAction)selectCarTypeAction:(UIButton *)sender {
    NSArray *ary = @[@"小型汽车",@"大型汽车",@"外籍汽车",@"两,三轮汽车",@"轻便摩托车",@"农用运输车",@"挂车",@"教练汽车",@"临时行驶车"];
    NSMutableArray *popOverActions = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < ary.count; i ++ ) {
        PopoverAction *pop = [PopoverAction actionWithTitle:ary[i] handler:^(PopoverAction *action) {
            self.carType = action.title;
            self.carTypeLabel.text = action.title;
        }];
        [popOverActions addObject:pop];
    }
    [self showPopoverViewWithView:sender actions:popOverActions];
    

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


- (IBAction)commitAction:(id)sender {
    
    
}
@end
