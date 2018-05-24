//
//  GQInputBar.m
//  GQEmojiKeyboard
//
//  Created by Guangquan Yu on 2018/5/11.
//  Copyright © 2018年 ZHM.YU. All rights reserved.
//

#import "GQInputBar.h"

@interface GQInputBar () <UITextViewDelegate>

@property (strong, nonatomic) UIButton * switchKbButton; // 切换键盘
@property (strong, nonatomic) UITextView *textView; // 显示输入的内容
@property (strong, nonatomic) UILabel *placeHolderLabel; // 占位信息
@property (strong, nonatomic) UIButton *sendButton; // 发送按钮

@property (strong, nonatomic) NSDictionary<NSNumber*,NSString*> * switchKbBtnImageDic;
@property (strong, nonatomic) GQEmojiKeyBoard *emojiKeyBoard;

@property (strong, nonatomic) UITapGestureRecognizer * popTapGesture;
@end
@implementation GQInputBar
{
    CGFloat _kbHeight;
    NSTimeInterval _kbAnimationDuration;
    CGRect _kbEndFrame;
    NSNumber * _kbCurve;
}

- (BOOL)becomeFirstResponder{
    BOOL b = [super becomeFirstResponder];
    [self switchKb];
    [[[UIApplication sharedApplication] delegate].window addGestureRecognizer:self.popTapGesture];
    return b;
}

- (BOOL)resignFirstResponder{
    BOOL b = [super resignFirstResponder];
    BOOL b1 = [self.textView resignFirstResponder];
    [[[UIApplication sharedApplication] delegate].window removeGestureRecognizer:self.popTapGesture];
    return b&&b1;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, GQEKBBarHeight)]){
        [GQEmojiKBManager share].kbType = GQKeyboardTypeText;
        
        [self makeUI];
        [self makeAllKB];

        UITapGestureRecognizer *dissmissTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gqEndEdit)];
        self.popTapGesture = dissmissTap;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)gqEndEdit{
    [[GQEmojiKBManager share] stopEdit];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)makeUI{
    _switchKbBtnImageDic = @{[NSNumber numberWithInteger:GQKeyboardTypeText]:@"GQKeyboardTypeEmoji",
                        [NSNumber numberWithInteger:GQKeyboardTypeEmoji]:@"GQKeyboardTypeText"};
    self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self addSubview:self.switchKbButton];
    [self addSubview:self.textView];
    [self addSubview:self.placeHolderLabel];
    [self addSubview:self.sendButton];
    GQKeyboardType type = [GQEmojiKBManager share].kbType ;
    [_switchKbButton setImage:[UIImage imageNamed:_switchKbBtnImageDic[[NSNumber numberWithInteger:type]]] forState:UIControlStateNormal];
    [self makeFrame];
}

- (void)makeFrame{
    self.textView.frame = CGRectMake(GQEKBBarSwitchButtonWidth, (GQEKBBarHeight-GQEKBBarTextViewHeight)/2, CGRectGetWidth(self.frame)-GQEKBBarSwitchButtonWidth-GQEKBBarSendButtonWidth, GQEKBBarTextViewHeight);
    self.sendButton.enabled = ![@"" isEqualToString:self.textView.text];
    _placeHolderLabel.hidden = self.sendButton.enabled;
    CGRect textViewFrame = self.textView.frame;
    CGSize textSize = [self.textView sizeThatFits:CGSizeMake(CGRectGetWidth(textViewFrame), 1000.0f)];
    CGFloat offset = 10;
    self.textView.scrollEnabled = (textSize.height > GQEKBBarTextViewMaxHeight-offset);
    textViewFrame.size.height = MAX(GQEKBBarTextViewHeight, MIN(GQEKBBarTextViewMaxHeight, textSize.height));
    self.textView.frame = textViewFrame;
    self.placeHolderLabel.frame = CGRectMake(CGRectGetMinX(_textView.frame)+5, CGRectGetMinY(_textView.frame), CGRectGetWidth(_textView.frame), CGRectGetHeight(_textView.frame));
    CGRect addBarFrame = self.frame;
    CGFloat maxY = CGRectGetMaxY(addBarFrame);
    addBarFrame.size.height = textViewFrame.size.height+offset;
    addBarFrame.origin.y = maxY-addBarFrame.size.height;
    self.frame = addBarFrame;
    self.switchKbButton.frame = CGRectMake(0, self.frame.size.height - (GQEKBBarHeight-GQEKBBarSwitchButtonHeight)/2 - GQEKBBarSwitchButtonHeight, GQEKBBarSwitchButtonWidth, GQEKBBarSwitchButtonHeight);
    self.sendButton.frame = CGRectMake(CGRectGetWidth(self.frame)-GQEKBBarSendButtonWidth, self.frame.size.height - (GQEKBBarHeight-GQEKBBarSendButtonHeight)/2 - GQEKBBarSendButtonHeight, GQEKBBarSendButtonWidth, GQEKBBarSendButtonHeight);
    if ([GQEmojiKBManager share].model.barHeightChangeBlock) {
        [GQEmojiKBManager share].model.barHeightChangeBlock(self.frame.size.height, _kbHeight);
    }

    [self offsetScrollViewWithIsKBShow:NO];
}

