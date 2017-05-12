//
//  FSJSONModel.h
//  FosungCore
//
//  Created by horse on 2017/1/17.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModelLib.h"
#import "FSJSONKeyMapper.h"
@interface FSJSONModel : JSONModel
+ (FSJSONKeyMapper *)keyMapper;
@end
