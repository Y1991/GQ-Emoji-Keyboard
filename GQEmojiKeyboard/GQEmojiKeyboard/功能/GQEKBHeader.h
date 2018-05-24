//
//  GQEKBHeader.h
//  GQEmojiKeyboard
//
//  Created by Guangquan Yu on 2018/5/11.
//  Copyright © 2018年 ZHM.YU. All rights reserved.
//

#ifndef GQEKBHeader_h
#define GQEKBHeader_h

#ifdef __OBJC__

#import <UIKit/UIKit.h>
#import "GQEKBEnumeration.h"

#import "GQEKBModel.h"
#import "GQEmojiKBManager.h"
#import "GQInputBar.h"

#import "GQEmojiKeyBoard.h"
#import "GQEmojiTypeModel.h"
#import "GQEmoji.h"
#import "GQEmojiToolBar.h"
#import "GQEmojiImageView.h"
#import "GQEmojiImagePreView.h"

#define DEVICE_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define DEVICE_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define GQEKBBarHeight (44) // 默认 输入条高度

#define GQEKBBarSwitchButtonWidth (50) // 默认 输入条上的切换键盘按钮的宽度
#define GQEKBBarSwitchButtonHeight (30) // 默认 输入条上的切换键盘按钮的高度

#define GQEKBBarTextViewHeight (30) // 默认 输入条上的输入框的高度
#define GQEKBBarTextViewMaxHeight (80) // 默认 输入条上的输入框的最大高度

#define GQEKBBarSendButtonWidth (55) // 默认 输入条上的发送按钮的宽度
#define GQEKBBarSendButtonHeight (30) // 默认 输入条上的发送按钮的高度

#define GQEKBEmojiHeight (262) // 默认 表情符号键盘高度
#define GQEKBEmojiToolBarHeight (30) // 默认 表情符号底部工具条高度
#define GQEKBEmojiImageViewSize (33) // 默认 表情符号的大小

#endif

#endif /* GQEKBHeader_h */
