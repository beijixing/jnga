//
//  MyConsultingDetailVC.m
//  PoliceService
//
//  Created by horse on 2017/4/10.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "MyConsultingDetailVC.h"

@interface MyConsultingDetailVC ()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameTitlelabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneContentLabel;
@property (strong, nonatomic) IBOutlet UILabel *idcardLabel;
@property (strong, nonatomic) IBOutlet UILabel *idcardContentLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressContentlabel;
@property (strong, nonatomic) IBOutlet UILabel *areaLabel;
@property (strong, nonatomic) IBOutlet UILabel *areaContentLabel;
@property (strong, nonatomic) IBOutlet UILabel *classLabel;
@property (strong, nonatomic) IBOutlet UILabel *classContentLabel;
@property (strong, nonatomic) IBOutlet UILabel *replyTimeLabel;
@property (strong, nonatomic) IBOutlet UITextView *commentTextView;
@property (nonatomic, strong) NSArray *businessArr;
@end

@implementation MyConsultingDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"咨询详情";
    [self setUpLeftNavbarItem];
    NSArray *titleArr = @[@"1治安", @"2民政", @"3交警", @"4消防", @"5出入境",
                          @"6网安", @"7法制", @"8刑侦", @"9技防", @"10禁毒", @"11经侦", @"12其他"];
    self.businessArr = titleArr;
    NSInteger type = [self.dataItemModel.type integerValue];
    if (type == 6) {
        //我要评警
        [self setupPoliceCommentInfo];
    }else{
        [self setupOtherCommentInfo];
    }
}

- (void)setUpLeftNavbarItem {
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
    }];
}


- (void)setupPoliceCommentInfo {
    self.nameLabel.text = @"评论人姓名:";
    self.phoneLabel.text = @"评论人电话:";
    self.idcardLabel.text = @"评论人身份证号:";
    self.addressLabel.text = @"评论人联系地址:";
    self.areaLabel.text = @"评论对象姓名:";
    self.classLabel.text = @"评论对象所在地区:";
    
    
    self.nameTitlelabel.text = self.dataItemModel.name ?: @"";
    self.phoneContentLabel.text = self.dataItemModel.phone ?: @"";
    self.idcardContentLabel.text = self.dataItemModel.idcard ?: @"";
    self.addressContentlabel.text = self.dataItemModel.location ?: @"";
    self.areaContentLabel.text = self.dataItemModel.commentName ?: @"";
    self.classContentLabel.text = self.dataItemModel.place ?: @"";
    
    NSInteger ztdm = [self.dataItemModel.ztdm integerValue];
    if (ztdm == 0) {
        //未回复
        self.commentTextView.text = self.dataItemModel.content ?: @"";
    }else {
        self.commentTextView.text = self.dataItemModel.answer ?: @"";
    }
    
}

- (void)setupOtherCommentInfo {
    self.nameTitlelabel.text = self.dataItemModel.name ?: @"";
    self.phoneContentLabel.text = self.dataItemModel.phone ?: @"";
    self.idcardContentLabel.text = self.dataItemModel.idcard ?: @"";
    self.addressContentlabel.text = self.dataItemModel.location ?: @"";
    self.areaContentLabel.text = self.dataItemModel.place ?: @"";
    NSInteger businessId = [self.dataItemModel.business integerValue];
    self.classContentLabel.text = businessId < 12 ? self.businessArr[businessId]: @"";
    
    NSInteger ztdm = [self.dataItemModel.ztdm integerValue];
    if (ztdm == 0) {
        //未回复
        self.commentTextView.text = self.dataItemModel.content ?: @"";
    }else {
        self.commentTextView.text = self.dataItemModel.answer ?: @"";
    }
}
@end
