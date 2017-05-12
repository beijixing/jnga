//
//  MoveCarServiceVC.m
//  PoliceService
//
//  Created by horse on 2017/2/17.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "MoveCarServiceVC.h"

@interface MoveCarServiceVC ()
@property (strong, nonatomic) IBOutlet UIButton *callButton;
@property (strong, nonatomic) IBOutlet UILabel *carTypeLabel;
@property (strong, nonatomic) IBOutlet UITextField *carNumberTF;
@property (strong, nonatomic) IBOutlet UITextField *carColorTF;
@property (strong, nonatomic) IBOutlet UITextField *carBrandTF;

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


- (IBAction)commitAction:(id)sender {
    
    
}
@end
