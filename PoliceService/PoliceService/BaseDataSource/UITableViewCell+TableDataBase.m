//
//  UITableViewCell+TableDataBase.m
//  PoliceService
//
//  Created by horse on 2017/3/3.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "UITableViewCell+TableDataBase.h"

@implementation UITableViewCell (TableDataBase)
+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

- (void)configCellWithEntity:(id)entity
{
    
}
@end
