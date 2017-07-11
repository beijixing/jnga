//
//  FSEdgeInsetButton.h
//  PoliceService
//
//  Created by WenJie on 2017/7/4.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FSButtonCompositionStyle) {
    FSButtonCompositionStyleVerticalImageTitle = 1, //垂直图片在上
    FSButtonCompositionStyleVerticalTitleImage, //垂直标题在上
    FSButtonCompositionStyleHorizontalImageTitle,//水平图片在左
    FSButtonCompositionStyleHorizontalTitleImage,//水平标题在左
};


@interface FSEdgeInsetButton : UIButton

/*
 布局样式
 **/
@property (nonatomic) FSButtonCompositionStyle compositionStyle;

/*
 图片与title的间距(布局为垂直则为垂直间距，布局为水平则为水平间距)
 **/
@property (nonatomic) CGFloat imageTitleSpace;

/*
 控件与button的水平边界的距离
 **/
@property (nonatomic) CGFloat horizontalEdgeSpace;

@end
