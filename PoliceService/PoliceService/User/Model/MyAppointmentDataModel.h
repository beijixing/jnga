//
//  MyAppointmentDataModel.h
//  PoliceService
//
//  Created by 郑光龙 on 2017/4/14.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "FSJSONModel.h"



@interface MyAppointmentBookDepartTimeItemModel : FSJSONModel
@property (nonatomic) NSString<Optional> *endTime;
@property (nonatomic) NSString<Optional> *startTime;
@property (nonatomic) NSString *id;
@property (nonatomic) BOOL isNewRecord;
@end

@interface MyAppointmentBusinessModel : FSJSONModel
@property (nonatomic) NSString<Optional> *name;
@property (nonatomic) NSString *id;
@end

@interface MyAppointmentDepartModel  : FSJSONModel
@property (nonatomic) NSString *id;
@property (nonatomic) NSString<Optional> *name;
@property (nonatomic) NSInteger type;
@end

@interface MyAppointmentUserModel : FSJSONModel
@property (nonatomic) NSString<Optional> *name;
@property (nonatomic) NSString *id;
@property (nonatomic) NSString<Optional> *usercard;
@property (nonatomic) NSString<Optional> *phone;
@end

@protocol MyAppointmentItemModel;
@interface MyAppointmentItemModel : FSJSONModel
@property (nonatomic) NSString *bookDate;
@property (nonatomic) MyAppointmentBookDepartTimeItemModel *bookDepartTime;
@property (nonatomic) MyAppointmentBusinessModel *business;
@property (nonatomic) NSString<Optional> *businessType;
@property (nonatomic) NSString<Optional> *compName;
@property (nonatomic) NSString *createDate;
@property (nonatomic) MyAppointmentDepartModel *depart;
@property (nonatomic) NSString<Optional> *funcClassification;
@property (nonatomic) NSString *id;
@property (nonatomic) NSString<Optional> *funcName;
@property (nonatomic) NSInteger status;
@property (nonatomic) MyAppointmentUserModel *user;
@end

@interface MyAppointmentDataModel : FSJSONModel
@property (nonatomic) NSInteger count;
@property (nonatomic) NSMutableArray<MyAppointmentItemModel> *list;
@end
