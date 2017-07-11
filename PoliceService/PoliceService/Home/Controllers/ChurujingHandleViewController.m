//
//  ChurujingHandleViewController.m
//  PoliceService
//
//  Created by WenJie on 2017/7/4.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "ChurujingHandleViewController.h"
#import "FSEdgeInsetButton.h"
@interface ChurujingHandleViewController ()
@property (weak, nonatomic) IBOutlet FSEdgeInsetButton *cg_btn;
@property (weak, nonatomic) IBOutlet FSEdgeInsetButton *sx_btn;

@end

@implementation ChurujingHandleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"出入境办理";
    
    [self.cg_btn setTitle:@"出国/往来港澳台湾证件申请" forState:UIControlStateNormal];
    [self.sx_btn setTitle:@"双向速递港澳旅游再次签注申请" forState:UIControlStateNormal];
    
    [self.cg_btn setImage:[UIImage imageNamed:@"cgbl"] forState:UIControlStateNormal];
    [self.sx_btn setImage:[UIImage imageNamed:@"sxbl"] forState:UIControlStateNormal];

    [self.cg_btn setCompositionStyle:FSButtonCompositionStyleVerticalImageTitle];
    [self.sx_btn setCompositionStyle:FSButtonCompositionStyleVerticalImageTitle];
    
    self.cg_btn.imageTitleSpace = 10;
    self.sx_btn.imageTitleSpace = 10;

    self.cg_btn.horizontalEdgeSpace = 15;
    self.sx_btn.horizontalEdgeSpace = 15;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
