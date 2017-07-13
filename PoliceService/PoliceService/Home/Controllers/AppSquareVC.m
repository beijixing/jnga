//
//  AppSquareVC.m
//  PoliceService
//
//  Created by horse on 2017/2/17.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "AppSquareVC.h"
#import "FSMacro.h"
#import "UIFactory.h"
#import "AppSquareHeaderView.h"
#import "AppSquareCollectionViewCell.h"
#import "UICollectionViewFlowLayout+CollectionViewCellSpaceFix.h"
#import "AppSquareDataModel.h"
#import "LoginVC.h"
#import "ReservationNoticeVC.h"
#import "ReservationDetailVC.h"
#import "GlobalVariableManager.h"
#import "Constant.h"
#import "AffairsSubVC.h"
#import "UIApplication+CallSystemApp.h"
#import "GlobalFunctionManager.h"
#import "RequestService.h"
#import "WJHUD.h"
#import "Constant.h"
#import "AffairsGuideDataModel.h"
#import "UIImageView+WebCache.h"
#import "NewsCenterVC.h"
#import "CommonWebViewController.h"
@interface AppSquareVC ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong)UICollectionView *mainCollectionView;
@property(nonatomic, strong) NSArray *headerTitleArr;
@property(nonatomic, strong) AppSquareDataModel *dataModel;
@property(nonatomic, strong) AffairsGuideDataModel *affairsDataModel;
@end

@implementation AppSquareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"应用广场";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpLeftNavbarItem];
    [self.view addSubview:self.mainCollectionView];
    [self getServerData];
    // Do any additional setup after loading the view.
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
                wself.affairsDataModel = [[AffairsGuideDataModel alloc] initWithDictionary:dataDict error:&error];
                NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
                [indexSet addIndex:5];
                [wself.mainCollectionView reloadSections:indexSet];
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
    typeof(self) __weak wself = self;
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
        
    }];
}

#pragma mark --UICollectionViewDelegate/UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 5) {
        return self.affairsDataModel.data.count;
    }else {
        AppSquareSectionDataModel *sectionDataModel = self.dataModel.datas[section];
        return sectionDataModel.items.count;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectioncell" forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    AppSquareCollectionViewCell *showCell = (AppSquareCollectionViewCell*)cell;
    if (indexPath.section == 5) {
        AffairsItemDataModel *dmodel = self.affairsDataModel.data[indexPath.row];
        showCell.titleLabel.text = dmodel.name;
        [showCell.iconImageView sd_setImageWithURL:[NSURL URLWithString:dmodel.imgUrl] placeholderImage:[UIImage imageNamed:@"bsjiaoguan"]];
    }else {
        AppSquareSectionDataModel *sectionDataModel = self.dataModel.datas[indexPath.section];
        AppSquareItemDataModel *itemModel = sectionDataModel.items[indexPath.row];
        showCell.titleLabel.text = itemModel.name;
        showCell.iconImageView.image = [UIImage imageNamed:itemModel.img_url];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataModel.datas.count;
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        //HeaderView
        AppSquareHeaderView *headerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        AppSquareSectionDataModel *sectionDataModel = self.dataModel.datas[indexPath.section];

        headerView.titleLabel.text = sectionDataModel.type_name;
        return headerView;
    }
    else
    {   //FooterView
        UICollectionReusableView *footerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        footerView.backgroundColor = [UIColor greenColor];
        return footerView;
    }
}

