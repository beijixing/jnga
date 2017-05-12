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
#define SCROLL_HEADER_HEIGHT (280*KSCALE)
@interface RecommendVC ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ScrollImageDelegate>
@property(nonatomic, strong)UICollectionView *mainCollectionView;
@property(nonatomic, strong)NSArray *serviceTitleArr;
@property(nonatomic, strong) RecomendAppDataModel *dataModel;
@end

@implementation RecommendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"推荐应用";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainCollectionView];
    
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
                    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tmri12123://"]]) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tmri12123://"]];
                    }else {
                        NSString *urlString = @"itms-apps://itunes.apple.com/cn/app/交管12123/id1039727169?mt=8";
                        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        
                        if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
                        }
                        
                    }
                }
                    break;
                    //";
                case 1:
                {
                    self.hidesBottomBarWhenPushed = YES;
                    CommonWebViewController *commonWebVc = [[CommonWebViewController alloc] init];
                    commonWebVc.title = dModel.app_name;
                    commonWebVc.urlString = @"http://www.sdcrj.com/";
                    [self.navigationController pushViewController:commonWebVc animated:YES];
                    self.hidesBottomBarWhenPushed = NO;
                }
                    break;
                    
                case 2:
                {
                   
                }
                    break;
                    
                default:
                    break;
            }
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"自定义cell大小");
//    return CGSizeMake(SCREN_WIDTH/3, SCREN_WIDTH/3);
//}


#pragma mark --Private Methods
- (UIView *)scrollHeaderView {
    NSMutableArray *imageArr = [[NSMutableArray alloc] init];
    [self.dataModel.banners enumerateObjectsUsingBlock:^(BannerDataModel *bannerModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [imageArr addObject:bannerModel.img_url];
    }];
    
    
    ScrollImage *scrl = [[ScrollImage alloc] initWithCurrentController:self urlString:imageArr viewFrame:CGRectMake(0,0, SCREN_WIDTH, SCROLL_HEADER_HEIGHT) placeholderImage:[UIImage imageNamed:@"police1"]];
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


-(NSArray *)serviceTitleArr {
    if (_serviceTitleArr) {
        return _serviceTitleArr;
    }
    _serviceTitleArr = @[@"交管12123",@"出入境",@"法制办"];
    return _serviceTitleArr;
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
