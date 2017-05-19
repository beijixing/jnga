//
//  BaseTableViewController.m
//  PoliceService
//
//  Created by fosung on 2017/5/17.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "BaseTableViewController.h"
#import "UIFactory.h"
@interface BaseTableViewController ()

@property (nonatomic, strong) UIActivityIndicatorView * indicator;
@property (nonatomic, copy) LeftBarButtonItemBlock leftBarButtonBlock;
@property (nonatomic, copy) RightBarButtonItemBlock rightBarButtonBlock;
@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setupActivityIndicatorView{
    self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicator.translatesAutoresizingMaskIntoConstraints = NO;
    self.indicator.hidesWhenStopped = YES;
    [self.view addSubview:self.indicator];
    
    NSLayoutConstraint * centerX = [NSLayoutConstraint constraintWithItem:self.indicator.superview attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.indicator attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint * centerY = [NSLayoutConstraint constraintWithItem:self.indicator.superview attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.indicator attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    
    [self.view addConstraints:@[centerX,centerY]];
    
    [self.indicator startAnimating];
}

- (void)stopActivityIndicatorView{
    [self.indicator stopAnimating];
}

#pragma mark - 导航栏左(后退)按钮
-(void)setupLeftBackButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.exclusiveTouch = YES;
    button.frame = CGRectMake(0, 0, 15, 25);
    [button addTarget:self action:@selector(leftBackButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    //    [button sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}


#pragma mark - 左(后退)按钮点击 默认行为 可以在子类中重写此方法实现自定义后退行为
-(void)leftBackButtonTouchUpInside:(UIButton *)sender{
    if ([self isPresentedViewController]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)isPresentedViewController{
    
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count > 1) {
            return NO;
        }
        return self.navigationController.presentingViewController != nil;
    }else{
        return self.presentingViewController != nil;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)hideNavigationBarDividedLine {
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

- (void)setupPotraitDisplayView {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (void)setupLandScapeDisplayView {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationLandscapeRight;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    //    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    //    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (void)setLeftNavigationBarButtonItemWithImage:(NSString *)imageName andAction:(LeftBarButtonItemBlock)action {
    
    UIButton *leftBtn = [UIFactory createButtonWith:CGRectMake(0, 0, 30, 30) selector:@selector(leftButtonItemClick) target:self normalImage:[UIImage imageNamed:imageName] selectedImage:[UIImage imageNamed:imageName]];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    negativeSpacer.width = -10;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, leftBarButtonItem, nil];
    
    self.leftBarButtonBlock = action;
}

- (void)leftButtonItemClick {
    if (self.leftBarButtonBlock) {
        self.leftBarButtonBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setRightNavigationBarButtonItemWithImage:(NSString *)imageName andAction:(RightBarButtonItemBlock)action {
    
    UIButton *rightBtn = [UIFactory createButtonWith:CGRectMake(0, 0, 24, 24) selector:@selector(rightButtonItemClick) target:self normalImage:[UIImage imageNamed:imageName] selectedImage:[UIImage imageNamed:imageName]];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.rightBarButtonBlock = action;
}

- (void)setRightNavigationBarButtonItemWithTitle:(NSString *)title andAction:(RightBarButtonItemBlock)action {
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonItemClick)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.rightBarButtonBlock = action;
}
- (void)setRightNavigationBarButtonItemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor andAction:(RightBarButtonItemBlock)action {
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonItemClick)];
    rightBarButtonItem.tintColor = titleColor;
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.rightBarButtonBlock = action;
}

- (void)setRightNavigationBarButtonItemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font andAction:(RightBarButtonItemBlock)action {
    UIButton *btn = [UIFactory createButtonWith:CGRectMake(0, 0, 40, 40)  selector:@selector(rightButtonItemClick) target:self titleColor:titleColor title:title];
    btn.titleLabel.font = font;
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    
    /**
     width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和  边界间距为5pix，所以width设为-5时，间距正好调整为0；width为正数 时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = -10;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, rightBarButtonItem, nil];
    //    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.rightBarButtonBlock = action;
}

- (void)rightButtonItemClick {
    if (self.rightBarButtonBlock) {
        self.rightBarButtonBlock();
    }
}

- (BOOL)shouldAutorotate {
    return NO;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
