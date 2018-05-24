//
//  GQEKBEnumeration.h
//  GQEmojiKeyboard
//
//  Created by Guangquan Yu on 2018/5/11.
//  Copyright © 2018年 ZHM.YU. All rights reserved.
//

#ifndef GQEKBEnumeration_h
#define GQEKBEnumeration_h

#ifdef __OBJC__

// 1、键盘类型
typedef NS_ENUM(NSUInteger, GQKeyboardType) {
    GQKeyboardTypeText = 1, // 默认系统键盘
    GQKeyboardTypeEmoji ,   // 表情符号键盘（自定义一级键盘）
 
};

// 2、表情符号键盘类型
typedef NS_ENUM(NSUInteger, GQKeyboardEmojiType) {
    GQKeyboardEmojiTypePeople = 1,  // 人
    GQKeyboardEmojiTypeNature ,     // 自然
    GQKeyboardEmojiTypeTool ,       // 工具
    GQKeyboardEmojiTypeTraffic ,    // 交通
    GQKeyboardEmojiTypeNumber ,     // 数字
};



#endif

#endif /* GQEKBEnumeration_h */
