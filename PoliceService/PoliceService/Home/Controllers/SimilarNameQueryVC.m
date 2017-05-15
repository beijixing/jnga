//
//  SimilarNameQueryVC.m
//  PoliceService
//
//  Created by horse on 2017/2/20.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "SimilarNameQueryVC.h"
#import "FSMacro.h"
#import "UIFactory.h"
#import "WJHUD.h"
#import "RequestService.h"
@interface SimilarNameQueryVC ()
@property (strong, nonatomic) IBOutlet UITextField *searchTF;
@property (strong, nonatomic) IBOutlet UIView *searchResultContainer;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *resultContainerHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *resultContainerTopSpace;
@property (weak, nonatomic) IBOutlet UILabel *searchResultLabel;

@end

@implementation SimilarNameQueryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重名查询";
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


- (void)searchNameNum {
    [WJHUD showOnView:self.view];
    typeof(self) __weak wself = self;
    [RequestService getNameNumWithParamDict:@{@"id":self.searchTF.text} resultBlock:^(BOOL success, id object) {
        [WJHUD hideFromView:wself.view];
        if (success) {
            NSDictionary *dataDict = (NSDictionary *)object;
            if ([[dataDict objectForKey:@"error_code"] integerValue] == 0) {
                
                
                self.searchResultLabel.text = [NSString stringWithFormat:@"您好，本次查询内容仅限济宁市。查询重名操作成功，存在重名，重名个数%@",[dataDict objectForKey:@"data"]];
                
                self.resultContainerHeight.constant = 70;
                self.resultContainerTopSpace.constant = 15;
                
//                NSDictionary *data = [dataDict objectForKey:@"data"];
//                if (!wself.dataModel) {
//                    NSError *error;
//                    wself.dataModel = [[StrayManServerDataModel alloc] initWithDictionary:data error:&error];
//                    NSLog(@"error=%@", error);
//                }else {
//                    StrayManServerDataModel *tmpDataModel = [[StrayManServerDataModel alloc] initWithDictionary:data error:nil];
//                    [wself.dataModel.list addObjectsFromArray:tmpDataModel.list];
//                }
//                
                }else {
                [WJHUD showText:[dataDict objectForKey:@"message"] onView:wself.view];
            }
        }
        else {
            
            NSLog(@"object=%@", object);
        }
    }];
    

}


- (IBAction)queryAction:(UIButton *)sender {
    
    if (self.searchTF.text.length < 1) {
        [WJHUD showText:@"请输入待查姓名" onView:self.view];
        return;
    }
    [self searchNameNum];

}

@end
