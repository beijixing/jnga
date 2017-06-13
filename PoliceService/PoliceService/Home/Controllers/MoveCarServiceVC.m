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
@interface MoveCarServiceVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIButton *callButton;
@property (strong, nonatomic) IBOutlet UILabel *carTypeLabel;
@property (strong, nonatomic) IBOutlet UITextField *carNumberTF;
@property (strong, nonatomic) IBOutlet UITextField *carColorTF;
@property (strong, nonatomic) IBOutlet UITextField *carBrandTF;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (strong, nonatomic) NSArray *carTypeArray;
@property (strong, nonatomic) UIImagePickerController *picker;

/**车类型*/
@property (nonatomic, strong) NSString *carType;

@end

@implementation MoveCarServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"移车服务";
    [self setUpLeftNavbarItem];
    [self.callButton setTitle:@"\U0000E603" forState:UIControlStateNormal];
    self.callButton.titleLabel.font = [UIFont fontWithName:@"iconfont" size:14.0];
    [self getCarType];
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
        case 1002:
        {
            self.carColorTF.text = nil;
        }
            break;
        case 1003:
        {
            self.carBrandTF.text = nil;
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
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
}

- (IBAction)commitAction:(id)sender {
    
    
}
@end
