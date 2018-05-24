//
//  GQEmojiToolBar.h
//  GQEmojiKeyboard
//
//  Created by Guangquan Yu on 2018/5/11.
//  Copyright © 2018年 ZHM.YU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GQEmojiToolBar : UIView

@property (copy, nonatomic) void (^selectedBlock)(GQKeyboardEmojiType type);
@property (copy, nonatomic) void (^deleteBlock)(void);

+ (instancetype)toolBarWithEmojis:(NSArray<GQEmojiTypeModel *> *)emojiTypes;

- (void)updateEmojiType:(GQKeyboardEmojiType)emojiType;

@end
