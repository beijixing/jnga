//
//  MediaController.m
//  PoliceApp
//
//  Created by horse on 16/9/28.
//  Copyright © 2016年 zgl. All rights reserved.
//

#import "MediaController.h"
#import <AVFoundation/AVFoundation.h>

typedef void(^PropertyChangeBlock)(AVCaptureDevice *captureDevice);

@interface MediaController ()
@property(nonatomic, strong) AVCaptureSession *captureSession;//负责为输入输出设备之间的数据传递
@property(nonatomic, strong) AVCaptureDeviceInput *deviceInput;//从输入设备获取数据
@property(nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;//照片输出流
@property(nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;//相机拍摄预览层
@property(nonatomic, strong) CALayer *previewImageLayer;
@property (strong, nonatomic) IBOutlet UIButton *flashAutoButton;//自动闪光灯按钮
@property (strong, nonatomic) IBOutlet UIButton *flashOpenButton;//打开闪光灯按钮
@property (strong, nonatomic) IBOutlet UIButton *flashColseButton;//关闭闪光灯按钮
@property (strong, nonatomic) IBOutlet UIButton *takePhotoButton;//拍照按钮
@property (strong, nonatomic) IBOutlet UIView *photoContainerView;//
@property (strong, nonatomic) IBOutlet UIImageView *focusCursor;//聚焦光标
@property (strong, nonatomic) IBOutlet UIImageView *capturedPhoto;
@property (nonatomic, assign) CGFloat deviceScale;
@end

@implementation MediaController

- (void)viewDidLoad {
    [super viewDidLoad];
    CALayer *layer = self.photoContainerView.layer;
    layer.masksToBounds = YES;
    self.previewLayer.frame = layer.bounds;
    [layer insertSublayer:self.previewLayer below:self.focusCursor.layer];
    [self addNotificationToCaptureDevice:self.deviceInput.device];
    [self setFlashModeButtonStatus];
    [self addGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.captureSession startRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.captureSession stopRunning];
}

#pragma mark --Notifications
- (void)addNotificationToCaptureDevice:(AVCaptureDevice *)currentDevice {
    //添加区域改变捕获通知必须首先设置设备允许捕获
    [self changeDeviceProperty:currentDevice changeBlock:^(AVCaptureDevice *captureDevice) {
        captureDevice.subjectAreaChangeMonitoringEnabled = YES;
    }];
    
    NSNotificationCenter *  notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(areaChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:currentDevice];
}

-(void)removeNotificationFromCaptureDevice:(AVCaptureDevice *)captureDevice{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}

-(void)removeNotification{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

-(void)addNotificationToCaptureSession:(AVCaptureSession *)captureSession{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    //会话出错
    [notificationCenter addObserver:self selector:@selector(sessionRuntimeError:) name:AVCaptureSessionRuntimeErrorNotification object:captureSession];
}

- (void)areaChange:(NSNotification *)notification {

}

- (void)sessionRuntimeError:(NSNotification *)notification {

}

#pragma mark --ButtonListeners 
//切换前后摄像头
- (IBAction)changeCameraType:(id)sender {
    
}
- (IBAction)clearPreviewImage:(id)sender {
    [self.previewImageLayer removeFromSuperlayer];
    self.previewImageLayer = nil;
}

- (IBAction)takePhoto:(id)sender {
    //根据设备输出获得连接
    AVCaptureConnection *captureConnection=[self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    //根据连接取得设备输出的数据
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:captureConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer) {
            NSData *imageData=[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image=[UIImage imageWithData:imageData];
//            self.capturedPhoto.image = image;
            UIImageWriteToSavedPhotosAlbum(self.capturedPhoto.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            if (self.previewImageLayer) {
                [self.previewImageLayer removeFromSuperlayer];
                self.previewImageLayer = nil;
            }
            self.previewImageLayer = [CALayer layer];
            self.previewImageLayer.frame = self.previewLayer.frame;
//            image = [self rotate:image andOrientation:image.imageOrientation];
            
            //Below is the crop that is sort of working for me, but as you can see I am manually entering in values and just guessing and it still does not look perfect.
//            CGRect cropRect = [self cropingImage:image];
//            
//            CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
            image = [self cropCameraImage:image toPreviewLayerBounds:self.previewLayer];
            self.capturedPhoto.image = image;
            self.previewImageLayer.contents = (id)image.CGImage;
            self.previewImageLayer.frame = _previewLayer.frame;
            self.previewImageLayer.transform = CATransform3DMakeRotation(M_PI_2, 0, 0, 1);
            [self.previewLayer addSublayer:self.previewImageLayer];
            //            ALAssetsLibrary *assetsLibrary=[[ALAssetsLibrary alloc]init];
            //            [assetsLibrary writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:nil];
        }
        
    }];
}

-(UIImage*) cropCameraImage:(UIImage*) original toPreviewLayerBounds:(AVCaptureVideoPreviewLayer*) previewLayer {
    UIImage *ret = nil;
    
    CGRect previewImageLayerBounds = previewLayer.bounds;
    
    // This calculates the crop area.
    // keeping in mind that this works with on an unrotated image (so a portrait image is actually rotated counterclockwise)
    // thats why we use originalHeight to calculate the width
    float originalWidth  = original.size.width;
    float originalHeight = original.size.height;
    
    CGPoint A = previewImageLayerBounds.origin;
    CGPoint B = CGPointMake(previewImageLayerBounds.size.width, previewImageLayerBounds.origin.y);
    //    CGPoint C = CGPointMake(self.imageViewTop.bounds.origin.x, self.imageViewTop.bounds.size.height);
    CGPoint D = CGPointMake(previewImageLayerBounds.size.width, previewImageLayerBounds.size.height);
    
    CGPoint a = [previewLayer captureDevicePointOfInterestForPoint:A];
    CGPoint b = [previewLayer captureDevicePointOfInterestForPoint:B];
    //    CGPoint c = [previewLayer captureDevicePointOfInterestForPoint:C];
    CGPoint d =[previewLayer captureDevicePointOfInterestForPoint:D];
    
    float posX = floor(b.x * originalHeight);
    float posY = floor(b.y * originalWidth);
    
    CGFloat width = d.x * originalHeight - b.x * originalHeight;
    CGFloat height = a.y * originalWidth - b.y * originalWidth;
    CGRect cropRectangle = CGRectMake(posX, posY, width, height);
    
    // This performs the image cropping.
    CGImageRef imageRef = CGImageCreateWithImageInRect([original CGImage], cropRectangle);
    
    ret = [UIImage imageWithCGImage:imageRef
                              scale:original.scale
                        orientation:original.imageOrientation];
    
    CGImageRelease(imageRef);
    
    return ret;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if(error){
        NSLog(@"error = %@", error.localizedDescription);
    }
}

- (IBAction)flashAuto:(id)sender {
    [self setFlashMode:AVCaptureFlashModeAuto];
    [self setFlashModeButtonStatus];
}
- (IBAction)flashOpen:(id)sender {
    [self setFlashMode:AVCaptureFlashModeOn];
    [self setFlashModeButtonStatus];
    
}
- (IBAction)flashClose:(id)sender {
    [self setFlashMode:AVCaptureFlashModeOff];
    [self setFlashModeButtonStatus];
}

#pragma mark --PrivateMethods
- (AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition)position {
    NSArray *cameras = [AVCaptureDevice devices];
    for (AVCaptureDevice *device in cameras) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

- (void)addGestureRecognizer {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen:)];
    [self.photoContainerView addGestureRecognizer:tapGesture];
    
    UIPinchGestureRecognizer *pinchFesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchPreview:)];
    [self.photoContainerView addGestureRecognizer:pinchFesture];
}

