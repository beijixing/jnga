//
//  MyBusinessVC.m
//  PoliceService
//
//  Created by horse on 2017/2/13.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "MyBusinessVC.h"
#import "SGSegmentedControl.h"
#import "FSMacro.h"
#import "MyBusinessTableCell.h"
#import "BaseTableDataSource.h"
@interface MyBusinessVC ()<SGSegmentedControlDelegate>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) SGSegmentedControl *segmentedControl;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *mainTableDataArr;
@property (nonatomic, strong) BaseTableDataSource *tableDataSource;
@end

NSString *mycellIdentifier = @"cell";
@implementation MyBusinessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的业务";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpLeftNavbarItem];
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.mainTableView];
}

- (void)setUpLeftNavbarItem {
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
    }];
}

-(UITableView *)mainTableView {
    if(_mainTableView){
        return _mainTableView;
    }
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, SCREN_HEIGHT-44) style:UITableViewStylePlain];
    _mainTableView.delegate = self.tableDataSource;
    _mainTableView.dataSource = self.tableDataSource;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.backgroundColor = COLOR_WITH_RGB(240, 244, 249);
    //    if(SCREN_HEIGHT > 568.0){
    //        _operationTableview.scrollEnabled = NO;
    //    }
    [_mainTableView registerNib:[UINib nibWithNibName:@"MyBusinessTableCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:mycellIdentifier];
    return _mainTableView;
}

- (BaseTableDataSource *)tableDataSource {
    if (_tableDataSource) {
        return _tableDataSource;
    }
    _tableDataSource = [[BaseTableDataSource alloc] initWithData:self.mainTableDataArr];
    _tableDataSource.cellIdentifierBlock = ^NSString* (NSIndexPath *indexPath){
        return mycellIdentifier;
    };
    _tableDataSource.heightForRowBlock = ^CGFloat(NSIndexPath *indexPath) {
        return 100*KSCALE;
    };
    typeof(self) __weak wself = self;
    _tableDataSource.configCellDataBlock = ^id(NSIndexPath *indexPath){
        return wself.mainTableDataArr[indexPath.row];
    };
    return _tableDataSource;
}

- (SGSegmentedControl *)segmentedControl {
    if (_segmentedControl) {
        return _segmentedControl;
    }
    _segmentedControl = [SGSegmentedControl segmentedControlWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) delegate:self segmentedControlType:(SGSegmentedControlTypeStatic) titleArr:self.titleArr];
    _segmentedControl.titleColorStateSelected = COLOR_WITH_RGB(105, 179, 234);
    _segmentedControl.titleColorStateNormal = COLOR_WITH_RGB(70, 70, 70);
    _segmentedControl.indicatorColor = COLOR_WITH_RGB(0, 153, 228);
    return _segmentedControl;
}

- (void)SGSegmentedControl:(SGSegmentedControl *)segmentedControl didSelectBtnAtIndex:(NSInteger)index {
    NSArray *tmpDataArr = @[
                          @[@"出生登记办理", @"出生登记办理", @"出生登记办理",@"出生登记办理",@"出生登记办理",@"出生登记办理",@"出生登记办理"],
                          @[@"业务类型",@"业务类型",@"业务类型",@"业务类型"],
                          @[@"办理中",@"办理中", @"办理中", @"办理中",@"办理中"],
                          @[@"已完成",@"已完成",@"已完成",@"已完成",@"已完成"]
                          ];
    self.mainTableDataArr = tmpDataArr[index];
    self.tableDataSource.cellData = self.mainTableDataArr;
    [self.mainTableView reloadData];
}

- (NSArray *)mainTableDataArr {
    //
    if (_mainTableDataArr) {
        return _mainTableDataArr;
    }
    _mainTableDataArr = @[@"出生登记办理", @"出生登记办理", @"出生登记办理",@"出生登记办理",@"出生登记办理",@"出生登记办理",@"出生登记办理"];
    return _mainTableDataArr;
}

-(NSArray *)titleArr {
    if (_titleArr) {
        return _titleArr;
    }
    _titleArr = @[@"全部",@"待处理",@"办理中",@"已完成"];
    return _titleArr;
}
@end
