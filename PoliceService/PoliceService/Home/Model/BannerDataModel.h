//
//  BannerDataModel.h
//  PoliceService
//
//  Created by horse on 2017/2/22.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "FSJSONModel.h"
@protocol BannerDataModel;
@interface BannerDataModel : JSONModel
@property(nonatomic, assign) NSInteger id;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *img_url;
@end
