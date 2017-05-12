//
//  NewsItemDataModel.h
//  PoliceService
//
//  Created by horse on 2017/3/17.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "FSJSONModel.h"
@protocol NewsItemDataModel;
@interface NewsItemDataModel : FSJSONModel
@property(nonatomic) NSString<Optional> *id;
@property(nonatomic) NSString<Optional> *content;
@property(nonatomic) NSString<Optional> *image;
@property(nonatomic) NSString<Optional> *title;
@property(nonatomic) NSString<Optional> *issueDate;
@end
