//
//  BaseTableDataSource.h
//  PoliceService
//
//  Created by horse on 2017/3/3.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCell+TableDataBase.h"

typedef void(^ZCellSelectedBlock)(id obj);
typedef NSString* (^ZSetCellIdentifierBlock)(NSIndexPath *indexPath);
typedef NSInteger (^ZRowsInSectionBlock)(NSInteger section);
typedef NSInteger (^ZNumberOfSectionBlock)(void);
typedef CGFloat (^ZHeightForRowBlock)(NSIndexPath *indexPath);
typedef id (^ZConfigCellDataBlock)(NSIndexPath *indexPath);

@interface BaseTableDataSource : NSObject<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSArray *cellData;                     // cell数据
@property (nonatomic, copy) ZCellSelectedBlock cellSelectedBlock;   // cell点击事件
@property (nonatomic, copy) ZSetCellIdentifierBlock cellIdentifierBlock; //配置cell的标识
@property (nonatomic, copy) ZRowsInSectionBlock rowsInSectionBlock; //配置每个section的cell数量，如果只有一个section，那么就用serverData 的数量作为cell数量。
@property (nonatomic, copy) ZHeightForRowBlock heightForRowBlock; //配置cell行高
@property (nonatomic, copy) ZConfigCellDataBlock configCellDataBlock; //返回当前indexPath对应的Cell所需的数据
@property (nonatomic, copy) ZNumberOfSectionBlock numberOfSectionBlock; //返回section的数量
/**
 *  初始化dataSource
 *
 *  @param serverData  服务器返回数据
 *
 *  @return Datasource
 */
- (id)initWithData:(NSArray *)data;

@end
