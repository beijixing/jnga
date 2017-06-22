//
//  TrafficViewController.m
//  PoliceService
//
//  Created by WenJie on 2017/6/21.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "TrafficViewController.h"
#import "FSMacro.h"
#import "UICollectionViewFlowLayout+CollectionViewCellSpaceFix.h"
#import "TrafficModel.h"
#import "PeopleAppealCollectionViewCell.h"
#import "UIFactory.h"
#import "MoveCarServiceVC.h"
@interface TrafficViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property(nonatomic, strong) TrafficModel *dataModel;
@end

@implementation TrafficViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"交管办理";
    [self.view addSubview:self.mainCollectionView];
    [self setupLeftBackButton];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UICollectionView *)mainCollectionView {
    if (_mainCollectionView) {
        return _mainCollectionView;
    }
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat itemWidth = [flowlayout fixSlit:CGRectMake(0, 0, SCREN_WIDTH, SCREN_HEIGHT-49-64) colCount:2 space:0];
    flowlayout.itemSize = CGSizeMake(itemWidth, itemWidth);
    flowlayout.minimumInteritemSpacing = 0;
    flowlayout.minimumLineSpacing = 0;//未设置这个参数会导致有列间隙
    flowlayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);//这里设置了属性值之后，不要再实现相应的代理方法了，否则属性设置无效。
    flowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(SCREN_WIDTH-itemWidth*2, 0, itemWidth*2, SCREN_HEIGHT-64) collectionViewLayout:flowlayout];
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
    _mainCollectionView.backgroundColor = COLOR_WITH_RGB(255, 255, 255);
    [_mainCollectionView registerNib:[UINib nibWithNibName:@"PeopleAppealCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"collectioncell"];
    [_mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    //    [self dataModel];
    return _mainCollectionView;
}


#pragma mark --UITableViewDelegate/UITableViewDataSource

- (UILabel *)getHeaderLabelWithText:(NSString *)text {
    UILabel *label = [UIFactory createLabelWith:CGRectMake(8, 0, 100, 40*KSCALE) textColor:COLOR_WITH_RGB(90, 90, 90) text:text];
    label.font = [UIFont fontWithName:@"Arial" size:15];
    return label;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
     if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
         UICollectionReusableView *headerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
         NSArray *subViews = [headerView subviews];
         [subViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
             [view removeFromSuperview];
         }];
         
         TrafficSectionModel *sectionModel = self.dataModel.datas[indexPath.section];
         UILabel *label = [self getHeaderLabelWithText:sectionModel.type_name];
         [headerView addSubview:label];
         headerView.backgroundColor = COLOR_WITH_RGB(240, 244, 249);
         return headerView;
     }
    return nil;
   
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    TrafficSectionModel *sectionModel = self.dataModel.datas[section];
    return sectionModel.items.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataModel.datas.count;

}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectioncell" forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    PeopleAppealCollectionViewCell*showCell = (PeopleAppealCollectionViewCell*)cell;
    TrafficSectionModel *sectionModel = self.dataModel.datas[indexPath.section];

    TrafficItemModel *dmodel = sectionModel.items[indexPath.row];
    showCell.titleLabel.text = dmodel.name;
    [showCell.iconImageView setImage:[UIImage imageNamed:dmodel.img_url]];
}


-(TrafficModel *)dataModel {
    if (_dataModel) {
        return _dataModel;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:@"traffic_control" ofType:@"txt"];
    NSError *error;
    NSString *str = [NSString stringWithContentsOfFile:path encoding: NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"error = %@", error);
    }
    
    if (str) {
        NSLog(@"str= %@", str);
    }
    _dataModel = [[TrafficModel alloc] initWithString:str error:&error];
    
    return _dataModel;
}






- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREN_WIDTH, 30);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    AffairsItemDataModel *dmodel = self.dataModel.data[indexPath.row];
//    self.hidesBottomBarWhenPushed = YES;
//    AffairsSubVC *affairsSubVc = [[AffairsSubVC alloc] init];
//    affairsSubVc.parentId = dmodel.parentId;
//    [self.navigationController pushViewController:affairsSubVc animated:YES];
    //    self.hidesBottomBarWhenPushed = NO;
    if (indexPath.section == 0 && indexPath.item == 0) {
        MoveCarServiceVC *moveCar = [[MoveCarServiceVC alloc]init];
        [self.navigationController pushViewController:moveCar animated:YES];
        return;
    }
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
