//
//  RecommendVC.m
//  PoliceService
//
//  Created by horse on 2017/2/21.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "RecommendVC.h"
#import "ScrollImage.h"
#import "RecommendCollectionViewCell.h"
#import "FSMacro.h"
#import "UICollectionViewFlowLayout+CollectionViewCellSpaceFix.h"
#import "RecomendAppDataModel.h"
#import "CommonWebViewController.h"
#import "WJHUD.h"
#define SCROLL_HEADER_HEIGHT (280*KSCALE)
@interface RecommendVC ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ScrollImageDelegate>
@property(nonatomic, strong)UICollectionView *mainCollectionView;
@property(nonatomic, strong) RecomendAppDataModel *dataModel;
@property(nonatomic, strong) UIView *qrCodeView;
@property(nonatomic, strong) UIImageView *qrImageView;
@end

@implementation RecommendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"推荐应用";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainCollectionView];
    [self.view addSubview:self.qrCodeView];
    
}

#pragma mark --UITableViewDelegate/UITableViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataModel.app_items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectioncell" forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    RecommendCollectionViewCell*showCell = (RecommendCollectionViewCell*)cell;
    APPInfoDataModel *dModel = self.dataModel.app_items[indexPath.row];
    showCell.titleLabel.text = dModel.app_name;
    showCell.iconImageView .image = [UIImage imageNamed:dModel.img_url];
    
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
    }else {
        return [[UICollectionReusableView alloc] init];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREN_WIDTH, SCROLL_HEADER_HEIGHT);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    APPInfoDataModel *dModel = self.dataModel.app_items[indexPath.row];  
            switch (indexPath.row) {
                case 0:{
                        [self openAppWithTestURL:[NSURL URLWithString:@"tmri12123://"] downloadUrlString:@"itms-apps://itunes.apple.com/cn/app/交管12123/id1039727169?mt=8"];
                    }
                    break;
                case 1:
                {
                    [self openWebViewWithTitle:dModel.app_name url:dModel.link_url];
                }
                    break;
                    
                case 2:
                {
                     [self openAppWithTestURL:[NSURL URLWithString:@"WayBookJiNing://"] downloadUrlString:@"itms-apps://itunes.apple.com/cn/app/济宁交通/id1088160802?mt=8"];
                }
                    break;
                case 3:
                {
                    [WJHUD showText:@"暂无iphone版本" onView:self.view];
                }
                    break;
                case 4:
                {
//                    [self openAppWithTestURL:[NSURL URLWithString:@"://"] downloadUrlString:@"itms-apps://itunes.apple.com/cn/app/民生警务/id1023665999?mt=8"];
                    [WJHUD showText:@"无法跳转" onView:self.view];
                }
                    break;
                case 5:
                {
                    [self openWebViewWithTitle:dModel.app_name url:dModel.link_url];
                }
                    break;
                case 6:
                {
                     [self showQRCodeViewWithImageName:@"zz_jnjj"];
                }
                    break;
                case 7:
                {
                     [self showQRCodeViewWithImageName:@"zz_jnga"];
                }
                    break;
                case 8:
                {
                    [self openWebViewWithTitle:dModel.app_name url:dModel.link_url];
                }
                    break;
                case 9:
                {
                    [self showQRCodeViewWithImageName:@"zz_jnxf.jpg"];
                }
                    break;
                case 10:
                {
                    [self openWebViewWithTitle:dModel.app_name url:dModel.link_url];
                }
                    break;
                case 11:
                {
                    [self openWebViewWithTitle:dModel.app_name url:dModel.link_url];
                }
                    break;
                default:
                    break;
            }
}

- (void)showQRCodeViewWithImageName:(NSString *)imageName {
    self.qrImageView.image = [UIImage imageNamed:imageName];
    typeof(self) __weak wself = self;
    [UIView animateWithDuration:0.2 animations:^{
        wself.qrCodeView.frame = wself.view.bounds;
    }];
}

