//
//  ChatInputView.h
//  CYChatInputView
//
//  Created by 高天翔 on 16/8/30.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatInputMoreButton.h"
#import "CYAudioRecorderButton.h"
#import "AutoFitTextView.h"
#import "CYAudioRecorder.h"
#import "cyMacros.h"

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
@property (nonatomic, strong) CYAudioRecorder *audioRecorder;
@property (nonatomic, strong) AutoFitTextView* inputTextView;
@property (nonatomic) CGFloat inputTextViewMaxHeight;
@property (nonatomic, readonly) CGFloat textInputItemHeight;

@property (nonatomic, weak) id <ChatInputViewDelegate, ChatInputMoreViewDeleagte> delegate;
@property (nonatomic) ChatInputViewState state;
@property (nonatomic) NSInteger postId;
@property (nonatomic) BOOL isForbidden;

@property (nonatomic, readonly) NSString *audioObjectId;
@property (nonatomic, readonly) NSString *audioPath;

//@{@"title":@"拍照", @"image":@"chatinput_photo"}
+ (ChatInputView*)inputViewWithButtonData:(NSArray*)buttonData showRecordButton:(BOOL)showRecord delegate:(id)delegate;

- (void)resetText;

- (void)setAllItemStateDeselect;

- (void)updateMoreButtonWithButtonInfo:(NSArray*)buttonInfo;

@end
