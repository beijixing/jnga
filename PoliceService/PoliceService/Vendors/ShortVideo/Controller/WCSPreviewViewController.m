//
//  WCSPreviewViewController.m
//  WeChatSightDemo
//
//  Created by 吴珂 on 16/8/26.
//  Copyright © 2016年 吴珂. All rights reserved.
//

#import "WCSPreviewViewController.h"
#import "WKMovieRecorder.h"
#import "WKVideoConverter.h"
#import "UIImageView+PlayGIF.h"
#import "WCSPlayMovieController.h"
#import "WJHUD.h"
#import "RequestService.h"
//#import "UploadFileModel.h"
#import "IQKeyboardManager.h"
//#import "ChatAPIService.h"
//#import "ShareInGroupModel.h"
//#import "FSGroupShareElem.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface WCSPreviewViewController ()
{
    NSMutableDictionary *dataDictionary;
    NSString *fileURLs;
}
@property (weak, nonatomic) IBOutlet UIButton *previewButton;//预览按钮
@property (weak, nonatomic) IBOutlet UIImageView *preImageView;//播放gif

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) WKVideoConverter *converter;

@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) NSURL *videoURL;

@property (nonatomic, strong) NSURL *gifURL;

@property (nonatomic, strong) WCSPlayMovieController *playVC;

@property (weak, nonatomic) IBOutlet UIView *selectGroup_view;
@property (weak, nonatomic) IBOutlet UILabel *groupName_label;


- (IBAction)showMovieAction:(id)sender;

@end

@implementation WCSPreviewViewController
- (IBAction)selectGroup:(id)sender {
    
//    [WJHUD showOnView:self.view];
//    [[TIMGroupManager sharedInstance] GetGroupList:^(NSArray * list) {
//        [WJHUD hideFromView:self.view];
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择群组" message:nil preferredStyle:UIAlertControllerStyleAlert];
//        for (TIMGroupInfo * info in list) {
//            if ([info.groupType isEqualToString:@"Public"]||[info.group isEqualToString:OfficialGroupID]) {
//                    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:info.groupName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    self.groupName = info.groupName;
//                    self.groupId = info.groupId;
//                    self.groupName_label.text = info.groupName;
//                }];
//                [alert addAction:alertAction];
//
//            }
//        }
//        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
//        [alert addAction:cancel];
//        [self presentViewController:alert animated:YES completion:NULL];
//    } fail:^(int code, NSString* err) {
//        [WJHUD hideFromView:self.view];
//    }];
}

#pragma mark - life cycle

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];

    if (self.playVC) {
        [self hideContentController:self.playVC];
        self.playVC = nil;
        
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupUI];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - setup
- (void)setupNav{
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    left.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = left;
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirm:)];
    right.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = right;
}
- (void)confirm:(id)sender{
    
    
    if (_shortVideoType == ShortVideoTypeGroupShare &&self.groupId == nil) {
        [WJHUD showText:@"请选择群组" onView:self.view];
        return;
    }
    if (self.textView.text.length == 0) {
        [WJHUD showText:@"请输入内容" onView:self.view];
        return;
    }
    [WJHUD showOnView:self.view];
    NSData *data = [NSData dataWithContentsOfURL:self.videoURL];
    dataDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:data,@"movie.mp4", nil];
    if (dataDictionary.count !=0) {
//        [RequestService uploadFileWithData:dataDictionary withTypeID:@"2" withFileName:nil withMimeType:@"//video/mp4"  result:^(BOOL success, id object) {
//            if (success) {
//                UploadFileModel *model = object;
//                fileURLs = model.data.thumb_id;
//                [self confirm];
//            }else{
//                [WJHUD hideFromView:self.view];
//                [self showNetworkError:object];
//            }
//        }];
    }else{
        [self confirm];
    }
}
- (void)confirm{
    if (fileURLs == nil) {
        fileURLs = @"";
    }
    if (_shortVideoType == ShortVideoTypeGroupShare) {
        [self confirmGroupShare];
    }else{
        [self confirmAsk];
    }
   
}
- (void)confirmAsk{
//    [RequestService quickAskQuestionWithContent:self.textView.text withImages:fileURLs question_type:@"2"  result:^(BOOL success, id object) {
//        [WJHUD hideFromView:self.view];
//        if (success) {
//            [self handleMessageWithBaseJSONModel:object];
//            [WJHUD showText:@"提交成功,专家会尽快给予回复" onView:self.view.window];
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshExpertHomeDate" object:nil];
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }else{
//            [self showNetworkError:object];
//        }
//    }];
}
- (void)confirmGroupShare{
//    [ChatAPIService addGroupShareWithGroupId:_groupId groupContent:self.textView.text groupShare:@"" groupThumb:fileURLs groupType:2 resultBlock:^(BOOL success, id object) {
//        [WJHUD hideFromView:self.view];
//        if (success) {
//            [self handleMessageWithBaseJSONModel:object];
//            [WJHUD showText:@"提交成功" onView:self.view.window];
//            [self sendToConversation:object];
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"GetNewDynamicListData" object:nil];
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }else{
//            [self showNetworkError:object];
//        }
//    }];
}
//-(void)sendToConversation:(ShareInGroupModel *)model{
//    TIMConversation * grp_conversation = [[TIMManager sharedInstance] getConversation:TIM_GROUP receiver:_groupId];
//    
//    
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:model.data.d_id,@"d_id" ,@"2",@"group_type" ,model.data.content,@"content" ,model.data.img_url,@"img_url" ,nil];
//    
//    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
//    
//    // 转换为NSData
//    //    NSString *shareString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    
//    FSGroupShareElem * custom_elem = [[FSGroupShareElem alloc] init];
//    
//    [custom_elem setData:data];
//    
//    TIMMessage * msg = [[TIMMessage alloc] init];
//    
//    [msg addElem:custom_elem];
//    
//    IMAMsg *ima_msg = [IMAMsg msgWith:msg];
//    [ima_msg changeTo:EIMAMsg_Sending needRefresh:NO];
//    
//    [grp_conversation sendMessage:ima_msg.msg succ:^(){
//        NSLog(@"SendMsg Succ");
//    }fail:^(int code, NSString * err) {
//        NSLog(@"SendMsg Failed:%d->%@", code, err);
//    }];
//}

