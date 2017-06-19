//
//  MoveCarServiceVC.m
//  PoliceService
//
//  Created by horse on 2017/2/17.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "MoveCarServiceVC.h"
#import "PopoverAction.h"
#import "PopoverView.h"
#import "RequestService.h"
#import "WJHUD.h"
#import "UDIDManager.h"
#import "GlobalVariableManager.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
@interface MoveCarServiceVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,BMKLocationServiceDelegate>
@property (strong, nonatomic) IBOutlet UILabel *carTypeLabel;
@property (strong, nonatomic) IBOutlet UITextField *carNumberTF;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (strong, nonatomic) NSArray *carTypeArray;
@property (strong, nonatomic) UIImagePickerController *picker;
@property (strong, nonatomic) UIImage *pickedImage;

/**车类型*/
@property (nonatomic, strong) NSString *carType;
@property (nonatomic, strong) BMKLocationService *locationService;
@property (nonatomic, strong) BMKUserLocation *userLocation;

@end

@implementation MoveCarServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"移车服务";
    [self setUpLeftNavbarItem];
    [self getCarType];
    self.locationService = [[BMKLocationService alloc]init];
    _locationService.delegate = self;
    [_locationService startUserLocationService];
}

- (void)getCarType{
    [RequestService  getAppDataDictWithParamDict:@{@"type":@"plate_type"} resultBlock:^(BOOL success, id object) {
        if (success) {
            if ([[object objectForKey:@"code"] isEqualToString:@"1"]) {
                self.carTypeArray = object[@"data"];
            }
        }
    }];
}
- (void)setUpLeftNavbarItem {
//    typeof(self) __weak wself = self;
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
        
    }];
}

- (IBAction)clearTextField:(UIButton *)sender {
    switch (sender.tag) {
        case 1001:
        {
            self.carNumberTF.text = nil;
        }
            break;
        default:
            break;
    }
}
- (IBAction)selectCarTypeAction:(UIButton *)sender {
    NSMutableArray *popOverActions = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.carTypeArray.count; i ++ ) {
        NSDictionary *dict = self.carTypeArray[i];
        PopoverAction *pop = [PopoverAction actionWithTitle:dict[@"label"] handler:^(PopoverAction *action) {
            self.carType = action.title;
            self.carTypeLabel.text = action.title;
            self.carType = dict[@"value"];
        }];
        [popOverActions addObject:pop];
    }
    [self showPopoverViewWithView:sender actions:popOverActions];
}

- (void)showPopoverViewWithView:(UIView *)view  actions:(NSArray *)actions{
    if (actions.count == 0) {
        NSLog(@"showPopoverViewWithView actions 为空");
        return;
    }
    PopoverView* popoverView = [PopoverView popoverView];
    popoverView.style = PopoverViewStyleDefault;
    popoverView.hideAfterTouchOutside = YES; // 点击外部时允许隐藏
    [popoverView showToView:view withActions:actions];
}
- (IBAction)selectImageButton:(id)sender {
    if (!_picker) {
        _picker = [[UIImagePickerController alloc]init];
        _picker.delegate = self;
//        _picker.allowsEditing = YES;
    }
   
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"相机拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:_picker animated:YES completion:NULL];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:_picker animated:YES completion:NULL];
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [_picker dismissViewControllerAnimated:YES completion:NULL];
    self.pickedImage = info[UIImagePickerControllerOriginalImage];
    [self.imageButton setBackgroundImage:_pickedImage forState:UIControlStateNormal];
}

- (IBAction)commitAction:(id)sender {
    if (!_pickedImage) {
        [WJHUD showText:@"请选择图片" onView:self.view];
        return;
    }
    if (_carNumberTF.text.length<1) {
        [WJHUD showText:@"请填写车牌号码" onView:self.view];
        return;
    }
    if (!_carType) {
        [WJHUD showText:@"请选择车型" onView:self.view];
        return;
    }
    
    NSString *udid = [UDIDManager getUDID];
    [WJHUD showOnView:self.view];
    [RequestService moveCarWithParamDict:@{@"cartype":_carType,@"carnum":_carNumberTF.text,@"imei":udid,@"myPhone":[GlobalVariableManager manager].phone,@"lat":@(self.userLocation.location.coordinate.latitude),@"lng":@(self.userLocation.location.coordinate.latitude)} image:_pickedImage resultBlock:^(BOOL success, id  _Nullable object) {
        [WJHUD hideFromView:self.view];
        if (success) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    self.userLocation = userLocation;
}
@end
