//
//  GQEmojiKeyBoard.m
//  GQEmojiKeyboard
//
//  Created by Guangquan Yu on 2018/5/11.
//  Copyright © 2018年 ZHM.YU. All rights reserved.
//

#import "GQEmojiKeyBoard.h"
#import "GQEmojiResource.h"
#import "GQEmojiScrollView.h"
#import "GQEmojiToolBar.h"

@interface GQEmojiKeyBoard ()<GQEmojiScrollViewDelegate>

@property(nonatomic, strong) GQEmojiResource * emojiResource;
@property(nonatomic, strong) GQEmojiScrollView * emojiScrollView;
@property(nonatomic, strong) GQEmojiToolBar * emojiToolBar;

@end

@implementation GQEmojiKeyBoard

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadData];
        [self makeUI];
    }
    return self;
}

- (void)loadData{
    self.emojiResource = [GQEmojiResource new];
}

- (void)makeUI{
    [self addSubview:self.emojiScrollView];
    [self addSubview:self.emojiToolBar];
    
    self.frame = CGRectMake(0, 0, DEVICE_WIDTH, GQEKBEmojiHeight);
    self.emojiScrollView.frame = CGRectMake(0, 0, DEVICE_WIDTH, GQEKBEmojiHeight-GQEKBEmojiToolBarHeight);
    self.emojiToolBar.frame = CGRectMake(0, GQEKBEmojiHeight-GQEKBEmojiToolBarHeight, DEVICE_WIDTH, GQEKBEmojiToolBarHeight);
}

- (void)makeLevel1keyboard{
    
    if ([[GQEmojiKBManager share].inputBar.textView isKindOfClass:[UITextView class]]) {
        [(UITextView *)[GQEmojiKBManager share].inputBar.textView setInputView:self];

    }

    [self.emojiScrollView reloadData];;
   
}

- (void)deletePressed{
    [[GQEmojiKBManager share].inputBar.textView deleteBackward];
    [[UIDevice currentDevice] playInputClick];
    [self textChanged];
}

- (void)insertEmoji:(NSString *)emoji{
    [[UIDevice currentDevice] playInputClick];
    [[GQEmojiKBManager share].inputBar.textView insertText:emoji];
    [self textChanged];
}

- (void)textChanged{
//    if ([self.textView isKindOfClass:[UITextView class]])
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:[GQEmojiKBManager share].inputBar.textView];
//    else if ([self.textView isKindOfClass:[UITextField class]])
//        [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self.textView];
}

// section数量
- (NSInteger)countOfEmojiPageSection{
    return [self.emojiResource allEmojis].count;
}
// cell数量
- (NSArray<GQEmoji *> *)emojisForSection:(NSInteger)section{
    return [self.emojiResource allEmojis][section];
}

// 选中了某个表情
- (void)emojiDidClicked:(NSString *)emoji{
    [self insertEmoji:emoji];
}
// 删除
- (void)emojiDeleteClicked{
    [self deletePressed];
}

// 切换section（横向滚动就调用）
- (void)didScrollToSection:(NSInteger)section{
    [self.emojiToolBar updateEmojiType:section+1];
}

#pragma mark lazy ----
- (GQEmojiToolBar *)emojiToolBar{
    if (!_emojiToolBar) {
        _emojiToolBar = [GQEmojiToolBar toolBarWithEmojis:self.emojiResource.allEmojiTypes];
        __weak typeof(self) wself = self;
        _emojiToolBar.selectedBlock = ^(GQKeyboardEmojiType type){ // 选中某个表情块
            [wself.emojiToolBar updateEmojiType:type];
            [wself.emojiScrollView updateEmojiType:type];
        };
        _emojiToolBar.deleteBlock = ^(void){ // 删除
            [wself deletePressed];
        };

        
    }
    return _emojiToolBar;
}

- (GQEmojiScrollView *)emojiScrollView{
    if (!_emojiScrollView) {
        _emojiScrollView = [[GQEmojiScrollView alloc] initWithFrame:CGRectZero];
        _emojiScrollView.emojiDelegate = self;
    }
    return _emojiScrollView;
}

@end
