//
//  WCSPreviewViewController.h
//  WeChatSightDemo
//
//  Created by 吴珂 on 16/8/26.
//  Copyright © 2016年 吴珂. All rights reserved.
//

#import "BaseViewController.h"
#import "WJTextView.h"

typedef NS_ENUM(NSUInteger, ShortVideoType) {
    ShortVideoTypeAsk,
    ShortVideoTypeGroupShare,
};

@interface WCSPreviewViewController : BaseViewController

@property (nonatomic, assign) ShortVideoType shortVideoType;
@property (nonatomic, copy) NSDictionary *movieInfo;
@property (weak, nonatomic) IBOutlet WJTextView *textView;
@property (nonatomic, strong) NSString *groupId;
@property (nonatomic, strong) NSString *groupName;

@end
