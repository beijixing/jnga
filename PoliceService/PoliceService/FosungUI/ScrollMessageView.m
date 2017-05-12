//
//  ScrollMessageView.m
//  WoJK
//
//  Created by Megatron on 16/5/16.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "ScrollMessageView.h"
#import "UIView+Additions.h"
@interface ScrollMessageView()
{
    UIScrollView *_scrollView;
    dispatch_source_t _timer;
    UIView *_leftView;
}
@property(nonatomic, strong) UIImageView *hornImageView;
@property(nonatomic, strong) UILabel *messageTypeLabel;
@property(nonatomic, strong) UILabel *contentLabel;
@property(nonatomic, strong) UITextView *contentTextView;
@property(nonatomic, strong) UILabel *contentCopyLabel;
@end
@implementation ScrollMessageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.verticalScroll = YES;
        [self addSubview:self.leftView];
        [self addSubview:self.contentTextView];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureEvent:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)gestureEvent:(UITapGestureRecognizer*)gesture {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollMessageView:clicked:)]) {
        [self.delegate scrollMessageView:self clicked:YES];
    }
}

- (void)layoutSubviews {
    float offsetY = ([UIScreen mainScreen].bounds.size.width > 320.1) ? 8 : 4;
    if (self.leftView.frame.size.width < 50) {
        self.leftView.frame = CGRectMake(0, 0, 50, self.size.height);
    }
    
    if (_contentTextView) {
        CGFloat maxPosX = CGRectGetMaxX(self.leftView.frame);
        _contentTextView.frame = CGRectMake(maxPosX+5, offsetY, self.size.width-maxPosX-10, self.size.height-2*offsetY);
        
        if ([UIScreen mainScreen].bounds.size.width > 320.1) {
            _contentTextView.contentOffset= CGPointMake(0, 10);
        }else {
            _contentTextView.contentOffset= CGPointMake(0, 10);
        }
    }
    
    if (_contentLabel) {
        CGFloat maxPosX = CGRectGetMaxX(self.leftView.frame);
        CGRect frame = self.contentLabel.frame;
        self.contentLabel.frame = CGRectMake(maxPosX+8, offsetY, frame.size.width, self.size.height-2*offsetY);
        self.contentCopyLabel.frame = CGRectMake(self.size.width, offsetY, frame.size.width, self.size.height-2*offsetY);
    }
}


- (CGSize)labelheight:(UILabel *)detlabel limitedWidth:(CGFloat)width {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14.0],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    
    CGSize size = CGSizeMake(width , CGFLOAT_MAX);
    CGSize contentactually = [detlabel.text boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributes context:nil].size;
    return contentactually;
}

-(void)setVerticalScroll:(BOOL)verticalScroll {
    _verticalScroll = verticalScroll;
    if (!_verticalScroll) {
        //水平滚动
        (self.content == nil) ? 0 : (self.contentLabel.text = self.content);
        [self insertSubview:self.contentLabel atIndex:0];
        [self insertSubview:self.contentCopyLabel atIndex:0];
        [self.contentTextView removeFromSuperview];
        self.contentTextView = nil;
    }
}

-(void)setLeftView:(UIView *)leftView {
    if (_leftView != leftView) {
        [_leftView removeFromSuperview];
        _leftView = leftView;
        [self addSubview:_leftView];
    }
}

-(UIView *)leftView {
    if (_leftView) {
        return _leftView;
    }
    _leftView = [[UIView alloc] init];
    _leftView.backgroundColor = [UIColor whiteColor];
    [_leftView addSubview:self.messageTypeLabel];
    [_leftView addSubview:self.hornImageView];
    return _leftView;
}


-(void)setMessageTypeImage:(UIImage *)messageTypeImage {
    if (_messageTypeImage != messageTypeImage) {
        _messageTypeImage = messageTypeImage;
        self.hornImageView.image = _messageTypeImage;
    }
}

- (UIImageView *)hornImageView {
    if (_hornImageView) {
        return _hornImageView;
    }

    _hornImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 20, self.frame.size.height-10)];
    _hornImageView.image = [UIImage imageNamed:@"horn"];
    _hornImageView.backgroundColor = [UIColor whiteColor];
//    _hornImageView.hidden = YES;
    return _hornImageView;
}

