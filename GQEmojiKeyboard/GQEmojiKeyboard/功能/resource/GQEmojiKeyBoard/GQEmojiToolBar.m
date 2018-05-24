//
//  GQEmojiToolBar.m
//  GQEmojiKeyboard
//
//  Created by Guangquan Yu on 2018/5/11.
//  Copyright © 2018年 ZHM.YU. All rights reserved.
//

#import "GQEmojiToolBar.h"

@interface GQEmojiToolBar ()

@property (assign, nonatomic) GQKeyboardEmojiType emojiType;
@property (strong, nonatomic) NSArray<GQEmojiTypeModel *>* emojiTypes;

@end

@implementation GQEmojiToolBar
{
    BOOL _isTouchDown;

}

+ (instancetype)toolBarWithEmojis:(NSArray<GQEmojiTypeModel *> *)emojiTypes{
    GQEmojiToolBar * toolbar = [self new];
    toolbar.emojiTypes = emojiTypes;
    return toolbar;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, GQEKBEmojiHeight-GQEKBEmojiToolBarHeight, DEVICE_WIDTH, GQEKBEmojiToolBarHeight)];
    if (self) {
        self.emojiType = GQKeyboardEmojiTypePeople;
        
    }
    return self;
}

- (void)setEmojiTypes:(NSArray<GQEmojiTypeModel *> *)emojiTypes{
    _emojiTypes = emojiTypes;
    
    [self makeUI];
}

- (void)updateEmojiType:(GQKeyboardEmojiType)emojiType{
    _emojiType = emojiType;
    for (UIButton *button in self.subviews){
        button.selected = (button.tag == emojiType);
    }
}

- (void)makeUI{
    UIButton *(^getButton)(CGRect, NSInteger, NSString *);
    getButton = ^UIButton *(CGRect frame, NSInteger tag, NSString *title){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tag = tag;
        button.adjustsImageWhenHighlighted = NO;
        button.tintColor = [UIColor colorWithRed:132/255.0 green:120/255.0 blue:158/255.0 alpha:0.8];
        button.frame = frame;
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.titleLabel.minimumScaleFactor = 0.8;
        [button addTarget:self action:@selector(emojiButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        return button;
    };
    
    CGFloat w = CGRectGetWidth(self.frame)/6;
    CGFloat h = CGRectGetHeight(self.frame);
    CGFloat left = 0;
    for (GQEmojiTypeModel *emojiType in self.emojiTypes){
        UIButton *emojiButton = getButton(CGRectMake(left, 0, w, h),
                                          emojiType.emojiType,
                                          emojiType.emojiTypeText);
        [self addSubview:emojiButton];
        left += w;
    }

}

- (void)emojiButtonTouchDown:(UIButton *)button{
    _emojiType = button.tag;
    if (self.selectedBlock){
        self.selectedBlock(button.tag);
    }
}

- (void)touchDown{
    _isTouchDown = YES;
    [self startActionWithDelaytime:0.3 isFirst:YES event:^{
        [self tureAction];
    }];
    
}

- (void)touchUp{
    _isTouchDown = NO;
}

- (void)startActionWithDelaytime:(CGFloat)delaytime isFirst:(BOOL)isFirst event:(void(^)(void))event{
    if (event) {
        if (isFirst)
            event();
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaytime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (_isTouchDown){
                event();
                
                [self startActionWithDelaytime:0.1 isFirst:NO event:event];
            }
        });
    }
}

- (void)tureAction{
    if (self.deleteBlock){
        self.deleteBlock();
    }
}

@end
