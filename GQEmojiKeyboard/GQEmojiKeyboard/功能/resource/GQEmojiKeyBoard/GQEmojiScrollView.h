//
//  GQEmojiScrollView.h
//  GQEmojiKeyboard
//
//  Created by Guangquan Yu on 2018/5/11.
//  Copyright © 2018年 ZHM.YU. All rights reserved.
//

#import <UIKit/UIKit.h>
#pragma mark - 协议
@protocol GQEmojiScrollViewDelegate <NSObject>

@required
- (NSInteger)countOfEmojiPageSection;
- (NSArray<GQEmoji *> *)emojisForSection:(NSInteger)section;
//- (NSString *)titleForSection:(NSInteger)section;

@optional
- (void)emojiDidClicked:(NSString *)emoji;
- (void)didScrollToSection:(NSInteger)section;
- (void)emojiDeleteClicked;

@end
@interface GQEmojiScrollView : UIScrollView
@property (weak, nonatomic) id<GQEmojiScrollViewDelegate> emojiDelegate;
- (void)reloadData;

- (void)updateEmojiType:(GQKeyboardEmojiType)emojiType;
@end
