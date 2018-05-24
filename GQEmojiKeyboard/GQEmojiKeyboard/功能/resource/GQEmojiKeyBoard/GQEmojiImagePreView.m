//
//  GQEmojiImagePreView.m
//  GQEmojiKeyboard
//
//  Created by Guangquan Yu on 2018/5/11.
//  Copyright © 2018年 ZHM.YU. All rights reserved.
//

#import "GQEmojiImagePreView.h"

@implementation GQEmojiImagePreView
{
    UILabel *_emojiLabel;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:CGRectMake(0, 0, 102.5, 100)]){
        _emojiLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 102.5, 50)];
        _emojiLabel.font = [UIFont systemFontOfSize:GQEKBEmojiImageViewSize];
        _emojiLabel.textAlignment = NSTextAlignmentCenter;
        
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageBg = [[UIImageView alloc] initWithFrame:self.bounds];
        imageBg.image = [UIImage imageNamed:@"keyboard_preview_bg.png"];
        [self addSubview:imageBg];
        
        [self addSubview:_emojiLabel];
    }
    return self;
}

- (void)setEmoji:(NSString *)emoji{
    _emojiLabel.text = emoji;
}

@end
