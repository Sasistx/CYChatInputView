//
//  ChatInputMoreButton.m
//  ChunyuClinic
//
//  Created by 高天翔 on 15/9/29.
//  Copyright © 2015年 lvjianxiong. All rights reserved.
//

#import "ChatInputMoreButton.h"

@implementation ChatInputMoreButton

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (UIView*)inputView
{
    return self.moreInputView;
}

- (ChatInputMoreView*)moreInputView
{
    if (!_moreInputView) {
        
        _moreInputView = [[ChatInputMoreView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 216) dataArray:_buttonInfo delegate:_delegate];
    }
    return _moreInputView;
}

- (void)refreshMoreViewWithButtonInfo:(NSArray*)buttonInfo
{
    self.buttonInfo = buttonInfo;
    [self.moreInputView refreshWithButtonInfo:_buttonInfo];
}

@end
