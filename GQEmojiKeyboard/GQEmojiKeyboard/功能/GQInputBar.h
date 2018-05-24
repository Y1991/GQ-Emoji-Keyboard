//
//  GQInputBar.h
//  GQEmojiKeyboard
//
//  Created by Guangquan Yu on 2018/5/11.
//  Copyright © 2018年 ZHM.YU. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
    1.输入条 类似于二级键盘的效果：
           并不是编辑视图的二级键盘，
           而是在键盘显示或隐藏时改变输入条的frame
    ---------------------------------------------
 
    2.输入条（默认一级键盘为系统键盘）（切换键盘时，一级键盘为自定义表情符号键盘）
 */
@interface GQInputBar : UIView

@property (strong, nonatomic, readonly) UITextView *textView; // 显示输入的内容【内部赋值】

@end
