//
//  NewsCenterVC.m
//  PoliceService
//
//  Created by horse on 2017/2/21.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "NewsCenterVC.h"
#import "ScrollImage.h"
#import "RoundButton.h"
#import "DeedsCell.h"
#import "FSMacro.h"
#import "UIImage+CreateEmptyImage.h"
#import "SGSegmentedControl.h"

#import "WJHUD.h"
#import "RequestService.h"
#import "GlobalFunctionManager.h"
#import "GlobalVariableManager.h"
#import "NewsCenterServerDataModel.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "NewsListVC.h"
#define SCROLL_HEADER_HEIGHT (320*KSCALE)
#define MODULE_HEADER_HEIGHT (280*KSCALE)
#define DEEDS_HEADER_HEIGHT (40*KSCALE)

@interface NewsCenterVC ()<SGSegmentedControlDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)SGSegmentedControl *segmentedControl;
@property(nonatomic, strong) NewsListVC *newsCenterVC;//新闻中心
@property(nonatomic, strong) NewsListVC *noticeVC;//警方公告
@property(nonatomic, strong) NewsListVC *securityVC;//安全防范
@property(nonatomic, strong) NewsListVC *lawsInfoVC;//法律法规
@property(nonatomic, strong) NewsListVC *extinguishingVC;//消防
@property(nonatomic, strong)NSArray *titleArr;
@end

@implementation NewsCenterVC

#pragma mark --ViewController life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"警务资讯";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpLeftNavbarItem];
 
    [self addChildViewController:self.newsCenterVC];
    [self addChildViewController:self.lawsInfoVC];
    [self addChildViewController:self.securityVC];
    [self addChildViewController:self.noticeVC];
    [self addChildViewController:self.extinguishingVC];

    
    [self.view addSubview:self.newsCenterVC.view];
    [self.view addSubview:self.lawsInfoVC.view];
    [self.view addSubview:self.securityVC.view];
    [self.view addSubview:self.noticeVC.view];
    [self.view addSubview:self.extinguishingVC.view];
   
    [self showSelectedVC:self.newsCenterVC];
    [self.view addSubview:self.segmentedControl];
}

- (void)setUpLeftNavbarItem {
//    typeof(self) __weak wself = self;
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
        
    }];
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
    switch (index) {
        case 0:
        {
             [self showSelectedVC:self.newsCenterVC];
        }
            break;
        case 1:
        {
            [self showSelectedVC:self.lawsInfoVC];
        }
            break;
        case 2:
        {
             [self showSelectedVC:self.securityVC];
        }
            break;
        case 3:
        {
            [self showSelectedVC:self.noticeVC];
        }
            break;
        case 4:
        {
            [self showSelectedVC:self.extinguishingVC];
        }
            break;
        default:
            break;
    }
}

- (void)showSelectedVC:(NewsListVC *)selectednews {
    
    NSArray *childVC = [self childViewControllers];
    [childVC enumerateObjectsUsingBlock:^(NewsListVC* child, NSUInteger idx, BOOL * _Nonnull stop) {
        if (selectednews == child) {
            child.view.hidden = NO;
        }else {
            child.view.hidden = YES;
        }
    }];
}

- (NewsListVC *)newsCenterVC {
    if (_newsCenterVC) {
        return _newsCenterVC;
    }
    _newsCenterVC = [[NewsListVC alloc] init];
    _newsCenterVC.newsType = [NSNumber numberWithInteger:1];
    return _newsCenterVC;
}

- (NewsListVC *)lawsInfoVC {
    if (_lawsInfoVC) {
        return _lawsInfoVC;
    }
    _lawsInfoVC = [[NewsListVC alloc] init];
    _lawsInfoVC.newsType = [NSNumber numberWithInteger:2];
    return _lawsInfoVC;
}

- (NewsListVC *)securityVC {
    if (_securityVC) {
        return _securityVC;
    }
    _securityVC = [[NewsListVC alloc] init];
    _securityVC.newsType = [NSNumber numberWithInteger:3];
    return _securityVC;
}

- (NewsListVC *)noticeVC {
    if (_noticeVC) {
        return _noticeVC;
    }
    _noticeVC = [[NewsListVC alloc] init];
    _noticeVC.newsType = [NSNumber numberWithInteger:4];
    return _noticeVC;
}

- (NewsListVC *)extinguishingVC {
    if (_extinguishingVC) {
        return _extinguishingVC;
    }
    _extinguishingVC = [[NewsListVC alloc] init];
    _extinguishingVC.newsType = [NSNumber numberWithInteger:5];
    return _extinguishingVC;
}

-(NSArray *)titleArr {
    if (_titleArr) {
        return _titleArr;
    }
    
    _titleArr = @[@"新闻中心",@"法律法规",@"安全防范", @"警方公告", @"消防一点通"];
    return _titleArr;
}

@end
