//
//  HomeVC.m
//  PoliceApp
//
//  Created by horse on 16/9/18.
//  Copyright © 2016年 zgl. All rights reserved.
//

#import "HomeVC.h"
#import "UIView+CornerRadius.h"
#import "ScrollImage.h"
#import "RoundButton.h"
#import "DeedsCell.h"
#import "FSMacro.h"
#import "UIImage+CreateEmptyImage.h"
#import "HomeCollectionViewCell.h"
#import "UIFactory.h"
#import "UIView+CornerRadius.h"
#import "ScrollMessageView.h"
#import "AppSquareVC.h"
#import "MoveCarServiceVC.h"
#import "CheckPeccancyVC.h"
#import "ReservationOnlineVC.h"
#import "MultipleQueryVC.h"
#import "PeopleAppealVC.h"
#import "NewsCenterVC.h"
#import "AffairsGuideVC.h"
#import "UICollectionViewFlowLayout+CollectionViewCellSpaceFix.h"
#import "HomePageDataModel.h"
#import "ReservationDetailVC.h"
#import "SearchResultVC.h"
#import "HomeCollectionThirdSectionCell.h"
#import "LoginVC.h"
#import "ReservationNoticeVC.h"
#import "GlobalVariableManager.h"
#import "GlobalFunctionManager.h"
#import "Constant.h"
#import "RequestService.h"
#import "WJHUD.h"
#import "NewsDetailVC.h"
#import "NoticeDetailVC.h"
#define SCROLL_HEADER_HEIGHT (300*KSCALE)
#define MODULE_HEADER_HEIGHT (280*KSCALE)
#define DEEDS_HEADER_HEIGHT (40*KSCALE)

static const NSString *homeItemId = @"38ed36f8307443fa9765e35f6db0c038";

@interface HomeVC ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ScrollImageDelegate, UITextFieldDelegate, ScrollMessageViewDelegate>
@property(nonatomic, strong)UICollectionView *mainCollectionView;
@property(nonatomic, strong)UITextField *searchTF;
@property(nonatomic, strong)UIImageView* sImage;
@property(nonatomic, strong)UIView *navBarView;
@property(nonatomic, strong)ScrollMessageView* messageView;
@property(nonatomic, strong)NSArray *hotTitleArr;
@property(nonatomic, strong)NSArray *serviceTitleArr;
@property(nonatomic, strong) HomePageDataModel *dataModel;
@property(nonatomic, assign) CGSize generalCellSize;
@property(nonatomic, assign) CGSize thirdSectionCellSize;
@property(nonatomic, strong) NSArray *bannerDataArr;
@property(nonatomic, strong) NSString *noticeId;
@end
 
@implementation HomeVC

#pragma mark --ViewController life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"济宁公安便民服务平台";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.messageView];
    [self.view addSubview:self.mainCollectionView];
    [self setUpRightNavbarItem];
    [self getTopNewsListData];
    [self getNoticeList];
    [GlobalFunctionManager checkVersionOnViewController:self];
}

- (void)getNoticeList {
    typeof(self) __weak wself = self;
    [RequestService getNoticeListWithParamDict:@{@"pageNo" : @0,
                                                @"pageSize": @1} resultBlock:^(BOOL success, id object) {
        [GlobalFunctionManager handleServerDataWithController:wself result:success dataObj:object successBlock:^{
            NSLog(@"object = %@", object);
            NSDictionary *dataDict = object[@"data"];
            NSArray *dataList = dataDict[@"list"];
            if (dataList && dataList.count > 0) {
                NSDictionary *noticeDict = dataList[0];
                wself.messageView.content = noticeDict[@"content"] ?: @" ";
                wself.noticeId = noticeDict[@"id"];
            }
        }];
    }];
}

- (void)getTopNewsListData {
    typeof(self) __weak wself = self;
    [WJHUD showOnView:self.view];
    [RequestService getTopListWithParamDict:@{} resultBlock:^(BOOL success, id object) {
        [WJHUD hideFromView:wself.view];
        [GlobalFunctionManager handleServerDataWithController:wself result:success dataObj:object successBlock:^{
            NSLog(@"object = %@", object);
            NSDictionary *dataDict = object[@"data"];
            wself.bannerDataArr = dataDict[@"list"];
            [wself.mainCollectionView reloadData];
        }];
    }];
}

