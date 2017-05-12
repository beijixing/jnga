//
//  StrayManServerDataModel.h
//  PoliceService
//
//  Created by horse on 2017/3/14.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "FSJSONModel.h"
#import "StrayManItemDataModel.h"
@interface StrayManServerDataModel : FSJSONModel
@property(nonatomic, assign) NSInteger count;
@property(nonatomic, assign) NSInteger pageNo;
@property(nonatomic, assign) NSInteger pageSize;
@property(nonatomic, strong) NSMutableArray<StrayManItemDataModel> *list;
@end
