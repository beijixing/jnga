//
//  AffairsGuideVC.m
//  PoliceService
//
//  Created by horse on 2017/2/21.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "AffairsGuideVC.h"
#import "ScrollImage.h"
#import "RoundButton.h"
#import "FSMacro.h"
#import "UIImage+CreateEmptyImage.h"
#import "PeopleAppealCollectionViewCell.h"
#import "UIFactory.h"
#import "UIView+CornerRadius.h"
#import "ScrollMessageView.h"
#import "NewsCenterVC.h"
#import "AffairsSubVC.h"
#import "UICollectionViewFlowLayout+CollectionViewCellSpaceFix.h"
#import "AffairsGuideDataModel.h"
#import "GlobalVariableManager.h"
#import "WJHUD.h"
#import "RequestService.h"
#import "UIImageView+WebCache.h"
#import "Constant.h"
#define SCROLL_HEADER_HEIGHT (280*KSCALE)
#define MODULE_HEADER_HEIGHT (280*KSCALE)
#define DEEDS_HEADER_HEIGHT (40*KSCALE)


@interface AffairsGuideVC ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ScrollImageDelegate >
@property(nonatomic, strong)UICollectionView *mainCollectionView;
@property(nonatomic, strong)ScrollMessageView* messageView;
@property(nonatomic, strong)NSArray *serviceTitleArr;
@property(nonatomic, strong) AffairsGuideDataModel *dataModel;

@end

@implementation AffairsGuideVC

#pragma mark --ViewController life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"业务办理";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainCollectionView];
    [self setUpLeftNavbarItem];
    [self getServerData];
}

- (void)getServerData{
    [WJHUD showOnView:self.view];
    typeof(self) __weak wself = self;
    [RequestService getGuideListWithParamDict:@{@"parentid":businessId} resultBlock:^(BOOL success, id object) {
        [WJHUD hideFromView:wself.view];
        if (success) {
            NSDictionary *dataDict = (NSDictionary *)object;
            if ([[dataDict objectForKey:@"code"] integerValue] == 1) {
                NSError *error;
                wself.dataModel = [[AffairsGuideDataModel alloc] initWithDictionary:dataDict error:&error];
                [wself.mainCollectionView reloadData];
                NSLog(@"%@", dataDict);
            }else {
                [WJHUD showText:[dataDict objectForKey:@"message"] onView:wself.view];
            }
        }else {
            NSLog(@"object=%@", object);
        }
    }];
}

- (void)setUpLeftNavbarItem {
//    typeof(self) __weak wself = self;
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
        
    }];
}

#pragma mark --UITableViewDelegate/UITableViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataModel.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectioncell" forIndexPath:indexPath];
    //    cell.backgroundColor = [UIColor redColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    PeopleAppealCollectionViewCell*showCell = (PeopleAppealCollectionViewCell*)cell;
    AffairsItemDataModel *dmodel = self.dataModel.data[indexPath.row];
    showCell.titleLabel.text = dmodel.name;
    [showCell.iconImageView sd_setImageWithURL:[NSURL URLWithString:dmodel.imgUrl] placeholderImage:[UIImage imageNamed:@"bsjiaoguan"]];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        //HeaderView
        UICollectionReusableView *headerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        [headerView addSubview:[self scrollHeaderView]];
        return headerView;
    }
    else
    {   //FooterView
        UICollectionReusableView *footerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        footerView.backgroundColor = [UIColor greenColor];
        return footerView;
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREN_WIDTH, SCROLL_HEADER_HEIGHT);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    AffairsItemDataModel *dmodel = self.dataModel.data[indexPath.row];
    self.hidesBottomBarWhenPushed = YES;
    AffairsSubVC *affairsSubVc = [[AffairsSubVC alloc] init];
    affairsSubVc.parentId = dmodel.id;
    [self.navigationController pushViewController:affairsSubVc animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
    
}

#pragma mark --Private Methods
- (UIView *)scrollHeaderView {
    NSMutableArray *imageArr = [[NSMutableArray alloc] init];
    for (int i=0; i<3; i++) {
        [imageArr addObject:@"police1"];
    }
//    [self.dataModel.banners enumerateObjectsUsingBlock:^(BannerDataModel *bannerModel, NSUInteger idx, BOOL * _Nonnull stop) {
//        [imageArr addObject:bannerModel.img_url];
//    }];
    
    
    ScrollImage *scrl = [[ScrollImage alloc] initWithCurrentController:self urlString:imageArr viewFrame:CGRectMake(0,0, SCREN_WIDTH, SCROLL_HEADER_HEIGHT) placeholderImage:[UIImage imageNamed:@"police1"]];
    scrl.delegate = self;
    scrl.timeInterval = 2.0;
    return scrl.view;
}

#pragma mark --ScrollImageDelegate
- (void)scrollImage:(ScrollImage *)scrollImage clickedAtIndex:(NSInteger)index {
    NewsCenterVC *newsVc = [[NewsCenterVC alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newsVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

-(UICollectionView *)mainCollectionView {
    if (_mainCollectionView) {
        return _mainCollectionView;
    }
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat itemWidth = [flowlayout fixSlit:CGRectMake(0, 0, SCREN_WIDTH, SCREN_HEIGHT-49-64) colCount:3 space:0];
    flowlayout.itemSize = CGSizeMake(itemWidth, itemWidth);
    flowlayout.minimumInteritemSpacing = 0;
    flowlayout.minimumLineSpacing = 0;//未设置这个参数会导致有列间隙
    flowlayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);//这里设置了属性值之后，不要再实现相应的代理方法了，否则属性设置无效。
    flowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(SCREN_WIDTH-itemWidth*3, 0, itemWidth*3, SCREN_HEIGHT-64) collectionViewLayout:flowlayout];
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
    _mainCollectionView.backgroundColor = COLOR_WITH_RGB(255, 255, 255);
    [_mainCollectionView registerNib:[UINib nibWithNibName:@"PeopleAppealCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"collectioncell"];
    [_mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
//    [self dataModel];
    return _mainCollectionView;
}


-(NSArray *)serviceTitleArr {
    if (_serviceTitleArr) {
        return _serviceTitleArr;
    }
    _serviceTitleArr = @[@"交管",@"户政",@"出入境",@"消防",@"法制",@"治安",@"刑警",@"经侦",@"网警",@"禁毒",@"科技"];
    return _serviceTitleArr;
}

//-(AffairsGuideDataModel *)dataModel {
//    if (_dataModel) {
//        return _dataModel;
//    }
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"actguide_item" ofType:@"txt"];
//    NSError *error;
//    NSString *str = [NSString stringWithContentsOfFile:path encoding: NSUTF8StringEncoding error:&error];
//    if (error) {
//        NSLog(@"error = %@", error);
//    }
//    
//    if (str) {
//        NSLog(@"str= %@", str);
//    }
//    _dataModel = [[AffairsGuideDataModel alloc] initWithString:str error:nil];
//    
//    return _dataModel;
//}

@end
