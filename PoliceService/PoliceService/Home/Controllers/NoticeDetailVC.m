//
//  NoticeDetailVC.m
//  PoliceService
//
//  Created by horse on 2017/4/6.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "NoticeDetailVC.h"
#import "RequestService.h"
#import "WJHUD.h"
#import "GlobalFunctionManager.h"
@interface NoticeDetailVC ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UITextView *contentTextView;
@property(nonatomic, strong) NSDictionary *noticeDetailDict;
@end

@implementation NoticeDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公告详情";
    [self setUpLeftNavbarItem];
    [self getNoticeData];
}

- (void)setUpLeftNavbarItem {
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
        
    }];
}

- (void)getNoticeData {
    [WJHUD showOnView:self.view];
    typeof(self) __weak wself = self;
    [RequestService getNoticeDetailWithParamDict:@{@"id" : self.noticeId} resultBlock:^(BOOL success, id object) {
        [WJHUD hideFromView:wself.view];
        [GlobalFunctionManager handleServerDataWithController:wself result:success dataObj:object successBlock:^{
            NSLog(@"object=%@", object);
            wself.noticeDetailDict = object[@"data"];
            [wself updateData];
        }];
    }];
}

- (void)updateData {
    self.titleLabel.text = self.noticeDetailDict[@"title"];
    self.timeLabel.text = self.noticeDetailDict[@"updateDate"];
    self.contentTextView.text = self.noticeDetailDict[@"content"];
}

@end
