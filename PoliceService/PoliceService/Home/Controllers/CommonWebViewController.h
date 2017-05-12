//
//  CommonWebViewController.h
//  PoliceService
//
//  Created by horse on 2017/4/8.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "BaseViewController.h"
@interface CommonWebViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSString *urlString;
@end