- (void)setUpRightNavbarItem {
    typeof(self) __weak wself = self;
    
    [self setRightNavigationBarButtonItemWithTitle:@"\U0000E83C" titleColor:[UIColor whiteColor] font:[UIFont fontWithName:@"iconfont" size:25.0]  andAction:^{
        AppSquareVC *appvc = [[AppSquareVC alloc] init];
        wself.hidesBottomBarWhenPushed = YES;
        [wself.navigationController pushViewController:appvc animated:YES];
        wself.hidesBottomBarWhenPushed = NO;
    }];
}

- (ScrollMessageView *)messageView {
    if (_messageView) {
        return _messageView;
    }
    _messageView = [[ScrollMessageView alloc] initWithFrame:CGRectMake(0, 0, SCREN_WIDTH, 50*KSCALE)];
    _messageView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    
    UIView *leftView = [UIFactory createViewWith:CGRectMake(0, 0, 135*KSCALE, 50*KSCALE)];
    leftView.backgroundColor = [UIColor whiteColor];
    UIImageView *hornImageView = [UIFactory createImageViewWith:CGRectMake(10, 0, 50*KSCALE, 50*KSCALE) imageName:@"horn"];
    [leftView addSubview:hornImageView];
    UILabel *titleLabel = [UIFactory createLabelWith:CGRectMake(15+40*KSCALE, 8*KSCALE, CGRectGetWidth(leftView.frame)-15-40*KSCALE, 34*KSCALE) text:@"通知"];
    titleLabel.textColor = COLOR_WITH_RGB(212, 7, 26);
    titleLabel.font = [UIFont fontWithName:@"Arial" size:14.0];
    [titleLabel setBoderRightWithOffset:5 color:COLOR_WITH_RGB(230, 230, 230) width:2];
    
    [leftView addSubview:titleLabel];
    _messageView.leftView = leftView;
    _messageView.delegate = self;
    _messageView.verticalScroll = NO;
    _messageView.content = @"机动车违法信息查询现已开通，请登录后查看详情！";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_messageView startTimer];
    });
    return _messageView;
}

- (void)scrollMessageView:(ScrollMessageView *)messageView clicked:(BOOL)click {
    self.hidesBottomBarWhenPushed = YES;
    NoticeDetailVC *noticeDetailVc = [[NoticeDetailVC alloc] init];
    noticeDetailVc.noticeId = self.noticeId;
    [self.navigationController pushViewController:noticeDetailVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark --UITableViewDelegate/UITableViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case 0:
        case 1:
            return 0;
            break;
        case 2:
            return 3;
            break;
        case 3:
            return 6;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell;
    if (indexPath.section == 2) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionThirdSectionCell" forIndexPath:indexPath];
    }else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectioncell" forIndexPath:indexPath];
    }
//    cell.backgroundColor = [UIColor redColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        NSArray *operationItems = self.dataModel.operate_items;
        HomeCollectionThirdSectionCell *showCell = (HomeCollectionThirdSectionCell*)cell;
         OperationItemModel *dmodel = operationItems[indexPath.row];
        showCell.iconImageView.image = [UIImage imageNamed:dmodel.img_url];
    }else if(indexPath.section == 3){
        HomeCollectionViewCell*showCell = (HomeCollectionViewCell*)cell;
        NSArray *operationItems = self.dataModel.operate_items;

        if (indexPath.row+3 < operationItems.count) {
            OperationItemModel *dmodel = operationItems[indexPath.row+3];
            showCell.titleLabel.text = dmodel.operate_name;
            showCell.iconImageView.image = [UIImage imageNamed:dmodel.img_url];
        }else {
            showCell.titleLabel.hidden = YES;
            showCell.iconImageView.hidden = YES;
        }
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        return self.thirdSectionCellSize;
    }else {
        return self.generalCellSize;
    }
}


