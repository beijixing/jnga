//
//  MyAppointment2VC.m
//  PoliceService
//
//  Created by fosung on 2017/6/21.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "MyAppointment2VC.h"
#import "WJHUD.h"
#import "RequestService.h"
#import "GlobalVariableManager.h"
#import "UDIDManager.h"
#import "MyAppointment2Cell.h"
#import "MyAppointmentDetail2VC.h"

@interface MyAppointment2VC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataAry;

@end

@implementation MyAppointment2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerNib:[UINib nibWithNibName:@"MyAppointment2Cell" bundle:nil] forCellReuseIdentifier:@"MyAppointment2CellID"];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.title = @"我的预约";
    [self setUpLeftNavbarItem];
    [self getData];
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
-(void)getData{
    [WJHUD showOnView:self.view];

    [RequestService getMyAppointment2WithParamDict:@{@"fcard":[GlobalVariableManager manager].codeId,
                                                 @"uuid":[UDIDManager getUDID],
                                                 @"token":[GlobalVariableManager manager].loginToken
                                                 } resultBlock:^(BOOL success, id  _Nullable object) {
                                                     [WJHUD hideFromView:self.view];
                                                     if (success) {
                                                         if (!_dataAry) {
                                                             self.dataAry = [NSMutableArray new];
                                                         }
                                                         self.dataAry = [object objectForKey:@"data"];
                                                     }
                                                     [self.tableView reloadData];
                                                 }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataAry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyAppointment2Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyAppointment2CellID" forIndexPath:indexPath];
    [cell setContentWithDic:_dataAry[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic =_dataAry[indexPath.row];
    
    [self performSegueWithIdentifier:@"PushToDetail" sender:[dic objectForKey:@"id"]];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"PushToDetail"]) {
        MyAppointmentDetail2VC *vc = segue.destinationViewController;
        vc.detailID = sender;
    }
}


@end