- (void)tapScreen:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self.photoContainerView];
    //将UI坐标转化为摄像头坐标
    CGPoint cameraPoint = [self.previewLayer captureDevicePointOfInterestForPoint:point];
    [self setFocusCursorWithPoint:point];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:cameraPoint];
}

/// 焦距调整事件
- (void)pinchPreview:(UIPinchGestureRecognizer *)gesture
{
    CGFloat scale = self.deviceScale + (gesture.scale - 1);
    if (scale > 5) scale = 5;   // 最大5倍焦距
    if (scale < 1) scale = 1;   // 最小1倍焦距
    [self changeDeviceProperty:self.deviceInput.device changeBlock:^(AVCaptureDevice *captureDevice) {
        
        captureDevice.videoZoomFactor = scale;
    }];
    
    // 缩放结束时记录当前倍焦
    if (gesture.state == UIGestureRecognizerStateEnded) self.deviceScale = scale;
//    [self.previewLayer setAffineTransform:CGAffineTransformIdentity];
//    [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(scale, scale)];
}

- (void)setFocusCursorWithPoint:(CGPoint)position {
    self.focusCursor.center = position;
    self.focusCursor.transform = CGAffineTransformMakeScale(1.5, 1.5);
    self.focusCursor.alpha=1.0;
    [UIView animateWithDuration:1.0 animations:^{
        self.focusCursor.transform=CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.focusCursor.alpha=0;
    }];
}

- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point {
    [self changeDeviceProperty:self.deviceInput.device changeBlock:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
        
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:exposureMode];
        }
        
        if ([captureDevice isExposurePointOfInterestSupported]) {
            [captureDevice setExposurePointOfInterest:point];
        }
        
        [captureDevice setFocusPointOfInterest:point];
        
    }];
}

- (void)setFlashMode:(AVCaptureFlashMode)flashMode {
    [self changeDeviceProperty:self.deviceInput.device changeBlock:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFlashModeSupported:flashMode]) {
            captureDevice.flashMode = flashMode;
        }
            
    }];;
}

/**
 *  设置闪光灯按钮状态
 */
-(void)setFlashModeButtonStatus{
    AVCaptureDevice *captureDevice=[self.deviceInput device];
    AVCaptureFlashMode flashMode=captureDevice.flashMode;
    if([captureDevice isFlashAvailable]){
        self.flashAutoButton.hidden=NO;
        self.flashOpenButton.hidden=NO;
        self.flashColseButton.hidden=NO;
        self.flashAutoButton.enabled=YES;
        self.flashOpenButton.enabled=YES;
        self.flashColseButton.enabled=YES;
        switch (flashMode) {
            case AVCaptureFlashModeAuto:
                self.flashAutoButton.enabled=NO;
                break;
            case AVCaptureFlashModeOn:
                self.flashOpenButton.enabled=NO;
                break;
            case AVCaptureFlashModeOff:
                self.flashColseButton.enabled=NO;
                break;
            default:
                break;
        }
    }else{
        self.flashAutoButton.hidden=YES;
        self.flashOpenButton.hidden=YES;
        self.flashColseButton.hidden=YES;
    }
}



#pragma mark --Getters
-(AVCaptureSession *)captureSession {
    if (_captureSession) {
        return _captureSession;
    }
    _captureSession = [[AVCaptureSession alloc] init];
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPresetPhoto]) {
        [_captureSession setSessionPreset:AVCaptureSessionPresetPhoto];
    }
    
    //将设备输入添加到会话中
    if ([_captureSession canAddInput:self.deviceInput]) {
        [_captureSession addInput:self.deviceInput];
    }
    
    //将设备输出添加到会话中
    if ([_captureSession canAddOutput:self.stillImageOutput]) {
        [_captureSession addOutput:self.stillImageOutput];
    }
    
    
    
    return _captureSession;
}

- (AVCaptureDeviceInput *)deviceInput {
    if (_deviceInput){
        return _deviceInput;
    }
    AVCaptureDevice *captureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
    if (!captureDevice) {
        NSLog(@"获取AVCaptureDevice失败");
        return nil;
    }
    
    NSError *error = nil;
    _deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    if(error){
        NSLog(@"获取设备输入对象失败原因：%@", error.localizedDescription);
        return nil;
    }
    return _deviceInput;
}

- (AVCaptureStillImageOutput *)stillImageOutput {
    if (_stillImageOutput) {
        return _stillImageOutput;
    }
    _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettins = @{AVVideoCodecKey:AVVideoCodecJPEG};
    [_stillImageOutput setOutputSettings:outputSettins];
    return _stillImageOutput;
}

- (AVCaptureVideoPreviewLayer *)previewLayer {
    if (_previewLayer) {
        return _previewLayer;
    }
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    return _previewLayer;
}

/**
 *  改变设备属性的统一操作方法
 *
 *  @param propertyChange 属性改变操作
 */
-(void)changeDeviceProperty:(AVCaptureDevice *)captureDevice changeBlock:(PropertyChangeBlock)propertyChange{
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    }else{
        NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
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