- (void)openWebViewWithTitle:(NSString *)title url:(NSString *)urlstr {
    self.hidesBottomBarWhenPushed = YES;
    CommonWebViewController *commonWebVc = [[CommonWebViewController alloc] init];
    commonWebVc.title = title;
    commonWebVc.urlString = urlstr;
    [self.navigationController pushViewController:commonWebVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)openAppWithTestURL:(NSURL *)url downloadUrlString:(NSString *)downloadUrl {
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }else {
        NSString *urlString = downloadUrl;
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }
        
    }
}

#pragma mark --Private Methods
- (UIView *)scrollHeaderView {
    NSMutableArray *imageArr = [[NSMutableArray alloc] init];
    [self.dataModel.banners enumerateObjectsUsingBlock:^(BannerDataModel *bannerModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [imageArr addObject:bannerModel.img_url];
    }];
    
    ScrollImage *scrl = [[ScrollImage alloc] initWithCurrentController:self imageNames:imageArr viewFrame:CGRectMake(0,0, SCREN_WIDTH, SCROLL_HEADER_HEIGHT) placeholderImage:[UIImage imageNamed:@"police1"]];
    scrl.delegate = self;
    scrl.timeInterval = 2.0;
    return scrl.view;
}

#pragma mark --ScrollImageDelegate
- (void)scrollImage:(ScrollImage *)scrollImage clickedAtIndex:(NSInteger)index {
    
    
}

-(UICollectionView *)mainCollectionView {
    if (_mainCollectionView) {
        return _mainCollectionView;
    }
    
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat itemWidth = [flowlayout fixSlit:CGRectMake(0, 0, self.view.frame.size.width, SCREN_HEIGHT-49-64) colCount:3 space:0];
    flowlayout.itemSize = CGSizeMake(itemWidth, itemWidth);
    flowlayout.minimumInteritemSpacing = 0;
    flowlayout.minimumLineSpacing = 0;//未设置这个参数会导致有列间隙
    flowlayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);//这里设置了属性值之后，不要再实现相应的代理方法了，否则属性设置无效。
    flowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(SCREN_WIDTH-itemWidth*3, 0, itemWidth*3, SCREN_HEIGHT-49-64) collectionViewLayout:flowlayout];
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
    _mainCollectionView.backgroundColor = COLOR_WITH_RGB(240, 244, 249);
    [_mainCollectionView registerNib:[UINib nibWithNibName:@"RecommendCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"collectioncell"];
    [_mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    return _mainCollectionView;
}

- (UIImageView *)qrImageView {
    if (_qrImageView) {
        return _qrImageView;
    }
    _qrImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREN_WIDTH/2, SCREN_WIDTH/2)];
    _qrImageView.center = CGPointMake(SCREN_WIDTH/2, (SCREN_HEIGHT-64-49)/2);
    return _qrImageView;
}

- (UIView *)qrCodeView {
    if (_qrCodeView) {
        return _qrCodeView;
    }
    _qrCodeView = [[UIView alloc] initWithFrame:CGRectMake(0, -SCREN_HEIGHT, SCREN_WIDTH, SCREN_HEIGHT)];
    _qrCodeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [_qrCodeView addSubview:self.qrImageView];
    
    UITapGestureRecognizer *tapGeture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(qrviewClicked:)];
    [_qrCodeView addGestureRecognizer:tapGeture];
    return _qrCodeView;
}

- (void)qrviewClicked:(UITapGestureRecognizer *)tap {
    typeof(self) __weak wself = self;
    [UIView animateWithDuration:0.2 animations:^{
        wself.qrCodeView.frame = CGRectMake(0, -SCREN_HEIGHT, SCREN_WIDTH, SCREN_HEIGHT);
    }];
}

-(RecomendAppDataModel *)dataModel {
    if (_dataModel) {
        return _dataModel;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:@"recommend_app" ofType:@"txt"];
    NSError *error;
    NSString *str = [NSString stringWithContentsOfFile:path encoding: NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"error = %@", error);
    }
    
    if (str) {
        NSLog(@"str= %@", str);
    }
    _dataModel = [[RecomendAppDataModel alloc] initWithString:str error:nil];
    
    return _dataModel;
}


@end
