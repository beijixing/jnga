//
//  PeopleAppealVC.m
//  PoliceService
//
//  Created by horse on 2017/2/21.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "PeopleAppealVC.h"
#import "FSMacro.h"
#import "PeopleAppealCollectionViewCell.h"
#import "SuggestionVC.h"
#import "CommentPoliceVC.h"
#import "UICollectionViewFlowLayout+CollectionViewCellSpaceFix.h"
#import "PeopleAppealDataModel.h"
#import "GlobalFunctionManager.h"
#import "UIApplication+CallSystemApp.h"
#import "DirectorMailVC.h"
#import "ConsultOnlineVC.h"
#import "CrimeReportVC.h"

@interface PeopleAppealVC ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong)UICollectionView *mainCollectionView;
@property(nonatomic, strong) NSArray *headerTitleArr;
@property(nonatomic, strong) PeopleAppealDataModel *dataModel;
@end

@implementation PeopleAppealVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"民生诉求";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpLeftNavbarItem];
    [self.view addSubview:self.mainCollectionView];
}
- (void)setUpLeftNavbarItem {
//    typeof(self) __weak wself = self;
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
        
    }];
}

#pragma mark --UITableViewDelegate/UITableViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.headerTitleArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectioncell" forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    PeopleAppealCollectionViewCell *showCell = (PeopleAppealCollectionViewCell*)cell;
    OperationItemModel *itemModel = self.dataModel.datas[indexPath.row];
    showCell.titleLabel.text = itemModel.operate_name;
    showCell.iconImageView.image = [UIImage imageNamed:itemModel.img_url];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexPath.row=%ld", (long)indexPath.row);
//    [GlobalFunctionManager pushPeopleAppealSubviewWithController:self switchId:indexPath.row];
    self.hidesBottomBarWhenPushed = YES;
    if (indexPath.row >0 && indexPath.row <6) {
        SuggestionVC *suggestionVc = [[SuggestionVC alloc] init];
        suggestionVc.title = self.headerTitleArr[indexPath.row];
        suggestionVc.dataType = [NSString stringWithFormat:@"%ld", indexPath.row];
        [self.navigationController pushViewController:suggestionVc animated:YES];
    }else if(indexPath.row == 6) {
        CommentPoliceVC *commentVc = [[CommentPoliceVC alloc] init];
        [self.navigationController pushViewController:commentVc animated:YES];
    }else if(indexPath.row == 7) {
        DirectorMailVC *commentVc = [[DirectorMailVC alloc] init];
        [self.navigationController pushViewController:commentVc animated:YES];
    }else if(indexPath.row == 8) {
        ConsultOnlineVC *commentVc = [[ConsultOnlineVC alloc] init];
        [self.navigationController pushViewController:commentVc animated:YES];
    }else if(indexPath.row == 9) {
        CrimeReportVC *commentVc = [[CrimeReportVC alloc] init];
        [self.navigationController pushViewController:commentVc animated:YES];
    }
    
    
}

-(UICollectionView *)mainCollectionView {
    if (_mainCollectionView) {
        return _mainCollectionView;
    }
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat itemWidth = [flowlayout fixSlit:CGRectMake(0, 0, SCREN_WIDTH, SCREN_HEIGHT-64) colCount:3 space:0];
    flowlayout.itemSize = CGSizeMake(itemWidth, itemWidth);
    flowlayout.minimumInteritemSpacing = 0;
    flowlayout.minimumLineSpacing = 0;
    flowlayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);//这里设置了属性值之后，不要再实现相应的代理方法了，否则属性设置无效。
    flowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    
    _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(SCREN_WIDTH-itemWidth*3, 0, itemWidth*3, SCREN_HEIGHT-64) collectionViewLayout:flowlayout];
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
    _mainCollectionView.backgroundColor = COLOR_WITH_RGB(255, 255, 255);
    [_mainCollectionView registerNib:[UINib nibWithNibName:@"PeopleAppealCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"collectioncell"];
    return _mainCollectionView;
}

-(NSArray *)headerTitleArr {
    if (_headerTitleArr) {
        return _headerTitleArr;
    }
    _headerTitleArr = @[@"警务热线", @"我要举报", @"我要建议", @"我要投诉", @"我要咨询", @"我要上访", @"我要评警", @"局长信箱", @"在线咨询", @"违法犯罪线索有奖举报"];
    
    return _headerTitleArr;
}

-(PeopleAppealDataModel *)dataModel {
    if (_dataModel) {
        return _dataModel;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:@"complaint_item" ofType:@"txt"];
    NSError *error;
    NSString *str = [NSString stringWithContentsOfFile:path encoding: NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"error = %@", error);
    }
    
    if (str) {
        NSLog(@"str= %@", str);
    }
    _dataModel = [[PeopleAppealDataModel alloc] initWithString:str error:nil];
    
    return _dataModel;
}


@end
