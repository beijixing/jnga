//
//  ServiceMapDataModel.h
//  PoliceService
//
//  Created by horse on 2017/2/22.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "FSJSONModel.h"
#import "MapInfoItemDataModel.h"
@protocol MapInfoItemDataModel;
@interface ServiceMapDataModel : FSJSONModel
@property(nonatomic, assign) NSInteger count;
@property(nonatomic, assign) NSInteger pageNo;
@property(nonatomic, assign) NSInteger pageSize;
@property(nonatomic, strong) NSMutableArray<MapInfoItemDataModel> *list;
@end
