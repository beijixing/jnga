//
//  UITableViewCell+TableDataBase.h
//  PoliceService
//
//  Created by horse on 2017/3/3.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (TableDataBase)
/**
 *  返回nib
 *
 *  @return 返回nib
 */
+ (UINib *)nib;


/**
 *  根据实体,设置cell样式
 *
 *  @param entity 实体
 */
- (void)configCellWithEntity:(id)entity;
@end
