//
//  RecomendAppDataModel.h
//  PoliceService
//
//  Created by horse on 2017/2/23.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "FSJSONModel.h"
#import "APPInfoDataModel.h"
#import "BannerDataModel.h"
@interface RecomendAppDataModel : FSJSONModel
@property(nonatomic, strong) NSArray<BannerDataModel> *banners;
@property(nonatomic, strong) NSArray<APPInfoDataModel> *app_items;
@end
