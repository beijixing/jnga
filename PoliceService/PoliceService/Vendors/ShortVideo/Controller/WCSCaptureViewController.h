//
//  WCSCaptureViewController.h
//  WeChatSightDemo
//
//  Created by 吴珂 on 16/8/19.
//  Copyright © 2016年 吴珂. All rights reserved.
//

#import "BaseViewController.h"
#import "WCSPreviewViewController.h"
#define MaxDuration 40.f
@interface WCSCaptureViewController : BaseViewController
@property (nonatomic ,assign) ShortVideoType shortVideoType;
@property (nonatomic, strong) NSString *groupId;
@property (nonatomic, strong) NSString *groupName;
@end
