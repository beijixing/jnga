//
//  MemberCenterVC.m
//  PoliceService
//
//  Created by horse on 2017/2/10.
//  Copyright © 2017年 zgl. All rights reserved.
//
#import "MemberCenterVC.h"
#import "UIFactory.h"
#import "UIView+CornerRadius.h"
#import "FSMacro.h"
#import "MemberCenterCell.h"
#import "LoginVC.h"
#import "MyBusinessVC.h"
#import "MyAppointmentVC.h"
#import "MyConsultingVC.h"
#import "ChangePhoneNumberVC.h"
#import "RegisterVC.h"
#import "CheckVersionVC.h"
#import "ChangePasswordVC.h"
#import "MemberCenterTableDataSource.h"
#import "GlobalVariableManager.h"
#import "RequestService.h"
#import "GlobalFunctionManager.h"
#import "WJHUD.h"
#import "NotifiViewController.h"
#import "HuzhengYeWuVC.h"
#import "MyBusinessNewListVC.h"
#import "ActionSheetView.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentMessageObject.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>

NSString *cellIdentifier = @"cell";
@interface MemberCenterVC ()
@property(nonatomic, strong) UITableView *operationTableview;
@property(nonatomic, strong) NSMutableArray *sectionOneTitleArr;
@property(nonatomic, strong) NSMutableArray *sectionTwoTitleArr;
@property(nonatomic, strong) NSMutableArray *sectionThreeTitleArr;
@property(nonatomic, strong) MemberCenterTableDataSource *tableDataSoure;
@property(nonatomic, strong) UIButton *quitAppBtn;
@end

@implementation MemberCenterVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人中心";
    [self.view addSubview:self.operationTableview];
    [self initImageAndTitleArr];
//    [self hideNavigationBarDividedLine];
//    [self initMemberHeaderInfo];
    if ([GlobalVariableManager manager].userId == nil) {
        self.quitAppBtn.hidden = YES;
    }else {
        self.quitAppBtn.hidden = NO;
    }
}

- (void)initMemberHeaderInfo {
    UIImageView *headView = [UIFactory createImageViewWith:CGRectMake(0, 0, SCREN_WIDTH, 250*KSCALE) imageName:@"memcenterBg"];
//    headView.backgroundColor = COLOR_WITH_RGB(61, 161, 230);//临时设置
    UIImageView *appIconImage = [UIFactory createImageViewWith:CGRectMake(0, 0, 100*KSCALE, 100*KSCALE) imageName:@"logo"];
    headView.userInteractionEnabled = YES;
    
    appIconImage.backgroundColor = [UIColor greenColor];
    appIconImage.center = CGPointMake(SCREN_WIDTH/2, 200*KSCALE/2);
    appIconImage.cornerRadius = 50*KSCALE;
    [headView addSubview:appIconImage];
    
//    UILabel *loginBtn = [UIFactory createLabelWith:CGRectMake(0, 0, self.view.frame.size.width/2, 60*KSCALE) textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter textFont:[UIFont fontWithName:@"Arial" size:15.0] text:@"立即登录"];
    
    UIButton *loginBtn = [UIFactory createButtonWith:CGRectMake(0, 0, self.view.frame.size.width/2, 60*KSCALE) selector:@selector(toLogin:) target:self titleColor:[UIColor whiteColor] title:@"苏小小"];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:15.0];
    loginBtn.center = CGPointMake(SCREN_WIDTH/2, 200*KSCALE);
    [headView addSubview:loginBtn];
    
    UIButton *identifyBtn = [UIFactory createButtonWith:CGRectMake(0, 0, 100, 30*KSCALE) selector:@selector(identify:) target:self titleColor:[UIColor whiteColor] title:@"实名认证"];
    identifyBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:12.0];
    identifyBtn.center = CGPointMake(SCREN_WIDTH/2, 220*KSCALE);
//    [headView addSubview:identifyBtn];
    [self.view addSubview:headView];
}

- (void)identify:(UIButton *)btn {
    //实名认证
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:[[RegisterVC alloc] init] animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)toLogin:(UIButton *)btn {
//    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:[[LoginVC alloc] init] animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
    [self presentViewController:[[LoginVC alloc] init] animated:YES completion:nil];
}

