//
//  LostItemDataModel.h
//  PoliceService
//
//  Created by horse on 2017/3/14.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "FSJSONModel.h"
@protocol LostItemDataModel;
@interface LostItemDataModel : FSJSONModel
@property(nonatomic) NSString *loser;
@property(nonatomic) NSString *lostItemName;
@property(nonatomic) NSString *lostItemAdress;
@property(nonatomic) NSString *lostItemDetails;
@property(nonatomic) NSString *lostTime;
@property(nonatomic) NSString *policeCall;
@end
