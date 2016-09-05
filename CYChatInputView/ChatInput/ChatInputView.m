//
//  ChatInputView.m
//  CYChatInputView
//
//  Created by 高天翔 on 16/8/30.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import "ChatInputView.h"
#import "CYGlobalNavigatorMetrics.h"
#import "cyUIKit.h"
#import "SVProgressHUD.h"

@interface ChatInputView () <AutoFitTextViewDelegate>
@property (nonatomic, strong) UIView* textViewBack;
@property (nonatomic, strong) UIView* seperatorBottom;
@property (nonatomic, strong) UIView* seperatorTop;

@property (nonatomic, strong) NSArray* buttonArray;

@property (nonatomic, strong) CYAudioRecorderButton* recordButton;
@property (nonatomic, strong) ChatInputMoreButton* moreButton;

@property (nonatomic) BOOL showRecord;

@end

@implementation ChatInputView

#pragma mark -
#pragma mark - initialize


- (CYAudioRecorder *)audioRecorder {
    if (_audioRecorder == nil) {
        _audioRecorder = [CYAudioRecorder new];
    }
    return _audioRecorder;
}

- (ChatInputMoreButton*)moreButton
{
    if (!_moreButton) {
        
        //更多
        _moreButton = [ChatInputMoreButton buttonWithType:UIButtonTypeCustom];
        _moreButton.delegate = _delegate;
        _moreButton.buttonInfo = _buttonArray;
        [_moreButton setFrame:CGRectMake(viewWidth() - 45, 5, 40, 40)];
        [_moreButton setImage:[UIImage imageNamed:@"chatinput_more"] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(moreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _moreButton;
}

+ (ChatInputView*)inputViewWithButtonData:(NSArray*)buttonData showRecordButton:(BOOL)showRecord delegate:(id)delegate
{
    ChatInputView* chatInputView = [[ChatInputView alloc] initWithFrame:CGRectMake(0, 0, viewWidth(), 50) buttonData:buttonData showRecordButton:showRecord delegate:delegate];
    return chatInputView;
}

- (instancetype)initWithFrame:(CGRect)frame buttonData:(NSArray*)buttonData showRecordButton:(BOOL)showRecord delegate:(id)delegate{

    self = [super initWithFrame:frame];
    if (self) {
        
        _state = ChatInputViewStateClose;
        _delegate = delegate;
        _showRecord = showRecord;
        _buttonArray = [buttonData copy];
        [self createView];
    }
    return self;
}

#pragma mark -
#pragma mark - create view

- (void)createView
{
    _textViewBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth(), 50)];
    [_textViewBack setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:_textViewBack];
    
    _textInputItemHeight = _textViewBack.height;
    
    //录音
    _recordButton = self.audioRecorder.voiceBtn;
    [_recordButton setFrame:CGRectMake(5, 5, 40, 40)];
    [_recordButton setImage:[UIImage imageNamed:@"chatinput_record"] forState:UIControlStateNormal];
    [_textViewBack addSubview:_recordButton];
    
    // 录音事件
    
    Weakify(self);
    // 点击录音按钮
    [_recordButton cyTouchUpInsideWithBlock:^{
        Strongify(self);
        [CYAudioRecorder authorizeOnSuccess:^{
            [self.audioRecorder start];
            
        } failure:^{
            NSString *msg = [NSString stringWithFormat:@"请在“设置”—“隐私”—“麦克风”中允许%@访问", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]];
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
    
    [self.audioRecorder setStartRecordingBlock:^{
        Strongify(self);
        if ([self.delegate respondsToSelector:@selector(inputViewDidBeginRecording)]) {
            [self.delegate inputViewDidBeginRecording];
        }
    }];
    
    [self.audioRecorder setCancelBlock:^{
        Strongify(self);
        if ([self.delegate respondsToSelector:@selector(inputViewDidCancelRecording)]) {
            [self.delegate inputViewDidCancelRecording];
        }
    }];
    
    [self.audioRecorder setIsTimeoutBlock:^BOOL(NSTimeInterval time) {
        return time > 60.5;
    }];
    
    [self.audioRecorder setFinishBlock:^(NSString *path, NSTimeInterval duration) {
        Strongify(self);
        if ([self.delegate respondsToSelector:@selector(inputViewDidEndRecordingWithAudioPath:duration:)]) {
            [self.delegate inputViewDidEndRecordingWithAudioPath:path duration:duration];
        }
    }];
    
    [self.audioRecorder setAudioNameBlock:^NSString *{
        Strongify(self);
        self.audioObjectId = [[NSUUID UUID].UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@""];
        return [NSString stringWithFormat:@"%@.aac", self.audioObjectId];
    }];
    
    
    [self addSubview:self.moreButton];
    [_textViewBack addSubview:self.moreButton];
    
    if (_showRecord) {
        [_recordButton setHidden:YES];
        [self.moreButton setHidden:YES];
        
    }
    
    _inputTextView = ({
        
        CGRect textFrame = _showRecord ? CGRectMake(10, 10, viewWidth() - 20, 30) : CGRectMake(_recordButton.right + 3, 10, viewWidth() - _recordButton.width - self.moreButton.width - 10 - 6, 30);
        
        AutoFitTextView* textView = [[AutoFitTextView alloc] initWithFrame:textFrame];
        
        textView.backgroundColor = RGBCOLOR_HEX(0xf5f5f5);
        
        [textView setContainerInsetTop:5 bottom:5];
        
        textView.layer.cornerRadius = 4;
        textView.layer.borderColor = RGBCOLOR_HEX(0xe0e0e0).CGColor;
        textView.layer.borderWidth = 0.5;
        
        textView.returnKeyType = UIReturnKeySend;
        textView.font = [UIFont systemFontOfSize:15];
        
        textView.bottomPadding = 0;
        textView.minHeight = 30;
        textView.maxHeight = IS_iPhone4 ? 100: 160;
        
        textView.placeholder = @"输入文字描述病情...";
        textView.delegate = self;
        
        [_textViewBack addSubview:textView];
        
        textView;
    });
    
    _seperatorTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth(), 0.5)];
    _seperatorTop.backgroundColor = [UIColor colorWithRed:214/255.0 green:225/255.0 blue:232.0/255.0 alpha:1];
    //d6e1e8
    [_textViewBack addSubview:_seperatorTop];
    
    _seperatorBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth(), 0.5)];
    _seperatorBottom.backgroundColor = [UIColor colorWithRed:214/255.0 green:225/255.0 blue:232.0/255.0 alpha:1];
    _seperatorBottom.bottom = _textViewBack.bottom;
    [_textViewBack addSubview:_seperatorBottom];
}

