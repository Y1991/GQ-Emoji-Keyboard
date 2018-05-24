//
//  GQEmojiKBManager.h
//  GQEmojiKeyboard
//
//  Created by Guangquan Yu on 2018/5/11.
//  Copyright © 2018年 ZHM.YU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GQInputBar.h"


@interface GQEmojiKBManager : NSObject

@property(nonatomic, strong, readonly) GQInputBar * inputBar;
@property(nonatomic, assign) GQKeyboardType kbType;
@property(nonatomic, assign) BOOL isEdit;

@property(nonatomic, strong) GQEKBModel * model;
+ (GQEmojiKBManager *)share ;
- (void)startEdit;
- (void)stopEdit; 
@end
