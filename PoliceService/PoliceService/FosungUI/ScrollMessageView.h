//
//  ScrollMessageView.h
//  WoJK
//
//  Created by Megatron on 16/5/16.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScrollMessageView;
@protocol ScrollMessageViewDelegate <NSObject>

- (void)scrollMessageView:(ScrollMessageView*)messageView clicked:(BOOL)click;

@end

@interface ScrollMessageView : UIView

@property(nonatomic, strong) UIView *leftView;
//设置了leftView messageTypeName 和 messageTypeImage 就不必设置
@property(nonatomic, copy) NSString *messageTypeName;
@property(nonatomic, strong)UIImage *messageTypeImage;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, assign) BOOL verticalScroll; //default YES;
@property(nonatomic, assign) id <ScrollMessageViewDelegate> delegate;
- (void)startTimer;
@end
