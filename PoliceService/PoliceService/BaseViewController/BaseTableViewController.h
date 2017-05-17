//
//  BaseTableViewController.h
//  PoliceService
//
//  Created by fosung on 2017/5/17.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^LeftBarButtonItemBlock)(void);
typedef void (^RightBarButtonItemBlock)(void);
@interface BaseTableViewController : UITableViewController
@property(nonatomic) float scaleX;

-(void)setupLeftBackButton;
-(void)leftBackButtonTouchUpInside:(UIButton *)sender;

- (void)setupActivityIndicatorView;
- (void)stopActivityIndicatorView;

- (void)hideNavigationBarDividedLine;

- (void)setupPotraitDisplayView;
- (void)setupLandScapeDisplayView;

- (void)setLeftNavigationBarButtonItemWithImage:(NSString *)imageName andAction:(LeftBarButtonItemBlock)action;

- (void)setRightNavigationBarButtonItemWithImage:(NSString *)imageName andAction:(RightBarButtonItemBlock)action;
- (void)setRightNavigationBarButtonItemWithTitle:(NSString *)title andAction:(RightBarButtonItemBlock)action;
- (void)setRightNavigationBarButtonItemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor andAction:(RightBarButtonItemBlock)action;
- (void)setRightNavigationBarButtonItemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font andAction:(RightBarButtonItemBlock)action;
@end
