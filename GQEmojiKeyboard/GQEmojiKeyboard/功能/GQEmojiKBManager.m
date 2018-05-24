//
//  GQEmojiKBManager.m
//  GQEmojiKeyboard
//
//  Created by Guangquan Yu on 2018/5/11.
//  Copyright © 2018年 ZHM.YU. All rights reserved.
//

#import "GQEmojiKBManager.h"

@interface GQEmojiKBManager ()
@property(nonatomic, strong) GQInputBar * inputBar; 

@end

static GQEmojiKBManager * gqEKBM;
@implementation GQEmojiKBManager
+ (GQEmojiKBManager *)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gqEKBM = [[self alloc]init];
    });
    return gqEKBM;
}

- (void)startEdit{
    self.isEdit = YES;
    _kbType = self.model.kbType;

    UIView * superView;
    UIWindow *applicationWindow = [UIApplication sharedApplication].keyWindow;
    if (applicationWindow) {
        superView = applicationWindow;
    } else {
        superView = [[UIApplication sharedApplication].delegate window];
    }
    
    [superView addSubview:self.inputBar];
    [self.inputBar becomeFirstResponder];
}

- (void)stopEdit{
    self.isEdit = NO;
    // 有退出的动画
    [self.inputBar resignFirstResponder];
    [self.inputBar removeFromSuperview];
    self.model = nil;
    
}

#pragma mark - lazying

-(GQInputBar *)inputBar{
    if (!_inputBar) {
        _inputBar = [[GQInputBar alloc]initWithFrame:CGRectZero];
    }
    return _inputBar;
}

@end
