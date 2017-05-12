//
//  AffairsGuideSubDataModel.h
//  PoliceService
//
//  Created by horse on 2017/2/23.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "FSJSONModel.h"
#import "AffairsGuideItemDataModel.h"
@interface AffairsGuideSubDataModel : FSJSONModel
@property(nonatomic, strong) NSArray<AffairsGuideItemDataModel> *data;
@end
