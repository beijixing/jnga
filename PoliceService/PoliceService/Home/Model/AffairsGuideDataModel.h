//
//  AffairsGuideDataModel.h
//  PoliceService
//
//  Created by horse on 2017/2/23.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "FSJSONModel.h"
#import "BannerDataModel.h"
@protocol AffairsItemDataModel;
@interface AffairsItemDataModel : FSJSONModel
@property(nonatomic, copy) NSString *id;
@property(nonatomic, copy) NSString<Optional>*name;
@property(nonatomic, copy) NSString<Optional>*title;
@property(nonatomic, copy) NSString<Optional>*vc;

@property(nonatomic, copy) NSString<Optional> *imgUrl;
@property(nonatomic, copy) NSString<Optional> *img_url;
@property(nonatomic, copy) NSString<Optional> *parentId;
@end


@interface AffairsGuideDataModel : FSJSONModel
//@property(nonatomic, strong) NSArray<BannerDataModel> *banners;
@property(nonatomic, strong) NSArray<AffairsItemDataModel> *data;
@property(nonatomic, strong) NSArray<BannerDataModel> *banners;
@end
