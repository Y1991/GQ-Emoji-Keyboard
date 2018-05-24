//
//  GQEmojiResource.h
//  GQEmojiKeyboard
//
//  Created by Guangquan Yu on 2018/5/11.
//  Copyright © 2018年 ZHM.YU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GQEmojiResource : NSObject
- (NSArray<NSArray<GQEmoji *> *> *)allEmojis;
- (NSArray<GQEmojiTypeModel *> *)allEmojiTypes; 
@end