#pragma mark - PrivateMethods
- (UITableView *)operationTableview {
    if (_operationTableview) {
        return _operationTableview;
    }
    _operationTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, SCREN_HEIGHT-64) style:UITableViewStylePlain];
    _operationTableview.delegate = self.tableDataSoure;
    _operationTableview.dataSource = self.tableDataSoure;
    _operationTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    if(SCREN_HEIGHT > 568.0){
//        _operationTableview.scrollEnabled = NO;
    }
    _operationTableview.backgroundColor = COLOR_WITH_RGB(240, 244, 249);
    [_operationTableview registerNib:[UINib nibWithNibName:@"MemberCenterCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentifier];
    
    NSLog(@"MainScreenHeight = %f MainScreenwidth= %f",SCREN_HEIGHT, SCREN_WIDTH);
    
    
    UIView *footerView = [UIFactory createViewWith:CGRectMake(0, 0, SCREN_WIDTH,  120*KSCALE)];
    footerView.backgroundColor = COLOR_WITH_RGB(240, 244, 249);
    
    self.quitAppBtn = [UIFactory createButtonWith:CGRectMake(0, 0, SCREN_WIDTH/1.2, 60*KSCALE) selector:@selector(quitAppClick:) target:self titleColor:[UIColor whiteColor] backgroudColor:COLOR_WITH_RGB(61, 162, 230) title:@"退出登录"];
    self.quitAppBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:15];
    self.quitAppBtn.center = CGPointMake(SCREN_WIDTH/2, footerView.frame.size.height/2);
    self.quitAppBtn.cornerRadius = 4.0;
    [footerView addSubview: self.quitAppBtn];
    _operationTableview.tableFooterView = footerView;
    return _operationTableview;
}

- (void)quitAppClick:(UIButton *)button {
    [GlobalVariableManager manager].loginToken = nil;
    [GlobalVariableManager manager].userId = nil;
    [GlobalVariableManager manager].phone = nil;
    [GlobalVariableManager manager].pswd = nil;
    self.quitAppBtn.hidden = YES;
}

- (void)initImageAndTitleArr {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    self.sectionOneTitleArr = [[NSMutableArray alloc] init];
    
    [self.sectionOneTitleArr addObject:@{@"title":@"我的业务", @"icon":@"yw"}];
    [self.sectionOneTitleArr addObject:@{@"title":@"我的预约", @"icon":@"yy"}];
    [self.sectionOneTitleArr addObject:@{@"title":@"我的咨询", @"icon":@"zx"}];
    [self.sectionOneTitleArr addObject:@{@"title":@"户政业务", @"icon":@"huzheng"}];
    [self.sectionOneTitleArr addObject:@{@"title":@"通知公告", @"icon":@"my_tzgg"}];
    
    self.sectionTwoTitleArr = [[NSMutableArray alloc] init];
    [self.sectionTwoTitleArr addObject:@{@"title":@"手机号变更", @"icon":@"sjh"}];
    [self.sectionTwoTitleArr addObject:@{@"title":@"修改密码", @"icon":@"mm"}];
    [self.sectionTwoTitleArr addObject:@{@"title":@"应用分享", @"icon":@"share_ic"}];
    
    self.sectionThreeTitleArr = [[NSMutableArray alloc] init];
    [self.sectionThreeTitleArr addObject:@{@"title":@"版本检测", @"icon":@"bb"}];
    [self.sectionThreeTitleArr addObject:@{@"title":@"意见反馈", @"icon":@"feed_back"}];
}

- (MemberCenterTableDataSource *)tableDataSoure {
    if (_tableDataSoure) {
        return _tableDataSoure;
    }
    
    _tableDataSoure = [[MemberCenterTableDataSource alloc] init];
    _tableDataSoure.cellIdentifierBlock = ^NSString*(NSIndexPath *indexPath){
        return cellIdentifier;
    };
    _tableDataSoure.numberOfSectionBlock = ^NSInteger(){
        return 3;
    };
    _tableDataSoure.heightForRowBlock = ^CGFloat(NSIndexPath *indexPath) {
        if (self.view.frame.size.height > 568) {
            return 80*KSCALE;
        }else {
            return 44;
        }
    };
    [self configRowCount:_tableDataSoure];
    [self configCellData:_tableDataSoure];
    [self configDidSelectedCell:_tableDataSoure];
    return _tableDataSoure;
}

- (void)configCellData:(MemberCenterTableDataSource *)dataSource {
    typeof(self) __weak wself = self;
    
    dataSource.configCellDataBlock = ^id(NSIndexPath *indexPath) {
        NSMutableDictionary *dataDict;
        switch (indexPath.section) {
            case 0:
            {
               return wself.sectionOneTitleArr[indexPath.row];
            }
                break;
            case 1:
            {
                return wself.sectionTwoTitleArr[indexPath.row];
            }
                break;
            case 2:
            {
                return wself.sectionThreeTitleArr[indexPath.row];
            }
                break;
            default:
                break;
        }
        return dataDict;
    };
}

- (void)configRowCount:(MemberCenterTableDataSource *) dataSource {
    typeof(self) __weak wself = self;
    dataSource.rowsInSectionBlock = ^NSInteger(NSInteger section) {
        switch (section) {
            case 0:
                return wself.sectionOneTitleArr.count;
                break;
            case 1:
                return wself.sectionTwoTitleArr.count;
                break;
            case 2:
                return wself.sectionThreeTitleArr.count;
                break;
            default:
                return 0;
                break;
        }
    };
}

