//
//  ReservationDataModel.h
//  PoliceService
//
//  Created by horse on 2017/2/23.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "FSJSONModel.h"
#import "OperationItemModel.h"
@interface ReservationDataModel : FSJSONModel
@property(nonatomic, strong)NSMutableArray<OperationItemModel> *datas;
@end
