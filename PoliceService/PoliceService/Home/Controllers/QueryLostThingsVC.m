//
//  QueryLostThingsVC.m
//  PoliceService
//
//  Created by horse on 2017/3/2.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "QueryLostThingsVC.h"
#import "WJTextView.h"
#import "QueryLostThingsResultVC.h"
@interface QueryLostThingsVC ()
@property (strong, nonatomic) IBOutlet UITextField *nameTF;
@property (strong, nonatomic) IBOutlet UITextField *thingsNameTF;
@property (strong, nonatomic) IBOutlet UITextField *addressTF;
@property (strong, nonatomic) IBOutlet WJTextView *descriptionTV;

@end

@implementation QueryLostThingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"失物招领、挂失查询";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpLeftNavbarItem];
    self.descriptionTV.placeHolder = @"请输入物品描述";
    self.descriptionTV.fontOfPlaceHolder = [UIFont fontWithName:@"Arial" size:14.0];
}

- (void)setUpLeftNavbarItem {
//    typeof(self) __weak wself = self;
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
        
    }];
}
- (IBAction)queryBtnAction:(UIButton *)sender {
    
    NSCharacterSet *characterSet = [NSMutableCharacterSet characterSetWithCharactersInString:@"物品描述："];
    
    NSString *desc = [self.descriptionTV.text stringByTrimmingCharactersInSet:characterSet];
    
    NSDictionary *paramDict = @{@"loser":self.nameTF.text !=nil ? self.nameTF.text : @"",
                                @"lostItemName":self.thingsNameTF.text != nil ? self.thingsNameTF.text : @"",
                                @"lostItemAdress":self.addressTF.text !=nil ? self.addressTF.text : @"" ,
                                @"lostItemDetails": desc !=nil ? desc : @""
                                };
    QueryLostThingsResultVC *detailVc = [[QueryLostThingsResultVC alloc] init];
    detailVc.queryParamDict = paramDict;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVc animated:YES];
}

@end
