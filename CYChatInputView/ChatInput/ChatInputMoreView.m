//
//  ChatInputMoreView.m
//  ChunyuClinic
//
//  Created by 高天翔 on 15/9/29.
//  Copyright © 2015年 lvjianxiong. All rights reserved.
//

#import "ChatInputMoreView.h"
#import "UIView+Subviews.h"
#import "cyUIKit.h"
#import "CYGlobalNavigatorMetrics.h"

@interface ChatInputMoreView ()
@end

#define kButtonWidth 62
#define kButtonHeight 85
#define kRatio ((viewWidth() - kButtonWidth * 4)/18)
#define kOriginLeft (kRatio * 3)
#define kDivid (kRatio * 4)
#define kPageControlTag 2000

@implementation ChatInputMoreView

- (instancetype)initWithFrame:(CGRect)frame type:(ChatInputViewType)type delegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _delegate = delegate;
        _type = type;
        [self createViewWithFrame:frame];
    }
    return self;
}

- (void)createViewWithFrame:(CGRect)frame
{
    self.backgroundColor = [UIColor whiteColor];
 
    UIScrollView* itemScrollView = ({
    
        UIScrollView* scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scrollview.showsHorizontalScrollIndicator = NO;
        scrollview.delegate = self;
        scrollview.pagingEnabled = YES;
        scrollview;
    });
    [self addSubview:itemScrollView];
    
    NSArray* buttons = [self buttonTypeWithChatViewType:_type];
    
    for (NSInteger i = 0 ; i < buttons.count; i ++) {
        
        NSInteger weight = i / 8;
        
        NSInteger row = (i / 4) % 2;
        
        ChatInputViewType type = [buttons[i] integerValue];
        
        UIButton* button = [self createButtonByButtonType:type];
        
        button.frame = CGRectMake(kOriginLeft + (weight * itemScrollView.width) + (i%4)*(kButtonWidth + kDivid), 11 + row * (kButtonHeight + 7), kButtonWidth, kButtonHeight);
        
        [itemScrollView addSubview:button];
    }
    
    NSInteger page = ((buttons.count - 1) / 8 + 1) > 0 ? ((buttons.count - 1) / 8 + 1) : 1;
    itemScrollView.contentSize = CGSizeMake(frame.size.width * page, itemScrollView.height);
    
    UIPageControl* itemControl = ({
        
        UIPageControl* control = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 200, 25)];
        control.numberOfPages = page;
        control.currentPage = 0;
        control.hidesForSinglePage = YES;
        control.bottom = frame.size.height - 5;
        control.tag = kPageControlTag;
        control.left = (frame.size.width - control.width) / 2;
        control.pageIndicatorTintColor = RGBCOLOR_HEX(0xe2e2e2);
        control.currentPageIndicatorTintColor = RGBCOLOR_HEX(0x1C91E0);
        control;
    });
    [self addSubview:itemControl];
}

- (void)refreshWithType:(ChatInputViewType)type {
    _type = type;
    [self removeAllSubviews];
    [self createViewWithFrame:self.frame];
}

#pragma mark - 
#pragma mark - get button info

