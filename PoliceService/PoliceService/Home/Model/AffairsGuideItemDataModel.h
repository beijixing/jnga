//
//  AffairsGuideItemDataModel.h
//  PoliceService
//
//  Created by horse on 2017/2/23.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "FSJSONModel.h"

@protocol AffairsGuideItemDataModel;
@interface AffairsGuideItemDataModel : FSJSONModel
@property(nonatomic, strong) NSString *id;
@property(nonatomic, strong) NSString *name;
@end
