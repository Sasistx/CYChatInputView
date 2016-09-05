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

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray*)dataArray delegate:(id)delegate;
- (void)refreshWithButtonInfo:(NSArray*)buttonInfo;
@end

@protocol ChatInputMoreViewDeleagte <NSObject>
@optional

- (void)moreItemButtonClicked:(ChatInputViewType)type info:(NSDictionary*)info;

@end