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
@property(nonatomic) NSString<Optional> *operate_name;
@property(nonatomic) NSString<Optional> *img_url;
@property(nonatomic) NSString<Optional> *keyword;
@end