- (void)configDidSelectedCell:(MemberCenterTableDataSource *)dataSource {
    typeof(self) __weak wself = self;
    dataSource.cellSelectedBlock = ^(NSIndexPath *indexPath) {
        
        switch (indexPath.section) {
            case 0:
            {
                switch (indexPath.row) {
                    case 0:
                    {
//                        [wself checkLoginAndGotoNextVC:@"MyBusinessVC"];
                        [wself goMyBusiness];
                    }
                        break;
                    case 1:
                    {
                        [wself checkLoginAndGotoNextVC:@"MyAppointmentVC"];
                    }
                        break;
                    case 2:
                    {
                        [wself checkLoginAndGotoNextVC:@"MyConsultingVC"];
                    }
                        break;
                    case 3:
                    {
                        [wself goHuZheng];
                    }
                        break;
                    case 4:
                    {
                        [wself goNotifi];
                    }
                        break;
                    default:
                        break;
                }
            }
                break;
            case 1 :
            {
                switch (indexPath.row) {
                    case 0:
                    {
                        [wself checkLoginAndGotoNextVC:@"ChangePhoneNumberVC"];
                    }
                        break;
                    case 1:
                    {
                        [wself checkLoginAndGotoNextVC:@"ChangePasswordVC"];
                    }
                        break;
                    case 2:
                    {
                        [wself shareAction:nil];
                    }
                        break;
                    default:
                        break;
                }
            }
                break;
            case 2: {
                switch (indexPath.row) {
                    case 0:
                    {
                        [GlobalFunctionManager checkVersionOnViewController:wself];
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
    };
}

- (void)checkLoginAndGotoNextVC:(NSString *)controllerName {
    typeof(self) __weak wself = self;
    if ([GlobalVariableManager manager].userId == nil) {
        //需要登录才能进入
        [GlobalFunctionManager autoLoginOrLoginOnViewController:wself callBack:^{
            wself.quitAppBtn.hidden = NO;
            [wself gotoNextViewControllerWithName:controllerName];
        }];
    }else {
        [self gotoNextViewControllerWithName:controllerName];
    }
}

- (void)gotoNextViewControllerWithName:(NSString *)controllerName {
    self.hidesBottomBarWhenPushed = YES;
    UIViewController *pushVc = [[NSClassFromString(controllerName) alloc] init];
    [self.navigationController pushViewController:pushVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
- (void)goNotifi{
    NotifiViewController *vc = [[UIStoryboard storyboardWithName:@"User" bundle:nil]instantiateViewControllerWithIdentifier:@"NotifiVC"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)goHuZheng{
    HuzhengYeWuVC *vc = [[UIStoryboard storyboardWithName:@"User" bundle:nil]instantiateViewControllerWithIdentifier:@"HuzhengYeWuVCID"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)goMyBusiness{
    MyBusinessNewListVC *vc = [[UIStoryboard storyboardWithName:@"User" bundle:nil]instantiateViewControllerWithIdentifier:@"MyBusinessNewVCID"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)shareAction:(UIButton *)sender {
    NSArray *titlearr = @[@"微信好友",@"QQ好友"];
    NSMutableArray *imageArr = @[].mutableCopy;
    
    if ([WXApi isWXAppInstalled] ) {
        [imageArr addObject:@"wechat"];
        [imageArr addObject:@"ssdk_oks_classic_qq"];
    }else{
        [imageArr addObject:@"wechat_grey"];
        [imageArr addObject:@"ssdk_oks_classic_qq"];
    }
    
    ActionSheetView *actionsheet = [[ActionSheetView alloc] initWithShareHeadOprationWith:titlearr andImageArry:imageArr andProTitle:@"分享" and:ShowTypeIsShareStyle];
    [actionsheet setBtnClick:^(NSInteger btnTag) {
        NSLog(@"\n点击第几个====%ld\n当前选中的按钮title====%@",(long)btnTag,titlearr[btnTag]);
        switch (btnTag) {
            case 0:
                [self shareWXChat:WXSceneSession];
                break;
            case 1:
                [self shareQQFriend];
                break;
                
            default:
                break;
        }
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:actionsheet];
    
}
- (void)shareWXChat:(int)wxScene {

    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"ic_jnga_qcode"]];
    
    WXImageObject *imageObject = [WXImageObject object];
    UIImage *image =[UIImage imageNamed:@"ic_jnga_qcode"];
    imageObject.imageData = UIImageJPEGRepresentation(image, 0.5);
    
    message.mediaObject = imageObject;

    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.text = @"济宁公安便民服务APP已上线，欢迎下载";
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    [WXApi sendReq:req];
    
}

-(void)shareQQFriend{
    //开发者分享图片数据
    UIImage *image =[UIImage imageNamed:@"ic_jnga_qcode"];
    
    NSData *imgData = UIImageJPEGRepresentation(image, 0.5);
    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:imgData
                                
                                               previewImageData:imgData
                                
                                                          title:@"济宁公安便民服务APP已上线，欢迎下载"
                                
                                                    description:nil];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    
    //将内容分享到qq
    
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];

}
@end
