//
//  BaseTableDataSource.m
//  PoliceService
//
//  Created by horse on 2017/3/3.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "BaseTableDataSource.h"
#import "FSMacro.h"
@implementation BaseTableDataSource
- (id)initWithData:(NSArray *)data {
    if (self = [super init]) {
        self.cellData = data;
    }
    return self;
}
#pragma mark - UITableviewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(self.cellIdentifierBlock != NULL, @"cellIdentifierBlock identifier can't be null");
    NSString *identifier = self.cellIdentifierBlock(indexPath);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.rowsInSectionBlock) {
        return self.rowsInSectionBlock(section);
    }else {
        return self.cellData.count;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.numberOfSectionBlock) {
        return self.numberOfSectionBlock();
    }
    else {
        return 1;
    }
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.configCellDataBlock) {
        [cell configCellWithEntity:self.configCellDataBlock(indexPath)];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(self.heightForRowBlock != NULL, @"heightForRowBlock can't be null");
    return self.heightForRowBlock(indexPath);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.cellSelectedBlock) {
        self.cellSelectedBlock(indexPath);
    }
}
@end