- (void)cancel:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)setupUI
{
    if (_shortVideoType == ShortVideoTypeGroupShare) {
        self.navigationItem.title = @"视频推荐";
        self.selectGroup_view.hidden = NO;
    }else{
         self.navigationItem.title = @"视频咨询";
    }
    if (![_groupId isEqualToString:@""]) {
        self.groupName_label.text = _groupName;
    }
    self.textView.fontOfPlaceHolder = [UIFont systemFontOfSize:17];
    self.textView.placeHolder = @"请输入详细内容";
    _previewButton.userInteractionEnabled = NO;
    //1.生成文件名
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS";
    NSString *name = [df stringFromDate:[NSDate date]];
 //   NSString *gifName = [name stringByAppendingPathExtension:@".gif"];
    NSString *videoName = [name stringByAppendingPathExtension:@".mp4"];
    
    //2.拷贝视频
    [self copyVideoWithMovieName:videoName];
    _previewButton.userInteractionEnabled = YES;

    //3.生成gif
    _preImageView.contentMode = UIViewContentModeScaleAspectFill;
    _preImageView.layer.masksToBounds = YES;
    _preImageView.image = self.movieInfo[WKRecorderFirstFrame];
 //   [self generateAndShowGifWithName:gifName];

}

- (NSString *)generateMoviePathWithFileName:(NSString *)name
{
    NSString *documetPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *moviePath = [documetPath stringByAppendingPathComponent:name];
    
    return moviePath;
}

- (void)copyVideoWithMovieName:(NSString *)movieName
{
    //1.生成视屏URL
    NSMutableString *videoName = [movieName mutableCopy];
    NSURL *videoURL = _movieInfo[WKRecorderMovieURL];
    
    [videoName stringByAppendingPathExtension:@".mp4"];
    
    [videoName replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, videoName.length)];
    
    NSString *videoPath = [self generateMoviePathWithFileName:videoName];
    NSURL *newVideoURL = [NSURL fileURLWithPath:videoPath];
    NSError *error = nil;
    
    [[NSFileManager defaultManager] copyItemAtURL:videoURL toURL:newVideoURL error:&error];
    
    
    if (error) {
        
        NSLog(@"%@", [error localizedDescription]);
        
    }else{
        self.videoURL = newVideoURL;
    }

}

- (void)generateAndShowGifWithName:(NSString *)gifName
{
    NSString *gifPath = [self generateMoviePathWithFileName:gifName];
    NSURL *newVideoURL = [NSURL fileURLWithPath:gifPath];

    WKVideoConverter *converter = [[WKVideoConverter alloc] init];
    
    
    [converter convertVideoToGifImageWithURL:self.videoURL destinationUrl:newVideoURL finishBlock:^{//播放gif
       // _previewButton.userInteractionEnabled = YES;
        _preImageView.gifPath = gifPath;
        [_preImageView startGIF];
    }];
    
    _converter = converter;
}

- (IBAction)showMovieAction:(id)sender {
    WCSPlayMovieController *playVC = [[WCSPlayMovieController alloc] init];
    playVC.movieURL = self.videoURL;
    
    [self displayChildController:playVC];
    
    _playVC = playVC;
}

#pragma mark - displayChildController
- (void) displayChildController: (UIViewController*) child {
    self.navigationController.navigationBarHidden = YES;
    [self addChildViewController:child];
    [self.view addSubview:child.view];
    child.view.frame = self.view.bounds;
    [child didMoveToParentViewController:self];
}

- (void) hideContentController: (UIViewController*) child {
    self.navigationController.navigationBarHidden = NO;

    [child willMoveToParentViewController:nil];
    [child.view removeFromSuperview];
    [child removeFromParentViewController];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hideContentController:self.playVC];
    self.playVC = nil;
}


@end
