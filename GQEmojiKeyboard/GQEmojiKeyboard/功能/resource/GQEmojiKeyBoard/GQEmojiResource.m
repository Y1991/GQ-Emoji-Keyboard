//
//  GQEmojiResource.m
//  GQEmojiKeyboard
//
//  Created by Guangquan Yu on 2018/5/11.
//  Copyright © 2018年 ZHM.YU. All rights reserved.
//

#import "GQEmojiResource.h"
@interface GQEmojiResource ()
@property(nonatomic, strong)NSMutableArray<NSArray<GQEmoji *> *> *  emojis;
@property(nonatomic, strong)NSMutableArray<GQEmojiTypeModel *> *  emojiTypes;
@end
@implementation GQEmojiResource
#pragma mark - 1.获取所有表情
- (NSArray<NSArray<GQEmoji *> *> *)allEmojis{
    return self.emojis;
}
#pragma mark - 2.获取所有表情类型
- (NSArray<GQEmojiTypeModel *> *)allEmojiTypes{
    return self.emojiTypes;
}

#pragma mark - 3.创建、从文件中获取值
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadFile];
    }
    return self;
}

- (void)loadFile{
    _emojis = @[].mutableCopy;
    _emojiTypes = @[].mutableCopy;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"json"];
    NSData *emojiData = [[NSData alloc] initWithContentsOfFile:path];
    NSDictionary * emojisDic = [NSJSONSerialization JSONObjectWithData:emojiData options:NSJSONReadingAllowFragments error:nil];
    
    [self handleWithKey:@"people" value:emojisDic[@"people"]];
    [self handleWithKey:@"nature" value:emojisDic[@"nature"]];
    [self handleWithKey:@"tool" value:emojisDic[@"tool"]];
    [self handleWithKey:@"traffic" value:emojisDic[@"traffic"]];
    [self handleWithKey:@"number" value:emojisDic[@"number"]];

}


- (void)handleWithKey:(NSString *)key value:(NSArray<NSString *> *)obj{
    GQKeyboardEmojiType emojiType = GQKeyboardEmojiTypePeople;
    NSString * emojiTypeText = @"人物";
    if ([key isEqualToString:@"people"]) { // 人物
        emojiType = GQKeyboardEmojiTypePeople;
        emojiTypeText = @"人物";
    } else if ([key isEqualToString:@"nature"]) { // 自然
        emojiType = GQKeyboardEmojiTypeNature;
        emojiTypeText = @"自然";
    } else if ([key isEqualToString:@"tool"]) { // 工具
        emojiType = GQKeyboardEmojiTypeTool;
        emojiTypeText = @"工具";
    } else if ([key isEqualToString:@"traffic"]) { // 交通
        emojiType = GQKeyboardEmojiTypeTraffic;
        emojiTypeText = @"交通";
    } else if ([key isEqualToString:@"number"]) { // 数字
        emojiType = GQKeyboardEmojiTypeNumber;
        emojiTypeText = @"数字";
    }
    
    
    GQEmojiTypeModel * type = [GQEmojiTypeModel new];
    type.emojiTypeText = emojiTypeText;
    type.emojiType = emojiType;
    
    NSMutableArray * arr = @[].mutableCopy;
    for (int i=0; i<obj.count; i++) {
        
        GQEmoji * emoji = [GQEmoji new];
        emoji.emoji = obj[i];
        
        emoji.emojiType = type;
        
        [arr addObject:emoji];
    }
    
    
    [_emojiTypes addObject:type];
    [_emojis addObject:arr];
}

@end
