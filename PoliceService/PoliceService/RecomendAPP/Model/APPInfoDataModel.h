//
//  APPInfoDataModel.h
//  PoliceService
//
//  Created by horse on 2017/2/23.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "FSJSONModel.h"
@protocol APPInfoDataModel;
@interface APPInfoDataModel : FSJSONModel
@property(nonatomic, assign) NSInteger id;
@property(nonatomic, strong) NSString *app_name;
@property(nonatomic, strong) NSString *img_url;
@property(nonatomic, strong) NSString *link_url;
@end
