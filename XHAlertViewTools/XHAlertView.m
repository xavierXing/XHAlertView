//
//  XHAlertView.m
//  XHAlertViewTools
//
//  Created by xinghao on 2016/12/22.
//  Copyright © 2016年 xinghao. All rights reserved.
//


#import "XHAlertView.h"

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height
#define ALERT_H_SCALE 124/667
#define ALERT_W_SCALE 270/375
#define ALERT_BTN_H_SCALE 44/124
#define VERTICALLINE_H SCREEN_H * ALERT_H_SCALE * ALERT_BTN_H_SCALE

@interface XHAlertView()<UITextFieldDelegate> {
    XHAlertViewStyle _style;/** alert样式 */
    NSString * inputText;
    NSString * user;
    NSString * password;
}
#pragma mark -控件
@property (nonatomic, strong) UIView * content;/**背景*/
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * messageLabel;
@property (nonatomic, strong) UIButton * sureBtn;
@property (nonatomic, strong) UIButton * cancleBtn;
@property (nonatomic, strong) UITextField * textInputField;
@property (nonatomic, strong) UITextField * userNameField;
@property (nonatomic, strong) UITextField * passwordInputField;
@property(nonatomic, strong) UIWebView * gifView;

#pragma mark -UI美化
@property (nonatomic, strong) UIView * transverseLine;/**横线*/
@property (nonatomic, strong) UIView * verticalLine;/**竖线*/

#pragma mark -资源
@property(nonatomic, copy)NSString * message;
@property(nonatomic, copy)NSString * title;

@end

@implementation XHAlertView

static XHAlertView *alertObj = nil;
+ (XHAlertView *)shareInstace {
    /**单例*/
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alertObj = [[XHAlertView alloc] init];
        [alertObj watchKeyBoardAppearAndDisappear];
    });
    return alertObj;
}

