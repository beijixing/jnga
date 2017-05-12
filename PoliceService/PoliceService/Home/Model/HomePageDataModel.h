//
//  HomePageDataModel.h
//  PoliceService
//
//  Created by horse on 2017/2/22.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "FSJSONModel.h"
#import "BannerDataModel.h"
#import "OperationItemModel.h"
@interface HomePageDataModel : JSONModel
@property(nonatomic, strong) NSArray<BannerDataModel> *banners;
@property(nonatomic, strong) NSArray<OperationItemModel> *operate_items;
@end
