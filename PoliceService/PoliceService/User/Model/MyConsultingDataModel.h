//
//  MyConsultingDataModel.h
//  PoliceService
//
//  Created by horse on 2017/4/10.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "FSJSONModel.h"
@protocol MyConsultingItemModel;
@interface MyConsultingItemModel : FSJSONModel
@property(nonatomic) NSString<Optional> *name;
@property(nonatomic) NSString<Optional> *business;
@property(nonatomic) NSString<Optional> *finishTime;
@property(nonatomic) NSString<Optional> *caseNumber;
@property(nonatomic) NSString<Optional> *cjsj;
@property(nonatomic) NSString<Optional> *content;
@property(nonatomic) NSString<Optional> *id;
@property(nonatomic) NSString<Optional> *idcard;
@property(nonatomic) NSString<Optional> *location;
@property(nonatomic) NSString<Optional> *password;
@property(nonatomic) NSString<Optional> *phone;
@property(nonatomic) NSString<Optional> *place;
@property(nonatomic) NSString<Optional> *type;
@property(nonatomic) NSString<Optional> *ztdm;
@property(nonatomic) NSString<Optional> *commentName;
@property(nonatomic) NSString<Optional> *answer;


@end

@interface MyConsultingDataModel : FSJSONModel
@property(nonatomic, assign) NSInteger count;
@property(nonatomic, strong) NSMutableArray<MyConsultingItemModel> *list;
@end