+ (nonnull XHAlertView *)alertWithMessage:(nonnull NSString *)message
                        WithTitle:(nullable NSString *)title
               WithAlertViewStyle:(XHAlertViewStyle)style {
    /** 创建实例*/
     XHAlertView *alert_xh = [XHAlertView shareInstace];
    alert_xh->_style = style;
    alert_xh.frame = [UIScreen mainScreen].bounds;
    alert_xh.backgroundColor = [UIColor blackColor];
    alert_xh.alpha = 0;
    /**获取window*/
    UIWindow * interface = [UIApplication sharedApplication].keyWindow;
    interface.windowLevel = UIWindowLevelAlert;
    [interface addSubview:alert_xh];
    /**资源赋值*/
    alert_xh.message = message;
    alert_xh.title = title;
    
    [interface addSubview:alert_xh.content];
    switch (style) {
        case XHAlertViewStyle_Normal:
            [alert_xh.content addSubview:alert_xh.messageLabel];
            break;
        case XHAlertViewStyle_TextFiled:
            [alert_xh.content addSubview:alert_xh.textInputField];
            break;
        case XHAlertViewStyle_PassWord:
            [alert_xh.content addSubview:alert_xh.userNameField];
            [alert_xh.content addSubview:alert_xh.passwordInputField];
            break;
        case XHAlertViewStyle_GifView:
            [alert_xh.content addSubview:alert_xh.gifView];
            break;
        default:
            NSLog(@"没有选取属性!");
            break;
    }
    [alert_xh.content addSubview:alert_xh.titleLabel];
    [alert_xh.content addSubview:alert_xh.sureBtn];
    [alert_xh.content addSubview:alert_xh.cancleBtn];
    [alert_xh.content addSubview:alert_xh.transverseLine];
    [alert_xh.content addSubview:alert_xh.verticalLine];
    [alert_xh layoutViews:style];
    return alert_xh;
}
#pragma mark -检测键盘出现
- (void)watchKeyBoardAppearAndDisappear {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWasShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyBoardWasShow:(NSNotification *)keyboard {
    CGRect keyboard_Rect = [[keyboard.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat alertbottm_y = _content.frame.size.height + _content.frame.origin.y;
    CGFloat keyboard_y = SCREEN_H - keyboard_Rect.size.height;
    if (alertbottm_y > keyboard_y) {
        CGFloat greaterFloat = alertbottm_y - keyboard_y;
        NSLog(@"keyboard frame greater than alert frame");
        _content.frame = CGRectMake(_content.frame.origin.x, _content.frame.origin.y - greaterFloat, _content.frame.size.width, _content.frame.size.height);
    }
    NSLog(@"keyboard will show : %f",keyboard_Rect.size.height);
}

- (void)keyBoardWasHidden:(NSNotification *)keyboard {
    CGRect keyboard_Rect = [[keyboard.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat alertbottm_y = _content.frame.size.height + _content.frame.origin.y;
    CGFloat keyboard_y = SCREEN_H - keyboard_Rect.size.height;
    if (alertbottm_y > keyboard_y) {
        CGFloat greaterFloat = alertbottm_y - keyboard_y;
        NSLog(@"keyboard frame greater than alert frame");
        _content.frame = CGRectMake(_content.frame.origin.x, _content.frame.origin.y + greaterFloat, _content.frame.size.width, _content.frame.size.height);
    }
    NSLog(@"keyboard will hidden : %f",keyboard_Rect.size.height);
}

#pragma mark -约束
- (void)layoutViews:(XHAlertViewStyle)style {
    
    
    switch (style) {
        case XHAlertViewStyle_Normal: {
            /**_content 约束: */
            _content.translatesAutoresizingMaskIntoConstraints = NO;
            NSLayoutConstraint * contraintCenterX = [NSLayoutConstraint constraintWithItem:_content attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:[UIApplication sharedApplication].keyWindow attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
            NSLayoutConstraint * contraintCenterY = [NSLayoutConstraint constraintWithItem:_content attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:[UIApplication sharedApplication].keyWindow attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
            NSLayoutConstraint * contraintWidth = [NSLayoutConstraint constraintWithItem:_content attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:SCREEN_W * ALERT_W_SCALE];
            NSLayoutConstraint * contraintHeight = [NSLayoutConstraint constraintWithItem:_content attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:SCREEN_H * ALERT_H_SCALE];
            NSArray * contrants = @[contraintCenterX,contraintCenterY,contraintWidth,contraintHeight];
            [[UIApplication sharedApplication].keyWindow addConstraints:contrants];
        }
            break;
        case XHAlertViewStyle_TextFiled: {
            /**_content 约束: */
            _content.translatesAutoresizingMaskIntoConstraints = NO;
            NSLayoutConstraint * contraintCenterX = [NSLayoutConstraint constraintWithItem:_content attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:[UIApplication sharedApplication].keyWindow attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
            NSLayoutConstraint * contraintCenterY = [NSLayoutConstraint constraintWithItem:_content attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:[UIApplication sharedApplication].keyWindow attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
            NSLayoutConstraint * contraintWidth = [NSLayoutConstraint constraintWithItem:_content attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:SCREEN_W * ALERT_W_SCALE];
            NSLayoutConstraint * contraintHeight = [NSLayoutConstraint constraintWithItem:_content attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:SCREEN_H * ALERT_H_SCALE];
            NSArray * contrants = @[contraintCenterX,contraintCenterY,contraintWidth,contraintHeight];
            [[UIApplication sharedApplication].keyWindow addConstraints:contrants];
        }
            break;
        case XHAlertViewStyle_PassWord: {
            /**_content 约束: */
            _content.translatesAutoresizingMaskIntoConstraints = NO;
            NSLayoutConstraint * contraintCenterX = [NSLayoutConstraint constraintWithItem:_content attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:[UIApplication sharedApplication].keyWindow attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
            NSLayoutConstraint * contraintCenterY = [NSLayoutConstraint constraintWithItem:_content attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:[UIApplication sharedApplication].keyWindow attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
            NSLayoutConstraint * contraintWidth = [NSLayoutConstraint constraintWithItem:_content attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:SCREEN_W * ALERT_W_SCALE];
            NSLayoutConstraint * contraintHeight = [NSLayoutConstraint constraintWithItem:_content attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:SCREEN_H * ALERT_H_SCALE + 50];
            NSArray * contrants = @[contraintCenterX,contraintCenterY,contraintWidth,contraintHeight];
            [[UIApplication sharedApplication].keyWindow addConstraints:contrants];
            
        }
            break;
        case XHAlertViewStyle_GifView: {
            /**_content 约束: */
            _content.translatesAutoresizingMaskIntoConstraints = NO;
            NSLayoutConstraint * contraintCenterX = [NSLayoutConstraint constraintWithItem:_content attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:[UIApplication sharedApplication].keyWindow attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
            NSLayoutConstraint * contraintCenterY = [NSLayoutConstraint constraintWithItem:_content attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:[UIApplication sharedApplication].keyWindow attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
            NSLayoutConstraint * contraintWidth = [NSLayoutConstraint constraintWithItem:_content attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:SCREEN_W * ALERT_W_SCALE];
            NSLayoutConstraint * contraintHeight = [NSLayoutConstraint constraintWithItem:_content attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:SCREEN_H * ALERT_H_SCALE + 100];
            NSArray * contrants = @[contraintCenterX,contraintCenterY,contraintWidth,contraintHeight];
            [[UIApplication sharedApplication].keyWindow addConstraints:contrants];
        }
            break;
        default:
            break;
    }
    
    
    /**_titleLabel 约束: */
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint * titleLabelCenterX = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_content attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint * titleLabelTop = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:_content attribute:NSLayoutAttributeTopMargin multiplier:1 constant:18];
    NSLayoutConstraint * titleLabelHeight = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:20];
    NSArray * titleLabelContraints = @[titleLabelCenterX,titleLabelTop,titleLabelHeight];
    [_content addConstraints:titleLabelContraints];
    
    if (style == XHAlertViewStyle_Normal) { 
        /**_messageLabel 约束: */
        _messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint * messageLabelCenterX = [NSLayoutConstraint constraintWithItem:_messageLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_content attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        NSLayoutConstraint * messageLabelTop = [NSLayoutConstraint constraintWithItem:_messageLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_titleLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:1];
        NSLayoutConstraint * messageLabelHeight = [NSLayoutConstraint constraintWithItem:_messageLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:20];
        NSArray * messageLabelConstraints = @[messageLabelCenterX,messageLabelTop,messageLabelHeight];
        [_content addConstraints:messageLabelConstraints];
    }
    
    /**_sureBtn 约束: */
    _sureBtn.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint * sureBtnRight = [NSLayoutConstraint constraintWithItem:_sureBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_content attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint * sureBtnBottom = [NSLayoutConstraint constraintWithItem:_sureBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_content attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint * sureBtnWidth = [NSLayoutConstraint constraintWithItem:_sureBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:SCREEN_W * ALERT_W_SCALE / 2];
    NSLayoutConstraint * sureBtnHeight = [NSLayoutConstraint constraintWithItem:_sureBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:SCREEN_H * ALERT_H_SCALE * ALERT_BTN_H_SCALE];
    NSArray * sureBtnConstraints = @[sureBtnRight,sureBtnBottom,sureBtnWidth,sureBtnHeight];
    [_content addConstraints:sureBtnConstraints];
    
    /**_cancleBtn 约束: */
    _cancleBtn.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint * cancleBtnLeft = [NSLayoutConstraint constraintWithItem:_cancleBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_content attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint * cancleBtnBottom = [NSLayoutConstraint constraintWithItem:_cancleBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_content attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint * cancleBtnWidth = [NSLayoutConstraint constraintWithItem:_cancleBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:SCREEN_W * ALERT_W_SCALE / 2];
    NSLayoutConstraint * cancleBtnHeight = [NSLayoutConstraint constraintWithItem:_cancleBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:SCREEN_H * ALERT_H_SCALE * ALERT_BTN_H_SCALE];
    NSArray * cancleBtnConstraints = @[cancleBtnLeft,cancleBtnBottom,cancleBtnWidth,cancleBtnHeight];
    [_content addConstraints:cancleBtnConstraints];
    
    /**_transverseLine 约束: */
    _transverseLine.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint * transverseLineBottom = [NSLayoutConstraint constraintWithItem:_transverseLine attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_sureBtn attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint * transverseLineRight = [NSLayoutConstraint constraintWithItem:_transverseLine attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_content attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint * transverseLineLeft = [NSLayoutConstraint constraintWithItem:_transverseLine attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_content attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint * transverseLineHeight = [NSLayoutConstraint constraintWithItem:_transverseLine attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0.5];
    NSArray * transverseLineConstraints = @[transverseLineBottom,transverseLineRight,transverseLineLeft,transverseLineHeight];
    [_content addConstraints:transverseLineConstraints];
    
    /**_verticalLine 约束: */
    _verticalLine.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint * verticalLineBottom = [NSLayoutConstraint constraintWithItem:_verticalLine attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_content attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint * verticalLineCenterX = [NSLayoutConstraint constraintWithItem:_verticalLine attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_content attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint * verticalLineHeight = [NSLayoutConstraint constraintWithItem:_verticalLine attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:VERTICALLINE_H];
    NSLayoutConstraint * verticalLineWidth = [NSLayoutConstraint constraintWithItem:_verticalLine attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0.5];
    NSArray * verticalLineConstraints = @[verticalLineWidth,verticalLineBottom,verticalLineHeight,verticalLineCenterX];
    [_content addConstraints:verticalLineConstraints];
    
    if (style == XHAlertViewStyle_TextFiled) {
        /** _textInputField */
        _textInputField.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint * textInputFieldCenterX = [NSLayoutConstraint constraintWithItem:_textInputField attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_content attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        NSLayoutConstraint * textInputFieldTop = [NSLayoutConstraint constraintWithItem:_textInputField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_titleLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:5];
        NSLayoutConstraint * textInputFieldWidth = [NSLayoutConstraint constraintWithItem:_textInputField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:SCREEN_W * ALERT_W_SCALE - 50];
        NSLayoutConstraint * textInputFieldHeight = [NSLayoutConstraint constraintWithItem:_textInputField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:25];
        NSArray * textInputFieldContraints = @[textInputFieldCenterX,textInputFieldTop,textInputFieldWidth,textInputFieldHeight];
        [_content addConstraints:textInputFieldContraints];
    }
    
    if (style == XHAlertViewStyle_PassWord) {
        /** serNameField 约束: */
        _userNameField.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint * userNameFieldCenterX = [NSLayoutConstraint constraintWithItem:_userNameField attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_content attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        NSLayoutConstraint * userNameFieldTop = [NSLayoutConstraint constraintWithItem:_userNameField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_titleLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:15];
        NSLayoutConstraint * userNameFieldWidth = [NSLayoutConstraint constraintWithItem:_userNameField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:SCREEN_W * ALERT_W_SCALE - 50];
        NSLayoutConstraint * userNameFieldHeight = [NSLayoutConstraint constraintWithItem:_userNameField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:25];
        NSArray * userNameFieldConstrains = @[userNameFieldCenterX,userNameFieldTop,userNameFieldWidth,userNameFieldHeight];
        [_content addConstraints:userNameFieldConstrains];
        
        /** passwordInputField 约束: */
        _passwordInputField.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint * passwordInputFieldCenterX = [NSLayoutConstraint constraintWithItem:_passwordInputField attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_userNameField attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        NSLayoutConstraint * passwordInputFieldTop = [NSLayoutConstraint constraintWithItem:_passwordInputField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_userNameField attribute:NSLayoutAttributeBottom multiplier:1 constant:5];
        NSLayoutConstraint * passwordInputFieldWidth = [NSLayoutConstraint constraintWithItem:_passwordInputField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:SCREEN_W * ALERT_W_SCALE - 50];
        NSLayoutConstraint * passwordInputFieldHeight = [NSLayoutConstraint constraintWithItem:_passwordInputField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:25];
        NSArray * passwordInputFieldConstraints = @[passwordInputFieldCenterX,passwordInputFieldTop,passwordInputFieldWidth,passwordInputFieldHeight];
        [_content addConstraints:passwordInputFieldConstraints];
    }
    
    if (style == XHAlertViewStyle_GifView) {
        /** gifView 约束: */
        _gifView.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint * gifViewCenterX = [NSLayoutConstraint constraintWithItem:_gifView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_content attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        NSLayoutConstraint * gifViewTop = [NSLayoutConstraint constraintWithItem:_gifView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_titleLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:10];
        NSLayoutConstraint * gifViewWidth = [NSLayoutConstraint constraintWithItem:_gifView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:SCREEN_W * ALERT_W_SCALE - 20];
        NSLayoutConstraint * gifViewHeight = [NSLayoutConstraint constraintWithItem:_gifView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:120];
        NSArray * gifViewConstraints = @[gifViewCenterX,gifViewTop,gifViewWidth,gifViewHeight];
        [_content addConstraints:gifViewConstraints];
    }
}

#pragma mark -开始动画
+ (void)showAlert {
    /**开始动画*/
    [UIView animateWithDuration:0.3 animations:^{
        [XHAlertView shareInstace].alpha = 0.7;
        [XHAlertView shareInstace].content.alpha =1;
        /**开始缩放动画*/
        CABasicAnimation * zoomAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        zoomAnimation.duration = 0.3;
        zoomAnimation.repeatCount = 1;
        zoomAnimation.autoreverses = NO;
        zoomAnimation.fromValue = @(1.5);
        zoomAnimation.toValue = @(1);
        [[XHAlertView shareInstace].content.layer addAnimation:zoomAnimation forKey:@"scale-layer"];
    } completion:^(BOOL finished) {

    }];
}
#pragma mark -隐藏动画
+ (void)dismissAlert {
    /**动画消失*/
    [UIView animateWithDuration:0.3 animations:^{
        [XHAlertView shareInstace].alpha = 0;
        [XHAlertView shareInstace].content.alpha =0;
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark -属性
- (UIView *)content {
    if (!_content) {
        _content = [[UIView alloc] init];
        _content.backgroundColor = [UIColor whiteColor];
        _content.alpha = 0;
        _content.layer.cornerRadius = 5;
        _content.clipsToBounds = YES;
    }
    return _content;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = _title;
        _titleLabel.font = [UIFont systemFontOfSize:18.f];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 1;
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}
- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.text = _message;
        _messageLabel.font = [UIFont systemFontOfSize:15.f];
        _messageLabel.textColor = [UIColor blackColor];
        _messageLabel.backgroundColor = [UIColor whiteColor];
        _messageLabel.textAlignment = NSTextAlignmentLeft;
        [_messageLabel sizeToFit];
}
    return _messageLabel;
}
- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.backgroundColor = [UIColor whiteColor];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [_sureBtn addTarget:self action:@selector(clickSureAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
- (UIButton *)cancleBtn {
    if (!_cancleBtn) {
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancleBtn.backgroundColor = [UIColor whiteColor];
        [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancleBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [_cancleBtn addTarget:self action:@selector(clickCancleAction:) forControlEvents:UIControlEventTouchUpInside];
        [_cancleBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
        
    }
    return _cancleBtn;
}
- (UIView *)transverseLine {
    if (!_transverseLine) {
        _transverseLine = [[UIView alloc] init];
        _transverseLine.backgroundColor = [UIColor blackColor];
    }
    return _transverseLine;
}
- (UIView *)verticalLine {
    if (!_verticalLine) {
        _verticalLine = [[UIView alloc] init];
        _verticalLine.backgroundColor = [UIColor blackColor];
    }
    return _verticalLine;
}
- (UITextField *)userNameField {
    if (!_userNameField) {
        _userNameField = [[UITextField alloc] init];
        _userNameField.delegate = self;
        _userNameField.placeholder = @"用户名";
        _userNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userNameField.returnKeyType = UIReturnKeyDone;
        [_userNameField addTarget:self action:@selector(userNameField:) forControlEvents:UIControlEventEditingChanged];
        UIView * aline = [[UIView alloc] initWithFrame:CGRectMake(0, 25, SCREEN_W * ALERT_W_SCALE - 50, 0.5)];
        aline.backgroundColor = [UIColor colorWithRed:144/255.0 green:144/255.0  blue:144/255.0  alpha:0.6];
        [_userNameField addSubview:aline];
    }
    return _userNameField;
}
- (UITextField *)passwordInputField {
    if (!_passwordInputField) {
        _passwordInputField = [[UITextField alloc] init];
        _passwordInputField.delegate = self;
        _passwordInputField.secureTextEntry = YES;
        _passwordInputField.placeholder = @"密码";
        _passwordInputField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordInputField.returnKeyType = UIReturnKeyDone;
        [_passwordInputField addTarget:self action:@selector(passwordInputField:) forControlEvents:UIControlEventEditingChanged];
        UIView * aline = [[UIView alloc] initWithFrame:CGRectMake(0, 25, SCREEN_W * ALERT_W_SCALE - 50, 0.5)];
        aline.backgroundColor = [UIColor colorWithRed:144/255.0 green:144/255.0  blue:144/255.0  alpha:0.6];
        [_passwordInputField addSubview:aline];
    }
    return _passwordInputField;
}
- (UITextField *)textInputField {
    if (!_textInputField) {
        _textInputField = [[UITextField alloc] init];
        _textInputField.delegate = self;
        _textInputField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textInputField.textAlignment = NSTextAlignmentCenter;
        _textInputField.tintColor = [UIColor redColor];
        [_textInputField addTarget:self action:@selector(textInputFieldChange:) forControlEvents:UIControlEventEditingChanged];
        UIView * aline = [[UIView alloc] initWithFrame:CGRectMake(0, 25, SCREEN_W * ALERT_W_SCALE - 50, 0.5)];
        aline.backgroundColor = [UIColor colorWithRed:144/255.0 green:144/255.0  blue:144/255.0  alpha:0.6];
        [_textInputField addSubview:aline];
    }
    return _textInputField;
}
- (UIWebView *)gifView {
    if (!_gifView) {
        _gifView = [[UIWebView alloc] init];
        _gifView.userInteractionEnabled = NO;
    }
    return _gifView;
}
#pragma mark -textfield方法
- (void)userNameField:(UITextField *)sender {
    user = sender.text;
}
- (void)passwordInputField:(UITextField *)sender {
    password = sender.text;
}
- (void)textInputFieldChange:(UITextField *)sender {
    inputText = sender.text;
}
#pragma mark -button方法
- (void)clickSureAction:(id)sender {
    [XHAlertView dismissAlert];
    switch (_style) {
        case XHAlertViewStyle_Normal:
            if (self.xhAlertDelegate != nil &&
                [self.xhAlertDelegate conformsToProtocol:@protocol(XHAlertViewDelegate)] &&
                [self.xhAlertDelegate respondsToSelector:@selector(clickSureBtnAction)] ) {
                [self.xhAlertDelegate clickSureBtnAction];
            }
            break;
        case XHAlertViewStyle_PassWord:
            if (self.xhAlertDelegate != nil &&
                [self.xhAlertDelegate conformsToProtocol:@protocol(XHAlertViewDelegate)] &&
                [self.xhAlertDelegate respondsToSelector:@selector(clickSureBtnActionWithPassWord:WithUserName:)] ) {
                [_userNameField resignFirstResponder];
                [_passwordInputField resignFirstResponder];
                [self.xhAlertDelegate clickSureBtnActionWithPassWord:password WithUserName:user];
            }
            break;
        case XHAlertViewStyle_TextFiled:
            if (self.xhAlertDelegate != nil &&
                [self.xhAlertDelegate conformsToProtocol:@protocol(XHAlertViewDelegate)] &&
                [self.xhAlertDelegate respondsToSelector:@selector(clickSureBtnActionWithInputTextField:)] ) {
                [_textInputField resignFirstResponder];
                [self.xhAlertDelegate clickSureBtnActionWithInputTextField:inputText];
            }
            break;
        case XHAlertViewStyle_GifView:
            if (self.xhAlertDelegate != nil &&
                [self.xhAlertDelegate conformsToProtocol:@protocol(XHAlertViewDelegate)] &&
                [self.xhAlertDelegate respondsToSelector:@selector(clickSureBtnAction)] ) {
                [self.xhAlertDelegate clickSureBtnAction];
            }
            break;
        default:
            break;
    }
}

- (void)clickCancleAction:(id)sender {
    [XHAlertView dismissAlert];
    if (self.xhAlertDelegate != nil &&
        [self.xhAlertDelegate conformsToProtocol:@protocol(XHAlertViewDelegate)] &&
        [self.xhAlertDelegate respondsToSelector:@selector(clickCancleBtnAction)] ) {
        switch (_style) {
            case XHAlertViewStyle_Normal:
                
                break;
            case XHAlertViewStyle_TextFiled:
                [_textInputField resignFirstResponder];
                break;
            case XHAlertViewStyle_PassWord:
                [_userNameField resignFirstResponder];
                [_passwordInputField resignFirstResponder];
                break;
            case XHAlertViewStyle_GifView:
                
                break;
            default:
                break;
        }
        [self.xhAlertDelegate clickCancleBtnAction];
    }
}

#pragma mark -set方法
- (void)setGitData:(NSData *)gitData {
    _gitData = gitData;
    [_gifView loadData:gitData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
