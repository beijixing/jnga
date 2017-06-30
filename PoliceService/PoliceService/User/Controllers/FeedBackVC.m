//
//  FeedBackVC.m
//  PoliceService
//
//  Created by fosung on 2017/6/30.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "FeedBackVC.h"
#import "WJTextView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "WJHUD.h"
#import "RequestService.h"


@interface FeedBackVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (strong, nonatomic) UIAlertController *alert;
@property (strong,nonatomic) UIImagePickerController *imagePicker;

@property (weak, nonatomic) IBOutlet WJTextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (assign,nonatomic) BOOL isPhotoLibrary;//是否从照片库选择如果为1表示照片库，0代表拍照
@property (strong, nonatomic) NSMutableArray *mediaArray;


@end

@implementation FeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"意见反馈";
    [self setUpLeftNavbarItem];
    self.textView.fontOfPlaceHolder = [UIFont systemFontOfSize:15];
    self.textView.placeHolder = @"请输入遇到的问题或建议";
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
- (IBAction)choosePicture:(id)sender {
    if (!self.alert) {
        self.alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *photoLibrary = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.isPhotoLibrary = YES;
            [self presentViewController:self.imagePicker animated:YES completion:nil];
        }];
        
        UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.isPhotoLibrary = NO;
            [self presentViewController:self.imagePicker animated:YES completion:nil];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [self.alert addAction:photoLibrary];
        [self.alert addAction:camera];
        [self.alert addAction:cancel];
    }
    
    [self presentViewController:self.alert animated:YES completion:nil];
}
- (IBAction)submit:(id)sender {
    
    if ([_textView.text isEqualToString:@""]) {
        [WJHUD showText:@"请输入意见或建议" onView:self.view];
        return;
    }
    if (!_mediaArray) {
        self.mediaArray = [NSMutableArray new];
    }
    [WJHUD showOnView:self.view];

    [RequestService feedBackWithMediaArray:_mediaArray progress:^(NSProgress * _Nonnull progress) {
        if (progress.fractionCompleted == 1) {
            NSLog(@"%f",progress.fractionCompleted);
            dispatch_async(dispatch_get_main_queue(), ^{
                [WJHUD hideFromView:self.view];
            });
        }
    } withParamDict:@{@"content":_textView.text,
                      @"phone":_phoneTextField.text
                      } resultBlock:^(BOOL success, id  _Nullable object) {
                          if (success) {
                              [WJHUD showOnWindowWithText:@"提交成功"];
                              [self.navigationController popViewControllerAnimated:YES];
                          }else{
                              [WJHUD hideFromView:self.view];
                              NSLog(@"%@",object);
                          }
        
    }];
}



#pragma mark - UIImagePickerController代理方法
//完成
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {//如果是拍照
        UIImage *image;
        //如果允许编辑则获得编辑后的照片，否则获取原始照片
        if (self.imagePicker.allowsEditing) {
            image=[info objectForKey:UIImagePickerControllerEditedImage];//获取编辑后的照片
        }else{
            image=[info objectForKey:UIImagePickerControllerOriginalImage];//获取原始照片
        }
        //        [self.photo setImage:image];//显示照片
        
        if (!_mediaArray) {
            self.mediaArray = [NSMutableArray new];
        }else{
            self.mediaArray = nil;
        }
        [self.mediaArray addObject:image];
        
        [self.imageButton setBackgroundImage:image forState:UIControlStateNormal];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//保存到相簿
    }
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    
}

-(UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker=[[UIImagePickerController alloc]init];
        _imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;//设置image picker的来源，这里设置为摄像头
        //UIImagePickerControllerSourceTypeSavedPhotosAlbum 从相册获取图片
        _imagePicker.cameraDevice=UIImagePickerControllerCameraDeviceRear;//设置使用哪个摄像头，这里设置为后置摄像头
        
        _imagePicker.allowsEditing=YES;//允许编辑
        _imagePicker.delegate=self;//设置代理，检测操作
    }

        if (_isPhotoLibrary) {
            _imagePicker.mediaTypes=@[(NSString *)kUTTypeImage];
            _imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        }else{
            _imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
            _imagePicker.mediaTypes=@[(NSString *)kUTTypeImage];
            _imagePicker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModePhoto;
        }
    return _imagePicker;
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
