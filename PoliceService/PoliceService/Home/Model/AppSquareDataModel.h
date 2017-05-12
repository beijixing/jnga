//
//  AppSquareDataModel.h
//  PoliceService
//
//  Created by horse on 2017/2/23.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "FSJSONModel.h"
@protocol AppSquareItemDataModel;
@interface AppSquareItemDataModel : FSJSONModel
@property(nonatomic, assign) NSInteger id;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *img_url;
@property(nonatomic, strong) NSString<Optional> *keyword;
@end

@protocol AppSquareSectionDataModel;
@interface AppSquareSectionDataModel : FSJSONModel
@property(nonatomic, assign) NSInteger type_id;
@property(nonatomic, strong) NSString *type_name;
@property(nonatomic, strong) NSArray<AppSquareItemDataModel> *items;
@end


@interface AppSquareDataModel : FSJSONModel
@property(nonatomic, strong) NSArray<AppSquareSectionDataModel> *datas;
@end