- (void)makeAllKB{
    [self emojiKeyBoard];
}

- (void)switchKbButtonClicked:(UIButton *)button{
    if ([GQEmojiKBManager share].kbType == GQKeyboardTypeText){
        [GQEmojiKBManager share].kbType = GQKeyboardTypeEmoji;
    }
    else if ([GQEmojiKBManager share].kbType == GQKeyboardTypeEmoji){
        [GQEmojiKBManager share].kbType = GQKeyboardTypeText;
    }
    [self switchKb];
}

- (void)switchKb{
    if ([GQEmojiKBManager share].kbType == GQKeyboardTypeText){
        self.textView.inputView = nil;
    }
    else if ([GQEmojiKBManager share].kbType == GQKeyboardTypeEmoji){
        // 为self.textView设置一级键盘
        [_emojiKeyBoard makeLevel1keyboard];
    }
    [self.textView reloadInputViews];

    GQKeyboardType type = [GQEmojiKBManager share].kbType ;
    [_switchKbButton setImage:[UIImage imageNamed:_switchKbBtnImageDic[[NSNumber numberWithInteger:type]]] forState:UIControlStateNormal];
    [_textView becomeFirstResponder];
}

- (void)sendButtonClicked{
    if ([GQEmojiKBManager share].model.messageBlock){
        [GQEmojiKBManager share].model.messageBlock(self.textView.text, [GQEmojiKBManager share].model.placeHolder);
        self.textView.text = @"";
        [self makeFrame];
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    [self makeFrame];
 
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self sendButtonClicked]; // 发送
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    self.hidden = NO;
    
    NSTimeInterval animationDuration;
    CGRect keyBoardEndFrame;
    NSDictionary * userInfo = notification.userInfo;
    
    [userInfo[UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [userInfo[UIKeyboardFrameEndUserInfoKey] getValue:&keyBoardEndFrame];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    _kbHeight = keyBoardEndFrame.size.height;
    _kbAnimationDuration = animationDuration;
    _kbEndFrame = keyBoardEndFrame;
    _kbCurve = curve;
    
    [self offsetScrollViewWithIsKBShow:YES];
}


- (void)offsetScrollViewWithIsKBShow:(BOOL)isKBShow{
    NSTimeInterval animationDuration = 0;
    if (isKBShow) {
        animationDuration = _kbAnimationDuration;
    }
    
    UIView * relativeView = [GQEmojiKBManager share].model.relativeView;
    UIScrollView * scrollView = [GQEmojiKBManager share].model.scrollView;

    CGRect rect = [relativeView.superview convertRect:relativeView.frame toView:[[UIApplication sharedApplication] delegate].window];
    

    float moveDistance = _kbEndFrame.origin.y -(rect.origin.y+rect.size.height);

    CGRect newInputBarFrame = self.frame;
    newInputBarFrame.origin.y = [UIScreen mainScreen].bounds.size.height-CGRectGetHeight(self.frame)-_kbEndFrame.size.height;
    
    CGFloat originalOffsetY = scrollView.contentOffset.y;
    

    BOOL isAdaptionScroll = NO;
    if (moveDistance >  newInputBarFrame.size.height&&originalOffsetY <= (moveDistance-newInputBarFrame.size.height)) {
        
        isAdaptionScroll = NO;
    } else {
        isAdaptionScroll = YES;
    }
    
    if (isAdaptionScroll) {

        if ([GQEmojiKBManager share].model.scrollInsetBlock) {//_scrollView.contentInset = ;
            [GQEmojiKBManager share].model.scrollInsetBlock(UIEdgeInsetsMake(0, 0, [UIScreen mainScreen].bounds.size.height-((rect.origin.y+rect.size.height))-moveDistance +newInputBarFrame.size.height, 0));
        }

    }
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:[_kbCurve intValue]];
    [UIView setAnimationDelegate:self];
    
    if (isAdaptionScroll) {
        //        //在主线程中修改
        //        dispatch_async(dispatch_get_main_queue(), ^{
        if ([GQEmojiKBManager share].model.scrollOffsetBlock) {//_scrollView.contentOffset = ;
            [GQEmojiKBManager share].model.scrollOffsetBlock(CGPointMake(0 , originalOffsetY-moveDistance +newInputBarFrame.size.height));
        }
        //        });
    }
    self.frame = newInputBarFrame;
    
    //执行动画
    [UIView commitAnimations];
    
    // 回调（高度改变）
    if ([GQEmojiKBManager share].model.barHeightChangeBlock) {
        [GQEmojiKBManager share].model.barHeightChangeBlock(self.frame.size.height, _kbHeight);
    }
}

- (void)keyboardWillHidden:(NSNotification *)notification {
//    UIView * relativeView = [GQEmojiKBManager share].model.relativeView;
    UIScrollView * scrollView = [GQEmojiKBManager share].model.scrollView;
    
    CGFloat originalOffsetY = scrollView.contentOffset.y;
    CGFloat maxOffset = scrollView.contentSize.height-scrollView.frame.size.height;// 最大偏移量
    if (maxOffset < originalOffsetY) {
        originalOffsetY = maxOffset;
    }
    NSDictionary* info = [notification userInfo];
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    [UIView animateWithDuration:[info[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0
                        options:([info[UIKeyboardAnimationCurveUserInfoKey] integerValue]<<16)
                     animations:^{
                         self.center = CGPointMake(self.bounds.size.width/2.0f, height+CGRectGetHeight(self.frame)/2.0);
                         //                         if (self.kbScrollInsetBlock) {//_scrollView.contentInset = ;
                         //                             self.kbScrollInsetBlock(UIEdgeInsetsZero);
                         //                         }
                         if ([GQEmojiKBManager share].model.scrollOffsetBlock) {//_scrollView.contentOffset = ;
                             [GQEmojiKBManager share].model.scrollOffsetBlock(CGPointMake(0 , originalOffsetY));
                         }
                     }
                     completion:^(BOOL finished) {
                         if ([GQEmojiKBManager share].model.scrollInsetBlock) {//_scrollView.contentInset = ;
                             [GQEmojiKBManager share].model.scrollInsetBlock(UIEdgeInsetsZero);
                         }
                         if ([GQEmojiKBManager share].model.scrollOffsetBlock) {//_scrollView.contentOffset = ;
                             [GQEmojiKBManager share].model.scrollOffsetBlock(CGPointMake(0 , originalOffsetY));
                         }
                         self.textView.text = @"";
                         self.hidden = YES;
                     }];
}

#pragma mark - lazy
-(UIButton *)switchKbButton{
    if (!_switchKbButton) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(switchKbButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _switchKbButton = button;
    }
    return _switchKbButton;
}
-(UITextView *)textView{
    if (!_textView) {
        UITextView * tv = [[UITextView alloc] initWithFrame:CGRectZero];
        tv.backgroundColor = [UIColor clearColor];
        // self.textView.textContainerInset = UIEdgeInsetsMake(5.0f, 0.0f, 5.0f, 0.0f);
        tv.textColor = [UIColor blackColor];
        tv.font = [UIFont systemFontOfSize:16];
        tv.returnKeyType = UIReturnKeySend;
        tv.delegate = self;
        tv.tintColor = [UIColor blueColor];
        tv.scrollEnabled = NO;
        tv.showsVerticalScrollIndicator = NO;
        
        tv.layer.borderWidth = 1;
        tv.layer.borderColor = [UIColor lightGrayColor].CGColor;
        tv.layer.cornerRadius = 3;
        _textView = tv;
    }
    return _textView;
}
-(UILabel *)placeHolderLabel{
    if (!_placeHolderLabel) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumScaleFactor = 0.9;
        label.textColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        label.font = _textView.font;
        label.userInteractionEnabled = NO;
        _placeHolderLabel = label;
        _placeHolderLabel.text = [GQEmojiKBManager share].model.placeHolder;
    }
    return _placeHolderLabel;
}
-(UIButton *)sendButton{
    if (!_sendButton) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"发送" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(2.50f, 0.0f, 0.0f, 0.0f)];
        button.titleLabel.font = [UIFont systemFontOfSize:19];
        [button addTarget:self action:@selector(sendButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        button.enabled = NO;
        _sendButton = button;
    }
    return _sendButton;
}

- (GQEmojiKeyBoard *)emojiKeyBoard{
    if (!_emojiKeyBoard) {
        _emojiKeyBoard = [[GQEmojiKeyBoard alloc]initWithFrame:CGRectZero];
    }
    return _emojiKeyBoard;
}

@end
