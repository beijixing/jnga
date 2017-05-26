//
//  CrimeReportVC.m
//  PoliceService
//
//  Created by fosung on 2017/5/24.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "CrimeReportVC.h"
#import "WJTextView.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/ALAsset.h>
#import "RequestService.h"
#import "WJHUD.h"
#import "Validator.h"

@interface CrimeReportVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *idCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet WJTextView *contentTV;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (assign,nonatomic) int isVideo;//是否录制视频，如果为1表示录制视频，0代表拍照
@property (assign,nonatomic) BOOL isPhotoLibrary;//是否从照片库选择如果为1表示照片库，0代表拍照
@property (strong,nonatomic) UIImagePickerController *imagePicker;
@property (strong ,nonatomic) AVPlayer *player;//播放器，用于录制完视频后播放视频

@property (strong, nonatomic) UIImage *reportImage;
@property (strong, nonatomic) ALAsset *videoAsset;
@property (strong, nonatomic) ALAssetsLibrary *library;
@end

@implementation CrimeReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"违法犯罪线索有奖举报";
    [self setUpLeftNavbarItem];
//    self.contentTV.placeHolder = @"请输入违法线索";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpLeftNavbarItem {
    [self setLeftNavigationBarButtonItemWithImage:@"back" andAction:^{
        
    }];
}
- (IBAction)choosePhoto:(id)sender {
    static UIAlertController *alert;
    if (!alert) {
        alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *photoLibrary = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.isVideo = NO;
            self.isPhotoLibrary = YES;
            [self presentViewController:self.imagePicker animated:YES completion:nil];
        }];
        
        UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.isVideo = NO;
            self.isPhotoLibrary = NO;
            [self presentViewController:self.imagePicker animated:YES completion:nil];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:photoLibrary];
        [alert addAction:camera];
        [alert addAction:cancel];
    }

    [self presentViewController:alert animated:YES completion:nil];


}
- (IBAction)recordVideo:(id)sender {
    self.isVideo = YES;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
    
}
- (IBAction)submit:(id)sender {
    if ([Validator isSpaceOrEmpty:_nameTF.text]) {
        [WJHUD showText:@"请输入姓名" onView:self.view];
        return;
    }
    
    if ([Validator isSpaceOrEmpty:_idCodeTF.text]) {
        [WJHUD showText:@"请输入身份证号" onView:self.view];
        return;
    }
    
    if ([Validator isSpaceOrEmpty:_phoneTF.text]) {
        [WJHUD showText:@"请输入手机号" onView:self.view];
        return;
    }
    
    if ([Validator isSpaceOrEmpty:_contentTV.text]) {
        [WJHUD showText:@"请输入举报线索" onView:self.view];
        return;
    }
    NSMutableArray *mediaArray =[NSMutableArray new];
    if (_reportImage) {
        [mediaArray addObject:_reportImage];
    }
    if (_videoAsset) {
        [mediaArray addObject:_videoAsset];
    }
    
    [RequestService reportCrimeWithMediaArray:mediaArray withParamDict:@{@"content":_contentTV.text,
                                                                         @"informer":_nameTF.text,
                                                                         @"informer_phone":_phoneTF.text,
                                                                         } progress:^(NSProgress * _Nonnull progress) {
        
    } resultBlock:^(BOOL success, id  _Nullable object) {
        
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
        self.reportImage = image;
        [self.photoButton setBackgroundImage:image forState:UIControlStateNormal];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//保存到相簿
    }else if([mediaType isEqualToString:(NSString *)kUTTypeMovie]){//如果是录制视频
        NSLog(@"video...");
        NSURL *url=[info objectForKey:UIImagePickerControllerMediaURL];//视频路径
        NSString *urlStr=[url path];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
            //保存视频到相簿，注意也可以使用ALAssetsLibrary来保存
//            UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);//保存视频到相簿
            [self saveVideoToPhotos:url];
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"取消");
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - 私有方法
-(UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker=[[UIImagePickerController alloc]init];
        _imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;//设置image picker的来源，这里设置为摄像头
        //UIImagePickerControllerSourceTypeSavedPhotosAlbum 从相册获取图片
        _imagePicker.cameraDevice=UIImagePickerControllerCameraDeviceRear;//设置使用哪个摄像头，这里设置为后置摄像头

        _imagePicker.allowsEditing=YES;//允许编辑
        _imagePicker.delegate=self;//设置代理，检测操作
    }
    if (self.isVideo) {
        _imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
        _imagePicker.mediaTypes=@[(NSString *)kUTTypeMovie];
        _imagePicker.videoQuality=UIImagePickerControllerQualityTypeIFrame1280x720;
        _imagePicker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModeVideo;//设置摄像头模式（拍照，录制视频）
        
    }else{
        if (_isPhotoLibrary) {
            _imagePicker.mediaTypes=@[(NSString *)kUTTypeImage];
            _imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        }else{
            _imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
            _imagePicker.mediaTypes=@[(NSString *)kUTTypeImage];
            _imagePicker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModePhoto;
        }
    }
    return _imagePicker;
}

//视频保存后的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"视频保存成功.");
        //录制完之后自动播放
        NSURL *url=[NSURL fileURLWithPath:videoPath];
        _player=[AVPlayer playerWithURL:url];
        AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:_player];
        playerLayer.frame=CGRectMake(0, 0, 80, 80);
        
        [self.videoButton.layer addSublayer:playerLayer];
        [_player play];
        
    }
}
- (void)saveVideoToPhotos:(NSURL*)url
{
    if(nil == _library){
        _library = [[ALAssetsLibrary alloc] init];
    }
    
    __weak __typeof__(self) weakSelf = self;
    
    [_library writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error) {
        //录制完之后自动播放
        //            NSURL *url=[NSURL fileURLWithPath:url];
        _player=[AVPlayer playerWithURL:url];
        AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:_player];
        playerLayer.frame=CGRectMake(0, 0, 80, 80);
        
        [self.videoButton.layer addSublayer:playerLayer];
        [_player play];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{

            [weakSelf.library assetForURL:assetURL resultBlock:^(ALAsset *asset){//这里的asset便是我们所需要的图像对应的ALAsset了
                self.videoAsset = asset;
            }failureBlock:^(NSError *error) {
                
            }];
        });
    }];
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
