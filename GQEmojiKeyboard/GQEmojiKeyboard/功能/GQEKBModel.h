//
//  GQEKBModel.h
//  GQEmojiKeyboard
//
//  Created by Guangquan Yu on 2018/5/11.
//  Copyright © 2018年 ZHM.YU. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^GQkbScrollInsetBlock)(UIEdgeInsets insets); // 修改insets使其能够偏移
typedef void(^GQkbScrollOffsetBlock)(CGPoint point); // 修改point使其偏移

typedef void(^GQupdateMessageBlock)(NSString * message, NSString * placeHolder); // 更新消息
typedef void(^GQInputBarHeightChangeBlock)(CGFloat barHeight, CGFloat kbHeight); // 更新高度（参数是输入条高度 和 键盘自身高度）
@interface GQEKBModel : NSObject

@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UIView *relativeView;
@property (copy, nonatomic) GQkbScrollInsetBlock scrollInsetBlock ;// 处理scrollView的时候回调处理
@property (copy, nonatomic) GQkbScrollOffsetBlock scrollOffsetBlock ;// 处理scrollView的时候回调处理

@property (assign, nonatomic)GQKeyboardType kbType; // 键盘类型
@property (strong, nonatomic) NSString * placeHolder ;// 占位信息
@property (copy, nonatomic) GQupdateMessageBlock messageBlock ;// 消息回调
@property (copy, nonatomic) GQInputBarHeightChangeBlock barHeightChangeBlock ;// 输入条高度改变

@end