- (void)setInputTextViewMaxHeight:(CGFloat)inputTextViewMaxHeight {
    _inputTextView.maxHeight = inputTextViewMaxHeight;
}

- (CGFloat)inputTextViewMaxHeight {
    return _inputTextView.maxHeight;
}

- (void)setAudioObjectId:(NSString *)audioObjectId {
    _audioObjectId = audioObjectId;
}

- (NSString *)audioPath {
    return self.audioRecorder.audioPath;
}

- (void)updateMoreButtonWithButtonInfo:(NSArray*)buttonInfo
{
    self.buttonArray = nil;
    self.buttonArray = [buttonInfo copy];
    if (!_moreButton) {
        [_textViewBack addSubview:self.moreButton];
    } else {
        self.moreButton.buttonInfo = buttonInfo;
        [self.moreButton refreshMoreViewWithButtonInfo:self.buttonArray];
    }
}

#pragma mark - 
#pragma mark - button event

- (void)moreButtonClicked:(id)sender
{
    UIButton* button = sender;
    button.selected = !button.selected;
    [_inputTextView resignFirstResponder];
    [_recordButton resignFirstResponder];
    [_recordButton setSelected:NO];
    
    if (button.selected) {
        _state = ChatInputViewStateMore;
    }else {
        _state = ChatInputViewStateClose;
    }
    //此处调用
    [_moreButton becomeFirstResponder];
}

#pragma mark -
#pragma mark - public method

- (void)setAllItemStateDeselect
{
    _moreButton.selected = NO;
    _recordButton.selected = NO;
}

- (void)resetText
{
    [self.inputTextView reset];
}

//禁言模式
- (void)setIsForbidden:(BOOL)isForbidden {
    if (_isForbidden != isForbidden) {
        _isForbidden = isForbidden;
        
        if (_isForbidden) {
            [self.inputTextView resignFirstResponder];
            [self.recordButton resignFirstResponder];
            [self.moreButton resignFirstResponder];
            self.inputTextView.text = @"主讲人开启禁言，暂不能发言";
            self.inputTextView.textColor = [UIColor colorWithRed:194/255.0 green:194/255.0 blue:194/255.0 alpha:1];
        } else {
            self.inputTextView.textColor = [UIColor blackColor];
            [self resetText];
        }
        
        self.inputTextView.userInteractionEnabled = !_isForbidden;
        _recordButton.enabled = !_isForbidden;
        _moreButton.enabled = !_isForbidden;
    }
}

#pragma mark -
#pragma mark - AutoFitTextView delegate
- (void)autoFitTextViewDidChangeFrame:(AutoFitTextView *)autoFitTextView
{
    _textViewBack.height = _inputTextView.height + 20;
    _seperatorBottom.bottom = _textViewBack.height;
    self.height = _textViewBack.height;
    _recordButton.bottom = _textViewBack.height - 5;
    _moreButton.bottom = _textViewBack.height - 5;
    if (_delegate && [_delegate respondsToSelector:@selector(inputViewDidChangeFrame:)]) {
        [_delegate inputViewDidChangeFrame:self];
    }
}

- (BOOL)shouldReturn
{
    if (_delegate && [_delegate respondsToSelector:@selector(inputViewShouldReturn)]) {
        return [_delegate inputViewShouldReturn];
    }else {
        return YES;
    }
}

@end
