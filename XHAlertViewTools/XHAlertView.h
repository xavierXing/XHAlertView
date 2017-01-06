//
//  XHAlertView.h
//  XHAlertViewTools
//
//  Created by xinghao on 2016/12/22.
//  Copyright © 2016年 xinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    XHAlertViewStyle_Normal,/**正常*/
    XHAlertViewStyle_TextFiled,/**文本框*/
    XHAlertViewStyle_PassWord,/**密码框*/
    XHAlertViewStyle_GifView,/** 加载gif图片 */
} XHAlertViewStyle;

@protocol XHAlertViewDelegate <NSObject>

- (void)clickSureBtnAction;/**代理: 点击'确定'按钮 _normal*/
- (void)clickCancleBtnAction;/**代理: 点击'取消'按钮*/
- (void)clickSureBtnActionWithInputTextField:(nullable NSString *)inputString;/**代理: 点击'确定'按钮 _TextFiled*/
- (void)clickSureBtnActionWithPassWord:(nullable NSString *)passWord
                          WithUserName:(nullable NSString *)userName;/** 代理: 点击'确定'按钮 _PassWord */

@end


@interface XHAlertView : UIView

@property(nullable ,nonatomic , weak)id<XHAlertViewDelegate> xhAlertDelegate;/**代理: delegate*/
@property(nonnull ,nonatomic, strong)NSData * gitData;/** gif资源 */

+ (nonnull XHAlertView *)alertWithMessage:(nonnull NSString * )message
                        WithTitle:(nullable NSString *  )title
               WithAlertViewStyle:(XHAlertViewStyle )style;

+ (void)showAlert;/**展现alert*/
+ (void)dismissAlert;/**取消alert*/

@end
