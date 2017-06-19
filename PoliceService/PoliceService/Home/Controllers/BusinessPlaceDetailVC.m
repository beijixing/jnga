//
//  BusinessPlaceDetailVC.m
//  PoliceService
//
//  Created by fosung on 2017/5/26.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "BusinessPlaceDetailVC.h"
#import "WJHUD.h"
#import "RequestService.h"
#import "BusinessPlaceCell.h"

@interface BusinessPlaceDetailVC ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation BusinessPlaceDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpLeftNavbarItem];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 80;
    [self getPoliceData];
}

- (void)setUpLeftNavbarItem {
    //    typeof(self) __weak wself = self;
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getPoliceData{
    [WJHUD showOnView:self.view];
    [RequestService queryCityWithParamDict:@{@"subdivisionProject":_searchString
                                             } resultBlock:^(BOOL success, id  _Nullable object) {
                                                 [WJHUD hideFromView:self.view];
                                                 if (!_dataArray) {
                                                     self.dataArray = [NSMutableArray new];
                                                 }
                                                 if (success) {
                                                     self.dataArray = [object objectForKey:@"data"];
                                                 }
                                                 
                                                 [self.tableView reloadData];
                                             }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BusinessPlaceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessPalaceCellID" forIndexPath:indexPath];
    [cell setContentWithObject:_dataArray[indexPath.row]];
    return cell;
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
