//
//  ChatInputMoreButton.h
//  ChunyuClinic
//
//  Created by 高天翔 on 15/9/29.
//  Copyright © 2015年 lvjianxiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatInputMoreView.h"

@interface ChatInputMoreButton : UIButton
@property (nonatomic, strong) ChatInputMoreView* moreInputView;
@property (nonatomic, strong) NSArray* buttonInfo;
@property (nonatomic, weak) id <ChatInputMoreViewDeleagte> delegate;
- (void)refreshMoreViewWithButtonInfo:(NSArray*)buttonInfo;
@end
