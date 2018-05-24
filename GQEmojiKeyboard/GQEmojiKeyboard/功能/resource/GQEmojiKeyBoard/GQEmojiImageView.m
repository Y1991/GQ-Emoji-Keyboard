//
//  GQEmojiImageView.m
//  GQEmojiKeyboard
//
//  Created by Guangquan Yu on 2018/5/11.
//  Copyright © 2018年 ZHM.YU. All rights reserved.
//

#import "GQEmojiImageView.h"

@implementation GQEmojiImageView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        self.contentMode = UIViewContentModeCenter;
    }
    return self;
}

- (void)setEmoji:(NSString *)emoji{
    _emoji = emoji;
    NSDictionary *att = @{NSFontAttributeName:[UIFont systemFontOfSize:GQEKBEmojiImageViewSize]};
    CGSize size = [emoji sizeWithAttributes:att];
    CGFloat scale = [UIScreen mainScreen].scale;
    self.frame = CGRectMake(0, 0, size.width, size.height);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGRect rect = CGRectMake(0, 0, size.width*scale, size.height*scale);
        UIGraphicsBeginImageContext(rect.size);
        [_emoji drawInRect:rect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:GQEKBEmojiImageViewSize*scale]}];
        UIImage *image = [UIImage imageWithCGImage:UIGraphicsGetImageFromCurrentImageContext().CGImage scale:scale orientation:UIImageOrientationUp];
        UIGraphicsEndImageContext();
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = image;
        });
    });
}

+ (CGSize)emojiImageViewSize{
    GQEmojiImageView *emojiView = [GQEmojiImageView new];
    emojiView.emoji = @"😄";
    CGFloat emojiWidth = CGRectGetWidth(emojiView.frame);
    CGFloat emojiHeight = CGRectGetHeight(emojiView.frame);
    return CGSizeMake(emojiWidth, emojiHeight);
}
@end
