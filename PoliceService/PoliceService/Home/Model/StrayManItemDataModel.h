//
//  StrayManItemDataModel.h
//  PoliceService
//
//  Created by horse on 2017/3/14.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "FSJSONModel.h"
@protocol StrayManItemDataModel;
@interface StrayManItemDataModel : FSJSONModel
@property(nonatomic) NSString *strayMan;
@property(nonatomic) NSString *sex;
@property(nonatomic) NSString *height;
@property(nonatomic) NSString *characteristic;
@property(nonatomic) NSString *dress;
@property(nonatomic) NSString *personalEffects;
@property(nonatomic) NSString *lostPlace;
@property(nonatomic) NSString *lostTime;
@property(nonatomic) NSString *policeCall;
@end
