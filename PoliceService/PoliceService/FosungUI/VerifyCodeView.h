//
//  VerifyCodeView.h
//  PoliceService
//
//  Created by horse on 2017/2/24.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerifyCodeView : UIView
@property (nonatomic, strong) NSArray *changeArray;
@property (nonatomic, strong) NSMutableString *changeString;
@property (nonatomic, strong) UILabel *codeLabel;
-(void)changeCode;
@end
