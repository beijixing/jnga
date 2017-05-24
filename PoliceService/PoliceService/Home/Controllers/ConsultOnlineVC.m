//
//  ConsultOnlineVC.m
//  PoliceService
//
//  Created by fosung on 2017/5/24.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "ConsultOnlineVC.h"
#import "WJTextView.h"

@interface ConsultOnlineVC ()
@property (weak, nonatomic) IBOutlet UILabel *substationLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UITextField *themTF;
@property (weak, nonatomic) IBOutlet WJTextView *contentTV;

@end

@implementation ConsultOnlineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)submit:(id)sender {
}
- (IBAction)selectSubstation:(id)sender {
}
- (IBAction)selectUnit:(id)sender {
    
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
