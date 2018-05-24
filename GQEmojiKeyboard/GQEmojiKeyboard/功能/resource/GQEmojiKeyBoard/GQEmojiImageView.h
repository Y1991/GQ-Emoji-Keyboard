//
//  GQEmojiImageView.h
//  GQEmojiKeyboard
//
//  Created by Guangquan Yu on 2018/5/11.
//  Copyright © 2018年 ZHM.YU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GQEmojiImageView : UIImageView
@property (copy, nonatomic) NSString *emoji;

+ (CGSize)emojiImageViewSize;
@end
