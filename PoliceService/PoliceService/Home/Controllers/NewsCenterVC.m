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
@property(nonatomic, strong) NewsListVC *newsCenterVC;
@property(nonatomic, strong) NewsListVC *jingqingVC;
@property(nonatomic, strong) NewsListVC *securityVC;
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
    [self addChildViewController:self.jingqingVC];
    [self addChildViewController:self.securityVC];
    
    [self.view addSubview:self.newsCenterVC.view];
    [self.view addSubview:self.jingqingVC.view];
    [self.view addSubview:self.securityVC.view];
    self.jingqingVC.view.hidden = YES;
    self.securityVC.view.hidden = YES;
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
            self.newsCenterVC.view.hidden = NO;
            self.jingqingVC.view.hidden = YES;
            self.securityVC.view.hidden = YES;
        }
            break;
        case 1:
        {
            self.newsCenterVC.view.hidden = YES;
            self.jingqingVC.view.hidden = NO;
            self.securityVC.view.hidden = YES;
        }
            break;
        case 2:
        {
            self.newsCenterVC.view.hidden = YES;
            self.jingqingVC.view.hidden = YES;
            self.securityVC.view.hidden = NO;
        }
            break;
            
        default:
            break;
    }
}

- (NewsListVC *)newsCenterVC {
    if (_newsCenterVC) {
        return _newsCenterVC;
    }
    _newsCenterVC = [[NewsListVC alloc] init];
    _newsCenterVC.newsType = [NSNumber numberWithInteger:1];
    return _newsCenterVC;
}

- (NewsListVC *)jingqingVC {
    if (_jingqingVC) {
        return _jingqingVC;
    }
    _jingqingVC = [[NewsListVC alloc] init];
    _jingqingVC.newsType = [NSNumber numberWithInteger:2];
    return _jingqingVC;
}

- (NewsListVC *)securityVC {
    if (_securityVC) {
        return _securityVC;
    }
    _securityVC = [[NewsListVC alloc] init];
    _securityVC.newsType = [NSNumber numberWithInteger:3];
    return _securityVC;
}

-(NSArray *)titleArr {
    if (_titleArr) {
        return _titleArr;
    }
    
    _titleArr = @[@"新闻中心",@"警情通报",@"安全防范"];
    return _titleArr;
}

@end
