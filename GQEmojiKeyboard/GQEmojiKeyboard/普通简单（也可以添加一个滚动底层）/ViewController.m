//
//  ViewController.m
//  GQEmojiKeyboard
//
//  Created by Guangquan Yu on 2018/5/11.
//  Copyright © 2018年 ZHM.YU. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(40, 100, 100, 50)];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"开始输入" forState:0];
    [button setTitleColor:[UIColor blackColor] forState:0];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:64];
    [self.view addSubview:button];
}

- (void)buttonClick:(UIButton *)button{

    GQEKBModel * model = [[GQEKBModel alloc]init];
//    model.relativeView = nil ;
//    model.scrollView = nil;
//    __weak typeof(self) weakSelf = self;
//    model.scrollInsetBlock = ^(UIEdgeInsets insets) {
//        weakSelf.tableView.contentInset = insets;
//    };
//    model.scrollOffsetBlock = ^(CGPoint point) {
//        weakSelf.tableView.contentOffset = point;
//    };
    
    model.kbType = GQKeyboardTypeText;
    model.placeHolder = @"您可以发送信息了";
    model.messageBlock = ^(NSString *message, NSString *placeHolder) {
        NSLog(@"发送消息 ===> %@   %@", placeHolder, message);
    };
    model.barHeightChangeBlock = ^(CGFloat barHeight, CGFloat kbHeight) {
        NSLog(@"高度改变 ===> %f   %f", barHeight, kbHeight);
    };
 
    [GQEmojiKBManager share].model = model;
    [[GQEmojiKBManager share] startEdit];
}


@end
