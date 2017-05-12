//
//  NewsCenterServerDataModel.h
//  PoliceService
//
//  Created by horse on 2017/3/17.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "FSJSONModel.h"
#import "NewsItemDataModel.h"
@interface NewsCenterServerDataModel : FSJSONModel
@property(nonatomic) NSInteger count;
@property(nonatomic) NSMutableArray<NewsItemDataModel> *list;
@end
