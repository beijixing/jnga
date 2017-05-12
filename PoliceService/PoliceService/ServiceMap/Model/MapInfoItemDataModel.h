//
//  MapInfoItemDataModel.h
//  PoliceService
//
//  Created by horse on 2017/2/22.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "FSJSONModel.h"

@interface MapInfoItemDataModel : FSJSONModel
@property(nonatomic, copy) NSString *id;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString<Optional> *distance;
@property(nonatomic, strong) NSString *address;
@property(nonatomic, strong) NSString *tel;
@property(nonatomic, copy)   NSString *longitude;
@property(nonatomic, copy)   NSString *latitude;
@end
