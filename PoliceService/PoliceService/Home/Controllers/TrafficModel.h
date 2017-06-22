//
//  TrafficModel.h
//  PoliceService
//
//  Created by WenJie on 2017/6/21.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "FSJSONModel.h"

@protocol TrafficItemModel;
@protocol TrafficSectionModel;

@interface TrafficSectionModel : FSJSONModel

@property (nonatomic, strong) NSString *type_id;
@property (nonatomic, strong) NSString *type_name;
@property (nonatomic, strong) NSArray <TrafficItemModel> *items;

@end

@interface TrafficItemModel : FSJSONModel
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *img_url;
@end

@interface TrafficModel : FSJSONModel
@property (nonatomic) NSArray <TrafficSectionModel> *datas;
@end
