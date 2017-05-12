//
//  MemberCenterTableDataSource.m
//  PoliceService
//
//  Created by horse on 2017/3/3.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "MemberCenterTableDataSource.h"

@implementation MemberCenterTableDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section){
        case 0:
            return 0;
            break;
        case 1:
            return 10;
            break;
        case 2:
            return 10;
            break;
        default:
            return 0;
            break;
    }
}
@end
