//
//  ChatInputView.h
//  CYChatInputView
//
//  Created by 高天翔 on 16/8/30.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChatInputView;

@protocol ChatInputViewDelegate <NSObject>

@optional

- (BOOL)inputViewShouldReturn;

- (void)inputViewDidBeginRecording;

- (void)inputViewDidEndRecordingWithAudioPath:(NSString *)audioPath duration:(NSTimeInterval)duration;

- (void)inputViewDidCancelRecording;

- (void)inputViewDidChangeFrame:(ChatInputView *)inputView;

@end

@interface ChatInputView : UIView

@end
