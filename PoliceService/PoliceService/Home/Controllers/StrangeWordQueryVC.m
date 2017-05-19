//
//  StrangeWordQueryVC.m
//  PoliceService
//
//  Created by fosung on 2017/5/16.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "StrangeWordQueryVC.h"
#import "FSMacro.h"
#import "UIFactory.h"
#import "WJHUD.h"
#import "RequestService.h"
#import "WJAttributeString.h"
@interface StrangeWordQueryVC ()
@property (strong, nonatomic) IBOutlet UITextField *searchTF;
@property (strong, nonatomic) IBOutlet UIView *searchResultContainer;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *resultContainerHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *resultContainerTopSpace;
@property (weak, nonatomic) IBOutlet UILabel *searchResultLabel;
@end

@implementation StrangeWordQueryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"生僻字查询";
    [self setUpLeftNavbarItem];
    [self setupSearchTextFieldLeftView];
    
    self.resultContainerHeight.constant = 0;
    self.resultContainerTopSpace.constant = 0;
}
- (void)setupSearchTextFieldLeftView {
    UIImageView *sImage = [[UIImageView alloc] initWithFrame:CGRectMake(10*KSCALE, 0, 30*KSCALE, 30*KSCALE)];
    sImage.tintColor = COLOR_WITH_RGB(49, 158, 229);
    sImage.image = [UIImage imageNamed:@"sousuo"];
    UIView *leftView = [UIFactory createViewWith:CGRectMake(0, 0, 50*KSCALE, 30*KSCALE) backgroundColor:[UIColor clearColor]];
    [leftView addSubview:sImage];
    self.searchTF.leftView=leftView;
    self.searchTF.leftViewMode=UITextFieldViewModeAlways;
}

- (void)setUpLeftNavbarItem {
    //    typeof(self) __weak wself = self;
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
        
    }];
}
- (IBAction)queryAction:(UIButton *)sender {
    
    if (self.searchTF.text.length < 1) {
        [WJHUD showText:@"请输入待查汉字" onView:self.view];
        return;
    }
    [self searchStrangeWordNum];
    
}
- (void)searchStrangeWordNum {
    [WJHUD showOnView:self.view];
    typeof(self) __weak wself = self;

    [RequestService getStrangeWordWithParamDict:@{@"id":self.searchTF.text} resultBlock:^(BOOL success, id object) {

        [WJHUD hideFromView:wself.view];
        if (success) {
            NSDictionary *dataDict = (NSDictionary *)object;
            if ([[dataDict objectForKey:@"error_code"] integerValue] == 0) {
                
                NSString *strangeWord = [dataDict objectForKey:@"data"];
                
                if (strangeWord.length>0) {
                    
                    NSString *string1 = @"您好，查询生僻字";
                    NSString *string2 = @"成功";
                    NSString *string3 = @"，存在生僻字";
                    NSString *string4 = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"data"]];
                    
                    string1.textColor = [UIColor blackColor];
                    string2.textColor = [UIColor redColor];
                    string3.textColor = [UIColor blackColor];
                    string4.textColor = [UIColor redColor];
                    self.searchResultLabel.attributedText = [NSAttributedString attributeStringWithArray:@[string1,string2,string3,string4]];
                    
                    
                    self.resultContainerHeight.constant = 50;
                    self.resultContainerTopSpace.constant = 15;
                }else{
                    [WJHUD showText:@"无生僻字" onView:wself.view];
                }

            }else {
                [WJHUD showText:[dataDict objectForKey:@"error"] onView:wself.view];
            }
        }
        else {
            
            NSLog(@"object=%@", object);
        }
    }];
    
    
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