-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        //HeaderView
        UICollectionReusableView *headerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        NSArray *subViews = [headerView subviews];
        [subViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
            [view removeFromSuperview];
        }];
        if (indexPath.section == 0) {
            [headerView addSubview:[self scrollHeaderView]];
           
        }else if(indexPath.section == 1) {
            [headerView addSubview:[self getSearchView]];
            headerView.backgroundColor = COLOR_WITH_RGB(217, 217, 217);
        }else if(indexPath.section == 2) {
//            UILabel *label = [self getHeaderLabelWithText:@"热点服务"];
//            [headerView addSubview:label];
            headerView.backgroundColor = COLOR_WITH_RGB(240, 244, 249);
        }else if(indexPath.section == 3) {
//            UILabel *label = [self getHeaderLabelWithText:@"便民服务"];
//            [headerView addSubview:label];
            headerView.backgroundColor = COLOR_WITH_RGB(240, 244, 249);
        }
        
        return headerView;
    }
    else
    {   //FooterView
        UICollectionReusableView *footerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        footerView.backgroundColor = COLOR_WITH_RGB(240, 244, 249);
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
    if (section == 0) {
        return CGSizeMake(SCREN_WIDTH, SCROLL_HEADER_HEIGHT);
    }else if (section ==1 ) {
        return CGSizeMake(SCREN_WIDTH,80*KSCALE);
    }
    return CGSizeMake(SCREN_WIDTH,15*KSCALE);//40*KSCALE);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 3) {
        return CGSizeMake(SCREN_WIDTH, 80*KSCALE);
    }else {
        return CGSizeMake(0, 0);
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    self.hidesBottomBarWhenPushed = YES;
                    MoveCarServiceVC *moveCarVc = [[MoveCarServiceVC alloc] init];
                    [self.navigationController pushViewController:moveCarVc animated:YES];
                    self.hidesBottomBarWhenPushed = NO;
                }
                break;
                case 1:
                {
                    if ([GlobalVariableManager manager].userId != nil){
                        [self gotoReserVationDetailViewControleller];
                    }else {
                        typeof(self) __weak wself = self;
                        [GlobalFunctionManager autoLoginOrLoginOnViewController:wself callBack:^{
                            [wself gotoReserVationDetailViewControleller];
                        }];
                    }
                }
                    break;
                    
                case 2:
                {
                    self.hidesBottomBarWhenPushed = YES;
                    CheckPeccancyVC *checkPeccancyVc = [[CheckPeccancyVC alloc] init];
                    [self.navigationController pushViewController:checkPeccancyVc animated:YES];
                    self.hidesBottomBarWhenPushed = NO;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 3:
        {
            switch (indexPath.row) {
                case 0:
                {
                    if ([GlobalVariableManager manager].userId != nil){
                        [self gotoReserVationViewControleller];
                    }else {
                        typeof(self) __weak wself = self;
                        [GlobalFunctionManager autoLoginOrLoginOnViewController:wself callBack:^{
                            [wself gotoReserVationViewControleller];
                        }];
                    }
                }
                    break;
                    
                case 1:
                {
                    self.hidesBottomBarWhenPushed = YES;
                    MultipleQueryVC *queryVc = [[MultipleQueryVC alloc] init];
                    [self.navigationController pushViewController:queryVc animated:YES];
                    self.hidesBottomBarWhenPushed = NO;
                }
                    break;
                case 2:
                {
                    self.hidesBottomBarWhenPushed = YES;
                    PeopleAppealVC *appealVc = [[PeopleAppealVC alloc] init];
                    [self.navigationController pushViewController:appealVc animated:YES];
                    self.hidesBottomBarWhenPushed = NO;
                }
                    break;
                case 3:
                {
                    self.hidesBottomBarWhenPushed = YES;
                    AffairsGuideVC *affairVc = [[AffairsGuideVC alloc] init];
                    [self.navigationController pushViewController:affairVc animated:YES];
                    self.hidesBottomBarWhenPushed = NO;
                }
                    break;
                case 4:
                {
                    self.hidesBottomBarWhenPushed = YES;
                    AffairsGuideVC *affairVc = [[AffairsGuideVC alloc] init];
                    [self.navigationController pushViewController:affairVc animated:YES];
                    self.hidesBottomBarWhenPushed = NO;
                }
                    break;
                case 5:
                {
                    self.hidesBottomBarWhenPushed = YES;
                    NewsCenterVC *newsCenterVc = [[NewsCenterVC alloc] init];
                    [self.navigationController pushViewController:newsCenterVc animated:YES];
                    self.hidesBottomBarWhenPushed = NO;
                }
                    break;
                    
                default:
                    break;
            }

        }
            break;
        default:
            break;
    }
    
 }

