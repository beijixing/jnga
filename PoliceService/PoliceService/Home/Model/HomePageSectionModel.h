//
//  HomePageSectionModel.h
//  PoliceService
//
//  Created by WenJie on 2017/5/25.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "JSONModel.h"
#import "OperationItemModel.h"

@protocol HomePageSectionModel;
@interface HomePageSectionModel : JSONModel

@property (nonatomic, strong) NSString *sectionTitle;
@property (nonatomic, strong) NSArray <OperationItemModel> *itmes;
@end