- (UILabel *)messageTypeLabel {
    if (_messageTypeLabel) {
        return _messageTypeLabel;
    }
    _messageTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 40, self.frame.size.height-10)];
    _messageTypeLabel.font =[UIFont italicSystemFontOfSize:12.0];
    _messageTypeLabel.textColor = [UIColor redColor];
    _messageTypeLabel.text = @"升级公告";
    _messageTypeLabel.numberOfLines = 2;
    _messageTypeLabel.backgroundColor = [UIColor whiteColor];
    return _messageTypeLabel;
}
- (UILabel *)contentCopyLabel {
    if (_contentCopyLabel) {
        return _contentCopyLabel;
    }
    
    _contentCopyLabel = [[UILabel alloc] init];
    _contentCopyLabel.font = self.contentLabel.font;
    _contentCopyLabel.numberOfLines = self.contentLabel.numberOfLines;
    _contentCopyLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _contentCopyLabel.textColor = self.contentLabel.textColor;
    _contentCopyLabel.text = self.contentLabel.text;
    _contentCopyLabel.hidden = YES;
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:_contentCopyLabel.text];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:0];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [_contentCopyLabel.text length])];
    [_contentCopyLabel setAttributedText:attributedString1];
    [_contentCopyLabel sizeToFit];
    return _contentCopyLabel;
}
- (UILabel *)contentLabel {
    if (_contentLabel) {
        return _contentLabel;
    }
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = [UIFont fontWithName:@"Arial" size:14.0];
    _contentLabel.numberOfLines = 1;
    _contentLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    _contentLabel.text = @"敬请谅解!";
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:_contentLabel.text];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:0];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [_contentLabel.text length])];
    [_contentLabel setAttributedText:attributedString1];
    [_contentLabel sizeToFit];
    return _contentLabel;
}

- (UITextView *)contentTextView {
    if (_contentTextView) {
        return _contentTextView;
    }
    
    _contentTextView = [[UITextView alloc] init];
    _contentTextView.editable = NO;
    _contentTextView.userInteractionEnabled = NO;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    _contentTextView.attributedText = [[NSAttributedString alloc] initWithString:@"今晚20：00App升级，给您带来的不便，敬请谅解！哈哈 收到货发顺丰该多好过圣诞" attributes:attributes];
    
    return _contentTextView;
}

- (void)setMessageTypeName:(NSString *)messageTypeName {
    if (_messageTypeName == messageTypeName) {
        return;
    }
    _messageTypeName = messageTypeName;
    self.messageTypeLabel.text = _messageTypeName;
}

- (void)setContent:(NSString *)content {
    if (_content == content) {
        return;
    }
    _content = content;
    if (self.verticalScroll) {
        self.contentTextView.text = _content;
    }else {
        self.contentLabel.text = _content;
        [self.contentLabel sizeToFit];
        self.contentCopyLabel.text = _content;
        [self.contentCopyLabel sizeToFit];
    }
    
}

- (void)startTimer {
    
    if (_timer) {
        return;
    }
    
    if(!self.verticalScroll){
        //水平滚动
        if (self.contentLabel.frame.size.width < self.frame.size.width - CGRectGetMaxX(self.messageTypeLabel.frame)) {
            //单行文字，不足一屏的宽度不滚动。
            return;
        }
        self.contentCopyLabel.hidden = NO;
        CGRect frame = self.contentLabel.frame;
        self.contentCopyLabel.frame = CGRectMake(CGRectGetMaxX(self.contentLabel.frame)+10, frame.origin.y, frame.size.width, frame.size.height);
    }else {
        //竖直滚动
        //单行文字，不足一行不滚动。
        if (self.contentTextView.contentSize.height <= self.contentTextView.size.height) {
            return;
        }
    }

//  _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    
    NSTimeInterval period = 0.1; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    typeof(self) __weak seakself = self;
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [seakself timerAction];
        });
    });
    dispatch_resume(_timer);
}

- (void)timerAction {
    
    if (self.verticalScroll) {
        CGPoint newOffset = _contentTextView.contentOffset;
        newOffset.y = newOffset.y+1;
        if (newOffset.y > _contentTextView.contentSize.height) {
            newOffset.y = -_contentTextView.frame.size.height;
        }
        _contentTextView.contentOffset = newOffset;
    }else {
        CGFloat minPosXA = CGRectGetMinX(self.contentLabel.frame);
        CGFloat minPosXB = CGRectGetMinX(self.contentCopyLabel.frame);
        CGRect frameA = self.contentLabel.frame;
        CGRect frameB = self.contentCopyLabel.frame;
        
        if (minPosXA < minPosXB && minPosXB < 0) {
            //把 self.contentLabel 设置在self.contentCopyLabel的右边
            self.contentLabel.frame = CGRectMake(CGRectGetMaxX(frameB)+10, frameA.origin.y, frameA.size.width, frameA.size.height);
        }else if(minPosXA > minPosXB && minPosXA <0){
             self.contentCopyLabel.frame = CGRectMake(CGRectGetMaxX(frameA)+10, frameA.origin.y, frameA.size.width, frameA.size.height);
        }else {
            self.contentLabel.frame = CGRectMake(frameA.origin.x-1, frameA.origin.y, frameA.size.width, frameA.size.height);
            self.contentCopyLabel.frame = CGRectMake(frameB.origin.x-1, frameA.origin.y, frameA.size.width, frameA.size.height);
        }
    }
}
@end