#pragma mark 登录通知回调
//交管预约详情
- (void)gotoReserVationDetailViewControleller {
    self.hidesBottomBarWhenPushed = YES;
    ReservationDetailVC *reservationDetailVc = [[ReservationDetailVC alloc] init];
    reservationDetailVc.title = @"交管预约";
    reservationDetailVc.keyword = @"jgyy";
    [self.navigationController pushViewController:reservationDetailVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
//交管预约列表页
-(void)gotoReserVationViewControleller{
    self.hidesBottomBarWhenPushed = YES;
    ReservationOnlineVC *reservationOnlineVc = [[ReservationOnlineVC alloc] init];
    [self.navigationController pushViewController:reservationOnlineVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark --Private Methods
- (UIView *)scrollHeaderView {
    
    NSMutableArray *imageArr = [[NSMutableArray alloc] init];
    NSMutableArray *titleArr = [[NSMutableArray alloc] init];
//    [self.dataModel.banners enumerateObjectsUsingBlock:^(BannerDataModel *bannerModel, NSUInteger idx, BOOL * _Nonnull stop) {
//        [imageArr addObject:bannerModel.img_url];
//        [titleArr addObject:@"孙立成同志到济宁调查知道工作"];
//    }];
    if (self.bannerDataArr) {
        [self.bannerDataArr enumerateObjectsUsingBlock:^(NSDictionary *dataDict, NSUInteger idx, BOOL * _Nonnull stop) {
            [imageArr addObject: [dataDict objectForKey:@"image"]];
            [titleArr addObject: [dataDict objectForKey:@"title"]];
        }];
    }
    
    ScrollImage *scrl = [[ScrollImage alloc] initWithCurrentController:self urlString:imageArr viewFrame:CGRectMake(0,0, SCREN_WIDTH, SCROLL_HEADER_HEIGHT) placeholderImage:[UIImage imageNamed:@"police1"]   title:titleArr];
    
    scrl.delegate = self;
    scrl.timeInterval = 2.0;
    return scrl.view;
}

- (UIView *)getSearchView {
    UIView *searchBgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREN_WIDTH, 80*KSCALE)];
    self.searchTF = [[UITextField alloc] initWithFrame:CGRectMake(15*KSCALE, 15*KSCALE, SCREN_WIDTH-150*KSCALE, 50*KSCALE)];
    self.searchTF.backgroundColor=COLOR_WITH_RGBA(255, 255, 255, 0.5);
    
    self.searchTF.placeholder = @"请输入搜索内容";
    
    self.searchTF.layer.cornerRadius=5*KSCALE;
    self.searchTF.font = [UIFont systemFontOfSize:14];
    self.searchTF.delegate = self;
    
    
    self.sImage = [[UIImageView alloc] initWithFrame:CGRectMake(10*KSCALE, 0, 30*KSCALE, 30*KSCALE)];
    self.sImage.image = [UIImage imageNamed:@"sousuo"];
    UIView *leftView = [UIFactory createViewWith:CGRectMake(0, 0, 50*KSCALE, 30*KSCALE) backgroundColor:[UIColor clearColor]];
    [leftView addSubview:self.sImage];
    self.searchTF.leftView=leftView;
    self.searchTF.leftViewMode=UITextFieldViewModeAlways;
    
    UIButton *searchBtn = [UIFactory createButtonWith:CGRectMake(SCREN_WIDTH-120*KSCALE, 15*KSCALE, 100*KSCALE, 50*KSCALE) selector:@selector(searchBtnAction:) target:self titleColor:[UIColor whiteColor] title:@"搜索"];
    searchBtn.backgroundColor = COLOR_WITH_RGB(86, 188, 254);
    searchBtn.cornerRadius = 6;
    [searchBgview addSubview:searchBtn];
    [searchBgview addSubview:self.searchTF];
    return searchBgview;
}

#pragma mark UITextFieldDelegate
  // return NO to disallow editing.
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //跳转到搜索页面
}

- (void)searchBtnAction:(UIButton *)btn {
    self.hidesBottomBarWhenPushed = YES;
    SearchResultVC *searchResultVc = [[SearchResultVC alloc] init];
    searchResultVc.keyboard = self.searchTF.text?:@"";
    [self.navigationController pushViewController:searchResultVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (UIView *)navBarView {
    if (!_navBarView) {
        UIView *navBarView = [[UIView alloc] init];
        navBarView.frame = CGRectMake(0, 0, SCREN_WIDTH, 64);
        [self.view addSubview:navBarView];
        self.navBarView = navBarView;
    }
    return _navBarView;
}

#pragma mark --ScrollViewDelegate

#pragma mark --ScrollImageDelegate
- (void)scrollImage:(ScrollImage *)scrollImage clickedAtIndex:(NSInteger)index {
    
    NewsDetailVC *newsVc = [[NewsDetailVC alloc] init];
    NSDictionary *dataDict = self.bannerDataArr[index];
    newsVc.newsId = dataDict[@"id"];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newsVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

-(UICollectionView *)mainCollectionView {
    if (_mainCollectionView) {
        return _mainCollectionView;
    }
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat itemWidth = [flowlayout fixSlit:CGRectMake(0, 0, SCREN_WIDTH, SCREN_HEIGHT-49-64) colCount:4 space:0];
    self.generalCellSize = CGSizeMake(itemWidth, itemWidth);
//    CGFloat itemWidth2 = [flowlayout fixSlit:CGRectMake(0, 0, SCREN_WIDTH, SCREN_HEIGHT-49-64) colCount:3 space:0];
    self.thirdSectionCellSize = CGSizeMake(SCREN_WIDTH/3, itemWidth+20*KSCALE);
//    flowlayout.itemSize = CGSizeMake(itemWidth, itemWidth);
    flowlayout.minimumInteritemSpacing = 0;
    flowlayout.minimumLineSpacing = 0;//未设置这个参数会导致有列间隙
    flowlayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);//这里设置了属性值之后，不要再实现相应的代理方法了，否则属性设置无效。
    flowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(SCREN_WIDTH-itemWidth*4, 50*KSCALE, itemWidth*4, SCREN_HEIGHT-30-49-64) collectionViewLayout:flowlayout];
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
    _mainCollectionView.backgroundColor = COLOR_WITH_RGB(255, 255, 255);
    [_mainCollectionView registerNib:[UINib nibWithNibName:@"HomeCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"collectioncell"];
    [_mainCollectionView registerNib:[UINib nibWithNibName:@"HomeCollectionThirdSectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"HomeCollectionThirdSectionCell"];

    [_mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [_mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
//    _mainCollectionView.scrollEnabled = NO;
//    [self dataModel];
    return _mainCollectionView;
}

-(NSArray *)hotTitleArr {
    if (_hotTitleArr) {
        return _hotTitleArr;
    }
    _hotTitleArr = @[@"移车服务",@"交管预约",@"违章查询",@"违章查询"];
    return _hotTitleArr;
}

-(NSArray *)serviceTitleArr {
    if (_serviceTitleArr) {
        return _serviceTitleArr;
    }
    _serviceTitleArr = @[@"网上预约",@"综合查询",@"民生诉求",@"业务办理"];
    return _serviceTitleArr;
}

-(HomePageDataModel *)dataModel {
    if (_dataModel) {
        return _dataModel;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:@"mainpage_item" ofType:@"txt"];
    NSError *error;
    NSString *str = [NSString stringWithContentsOfFile:path encoding: NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"error = %@", error);
    }
    
    if (str) {
        NSLog(@"str= %@", str);
    }
    _dataModel = [[HomePageDataModel alloc] initWithString:str error:nil];
    
    return _dataModel;
}

@end
