//
//  QueryBusinessPlaceTableVC.m
//  PoliceService
//
//  Created by fosung on 2017/5/26.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "QueryBusinessPlaceTableVC.h"
#import "RequestService.h"
#import "WJHUD.h"

@interface QueryBusinessPlaceTableVC ()
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation QueryBusinessPlaceTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (_isPolice) {
        [self getPoliceData];
        self.title = @"办事场所县市区查询";
    }else{
        [self getGloablData];
        self.title = @"办事场所细分项查询";
    }

    [self setUpLeftNavbarItem];

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
    [RequestService queryCityWithParamDict:@{@"subdivisionProject":@"派出所"
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

-(void)getGloablData{
    [WJHUD showOnView:self.view];
    [RequestService queryBusinessPlaceWithresultBlock:^(BOOL success, id  _Nullable object) {
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



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *titleString = _dataArray[indexPath.row];
    
    if ([titleString isEqualToString:@"派出所"]) {
        QueryBusinessPlaceTableVC *vc = [[UIStoryboard storyboardWithName:@"Colligation" bundle:nil]instantiateViewControllerWithIdentifier:@"QueryBusinessPlaceVC"];
        vc.isPolice = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
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
