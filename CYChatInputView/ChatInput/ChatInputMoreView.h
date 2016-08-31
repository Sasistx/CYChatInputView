//
//  ChatInputMoreView.h
//  ChunyuClinic
//
//  Created by 高天翔 on 15/9/29.
//  Copyright © 2015年 lvjianxiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatInputViewDefines.h"

@protocol ChatInputMoreViewDeleagte;

@interface ChatInputMoreView : UIView <UIScrollViewDelegate>
@property (nonatomic, weak) id <ChatInputMoreViewDeleagte> delegate;
@property (nonatomic, readonly) ChatInputViewType type;
- (instancetype)initWithFrame:(CGRect)frame type:(ChatInputViewType)type delegate:(id)delegate;
- (void)refreshWithType:(ChatInputViewType)type;
@end

@protocol ChatInputMoreViewDeleagte <NSObject>
@optional

- (void)moreItemButtonClicked:(ChatInputViewType)type;

@end