- (NSArray*)buttonTypeWithChatViewType:(ChatInputViewType)type
{
    NSMutableArray* array = [NSMutableArray array];
    if (type & ChatInputViewTypePhoto) {
        
        [array addObject:@(ChatInputViewTypePhoto)];
    }
    
    if (type & ChatInputViewTypeAlbum) {
        
        [array addObject:@(ChatInputViewTypeAlbum)];
    }
    
    if (type & ChatInputViewTypeMoulde) {
        
        [array addObject:@(ChatInputViewTypeMoulde)];
    }
    
    if (type & ChatInputViewTypeCoupon) {
        
        [array addObject:@(ChatInputViewTypeCoupon)];
    }
    
    if (type & ChatInputViewTypeProfile) {
        
        [array addObject:@(ChatInputViewTypeProfile)];
    }
    
    if (type & ChatInputViewTypeTopic) {
        
        [array addObject:@(ChatInputViewTypeTopic)];
    }
    
    if (type & ChatInputViewTypeAgain) {
        
        [array addObject:@(ChatInputViewTypeAgain)];
    }
    
    if (type & ChatInputViewTypeShowAppointment) {
        
        [array addObject:@(ChatInputViewTypeShowAppointment)];
    }
    
    if (type & ChatInputViewTypeAudio) {
        
        [array addObject:@(ChatInputViewTypeAudio)];
    }
    
    if (type & ChatInputViewTypeSpecialService) {
        
        [array addObject:@(ChatInputViewTypeSpecialService)];
    }
    
    if (type & ChatInputViewTypeAssistant) {
        
        [array addObject:@(ChatInputViewTypeAssistant)];
    }
    
    if (type & ChatInputViewTypeProposal) {
        
        [array addObject:@(ChatInputViewTypeProposal)];
    }
    return array;
}

- (NSDictionary*)buttonInfo:(ChatInputViewType)type
{
    switch (type) {
        case ChatInputViewTypePhoto:
        {
            return @{@"title":@"拍照", @"image":@"chatinput_photo"};
        }
            break;
        case ChatInputViewTypeAlbum:
        {
            return @{@"title":@"相册", @"image":@"chatinput_asset"};
        }
            break;
        case ChatInputViewTypeMoulde:
        {
            return @{@"title":@"模板", @"image":@"chatinput_modul"};
        }
            break;
        case ChatInputViewTypeCoupon:
        {
            return @{@"title":@"发优惠券", @"image":@"send_coupon"};
        }
            break;
        case ChatInputViewTypeProfile:
        {
            return @{@"title":@"多档案提醒", @"image":@"chatinput_profile"};
        }
            break;
        case ChatInputViewTypeTopic:
        {
            return @{@"title":@"发话题", @"image":@"chatinput_topic"};
        }
            break;
        case ChatInputViewTypeAgain:
        {
            return @{@"title":@"建议复诊", @"image":@"chatinput_again"};
        }
            break;
        case ChatInputViewTypeShowAppointment:
        {
            return @{@"title":@"门诊预约", @"image":@"chatinput_appointment"};
        }
            break;
        case ChatInputViewTypeSpecialService:
        {
            return @{@"title":@"特色服务", @"image":@"chatinput_special_service"};
        }
            break;
        case ChatInputViewTypeAssistant:
        {
            return @{@"title":@"转给助手", @"image":@"chatinput_assistant"};
        }
            break;
        case ChatInputViewTypeProposal:
        {
            return @{@"title":@"方案建议", @"image":@"chatinput_proposal"};
        }
            break;
        default:
            return @{};
            break;
    }
}

- (UIButton*)createButtonByButtonType:(ChatInputViewType)type
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    NSDictionary* buttonInfo = [self buttonInfo:type];
    
    [button setImage:[UIImage imageNamed:buttonInfo[@"image"]] forState:UIControlStateNormal];
    [button setTitle:buttonInfo[@"title"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 20, 0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(kButtonHeight - 15, -kButtonWidth, 0, 0)];
    [button setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    button.tag = type;
    
    return button;
}

- (void)itemButtonClicked:(id)sender
{
    UIButton* button = sender;
    if (_delegate && [_delegate respondsToSelector:@selector(moreItemButtonClicked:)]) {
        [_delegate moreItemButtonClicked:button.tag];
    }
}

#pragma mark -
#pragma mark - scrollview delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentSize.width / scrollView.width;
    CGFloat offsetX = scrollView.contentOffset.x;
    UIPageControl* control = [self viewWithTag:kPageControlTag];
    
    NSInteger currentPage = (offsetX + scrollView.width / 2) / scrollView.width;
    if (currentPage < 0) {
        currentPage = 0;
    }else if (currentPage > page){
        currentPage = page - 1;
    }
    
    control.currentPage = currentPage;
}

@end