- (UILabel *)getHeaderLabelWithText:(NSString *)text {
    UILabel *label = [UIFactory createLabelWith:CGRectMake(0, 0, 100, 40*KSCALE) textColor:COLOR_WITH_RGB(90, 90, 90) text:text];
    label.font = [UIFont fontWithName:@"Arial" size:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.center = CGPointMake(SCREN_WIDTH/2, 20*KSCALE);
    return label;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREN_WIDTH,80*KSCALE);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  
    switch (indexPath.section) {
        case 0:
        {
            NewsCenterVC *newsVC = [[NewsCenterVC alloc] init];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:newsVC animated:YES];
        }
            break;
        case 1:
        {
            AppSquareSectionDataModel *sectionDataModel = self.dataModel.datas[indexPath.section];
            AppSquareItemDataModel *itemModel = sectionDataModel.items[indexPath.row];
            if ([GlobalVariableManager manager].userId != nil) {
                //直接到预约界面
                if (indexPath.item == 7 || indexPath.item == 8 ) {
                     [self gotoCommonWebView:itemModel.name];
                }else {
                     [self gotoReserVationDetailViewControlellerWithKeyWord:itemModel.keyword title:itemModel.name];
                }
                
            }else {
                //先登录
                typeof(self) __weak wself = self;
                [GlobalFunctionManager autoLoginOrLoginOnViewController:self callBack:^{
                    if (indexPath.item == 7) {
                        [wself gotoCommonWebView:itemModel.name];
                    }else {
                        [wself gotoReserVationDetailViewControlellerWithKeyWord:itemModel.keyword title:itemModel.name];
                    }
                }];
            }
        }
            break;
        case 2:
        {//业务办理
            //[GlobalFunctionManager pushQuerySubviewWithController:self switchId:indexPath.row];
        }
            break;
        case 3:
        {
            [GlobalFunctionManager pushQuerySubviewWithController:self switchId:indexPath.row];
        }
            break;
        case 4:
        {
            [GlobalFunctionManager pushPeopleAppealSubviewWithController:self switchId:indexPath.row];
        }
            break;
        case 5:
        {
            AffairsSubVC *affairsVC = [[AffairsSubVC alloc] init];
            AffairsItemDataModel *dmodel = self.affairsDataModel.data[indexPath.row];
            affairsVC.parentId = dmodel.id;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:affairsVC animated:YES];
        }
            break;
        default:
            break;
    }
    
    
    
}

-(UICollectionView *)mainCollectionView {
    if (_mainCollectionView) {
        return _mainCollectionView;
    }
    
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat itemWidth = [flowlayout fixSlit:CGRectMake(0, 0, SCREN_WIDTH, SCREN_HEIGHT-49-64) colCount:3 space:0];//计算得出itemwidth的宽度若有小数只有一位小数.5 该方法定义在"UICollectionViewFlowLayout+CollectionViewCellSpaceFix.h"
    flowlayout.itemSize = CGSizeMake(itemWidth, itemWidth);
    flowlayout.minimumInteritemSpacing = 0;
    flowlayout.minimumLineSpacing = 0;//未设置这个参数会导致有列间隙
    flowlayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);//这里设置了属性值之后，不要再实现相应的代理方法了，否则属性设置无效。
    flowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(SCREN_WIDTH-itemWidth*3, 0, itemWidth*3, SCREN_HEIGHT-64) collectionViewLayout:flowlayout];
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
    _mainCollectionView.backgroundColor = COLOR_WITH_RGB(255, 255, 255);
    [_mainCollectionView registerNib:[UINib nibWithNibName:@"AppSquareCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"collectioncell"];
    
    [_mainCollectionView registerClass:[AppSquareHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    [_mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    return _mainCollectionView;
}

-(NSArray *)headerTitleArr {
    if (_headerTitleArr) {
        return _headerTitleArr;
    }
    _headerTitleArr = @[@"网上预约", @"综合查询", @"民生诉求", @"办事指南"];
    
    return _headerTitleArr;
}

-(AppSquareDataModel *)dataModel {
    if (_dataModel) {
        return _dataModel;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:@"app_square" ofType:@"txt"];
    NSError *error;
    NSString *str = [NSString stringWithContentsOfFile:path encoding: NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"error = %@", error);
    }
    
    if (str) {
        NSLog(@"str= %@", str);
    }
    _dataModel = [[AppSquareDataModel alloc] initWithString:str error:&error];
    if (error) {
        NSLog(@"error = %@", error);
    }
    return _dataModel;
}

- (void)gotoReserVationDetailViewControlellerWithKeyWord:(NSString *)keyWord title:(NSString *)title {
    self.hidesBottomBarWhenPushed = YES;
    ReservationDetailVC *reservationDetailVc = [[ReservationDetailVC alloc] init];
    reservationDetailVc.title = title;
    reservationDetailVc.keyword = keyWord;
    [self.navigationController pushViewController:reservationDetailVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)gotoCommonWebView:(NSString *)title{
        self.hidesBottomBarWhenPushed = YES;
        CommonWebViewController *webViewVc = [[CommonWebViewController alloc] init];
        webViewVc.title = title;
        webViewVc.urlString = @"http://www.sdcrj.com/";
        [self.navigationController pushViewController:webViewVc animated:YES];
}

//- (void)loginSucessCallBack:(NSNotification *)notification {
//    [GlobalFunctionManager pushReservationSubViewWithViewController:self];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:LoginSucessNotificationKey object:nil];
//}

@end
