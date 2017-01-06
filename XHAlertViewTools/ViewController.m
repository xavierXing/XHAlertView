//
//  ViewController.m
//  XHAlertViewTools
//
//  Created by xinghao on 2016/12/22.
//  Copyright © 2016年 xinghao. All rights reserved.
//

#import "ViewController.h"
#import "XHAlertView.h"
@interface ViewController ()<XHAlertViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    UIButton * tempbuttons = [UIButton buttonWithType:UIButtonTypeCustom];
    tempbuttons.frame = CGRectMake(100, 100 , 100, 100);
    tempbuttons.backgroundColor = [UIColor yellowColor];
    [tempbuttons addTarget:self action:@selector(clickaction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tempbuttons];
    
    
    UIButton * tempbutton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    tempbutton2.frame = CGRectMake(100, 300 , 100, 100);
    tempbutton2.backgroundColor = [UIColor orangeColor];
    [tempbutton2 addTarget:self action:@selector(clickactions:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tempbutton2];

}

- (void)clickaction:(id)sender {
    XHAlertView * alert = [XHAlertView alertWithMessage:@"123" WithTitle:@"123" WithAlertViewStyle:XHAlertViewStyle_PassWord];
    alert.xhAlertDelegate = self;
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"lufei" ofType:@"gif"];
    NSData * gifData = [NSData dataWithContentsOfFile:filePath];
    alert.gitData = gifData;
    [XHAlertView showAlert];
}

- (void)clickSureBtnActionWithPassWord:(NSString *)passWord WithUserName:(NSString *)userName {
    NSLog(@"log : %@  log : %@",passWord,userName);
}

- (void)clickSureBtnActionWithInputTextField:(NSString *)inputString {
    NSLog(@"log : %@",inputString);
}

- (void)clickSureBtnAction {
    NSLog(@"this click is make sure");
}

- (void)clickCancleBtnAction {
    NSLog(@"this click is make cancle");
}

- (void)clickactions:(id)sender {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"123" message:@"123" delegate:self cancelButtonTitle:@"cancle" otherButtonTitles:@"ture", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
