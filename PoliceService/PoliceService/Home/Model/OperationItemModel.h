//
//  OperationItemModel.h
//  PoliceService
//
//  Created by horse on 2017/2/22.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "FSJSONModel.h"
@protocol OperationItemModel;
@interface OperationItemModel : JSONModel
@property(nonatomic) NSString *id;
@property(nonatomic) NSString<Optional> *name;
@property(nonatomic) NSString<Optional> *photo;
@property(nonatomic) NSString<Optional> *title;
@property(nonatomic) NSString<Optional> *img_url;
@property(nonatomic) NSString<Optional> *keyword;
@property(nonatomic) NSString<Optional> *desc;
@property(nonatomic) NSString<Optional> *vc;
@property(nonatomic) BOOL shouldLogin;
@property(nonatomic) NSString<Optional> *urlString;
@property(nonatomic) NSString<Optional> *dataType;
@property(nonatomic) NSString<Optional> *parentId;


@end
