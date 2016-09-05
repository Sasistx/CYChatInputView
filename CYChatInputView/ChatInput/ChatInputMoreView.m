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
@property (nonatomic, strong) NSArray* dataArray;
@end

#define kButtonWidth 62
#define kButtonHeight 85
#define kRatio ((viewWidth() - kButtonWidth * 4)/18)
#define kOriginLeft (kRatio * 3)
#define kDivid (kRatio * 4)
#define kPageControlTag 2000

@implementation ChatInputMoreView

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray*)dataArray delegate:(id)delegate{

    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
        _dataArray = [dataArray copy];
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
    
    for (NSInteger i = 0 ; i < _dataArray.count; i ++) {
        
        NSInteger weight = i / 8;
        
        NSInteger row = (i / 4) % 2;
        
        NSDictionary* buttonInfo = _dataArray[i];
        
        UIButton* button = [self createButtonByButtonInfo:buttonInfo indexTag:i];
        
        button.frame = CGRectMake(kOriginLeft + (weight * itemScrollView.width) + (i%4)*(kButtonWidth + kDivid), 11 + row * (kButtonHeight + 7), kButtonWidth, kButtonHeight);
        
        [itemScrollView addSubview:button];
    }
    
    NSInteger page = ((_dataArray.count - 1) / 8 + 1) > 0 ? ((_dataArray.count - 1) / 8 + 1) : 1;
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

- (void)refreshWithButtonInfo:(NSArray*)buttonInfo
{
    _dataArray = nil;
    _dataArray = [buttonInfo copy];
    [self removeAllSubviews];
    [self createViewWithFrame:self.frame];
}
 
// buttonInfo: @{@"title":@"拍照", @"image":@"chatinput_photo"}
- (UIButton*)createButtonByButtonInfo:(NSDictionary*)buttonInfo indexTag:(NSInteger)indexTag
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:buttonInfo[@"image"]] forState:UIControlStateNormal];
    [button setTitle:buttonInfo[@"title"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 20, 0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(kButtonHeight - 15, -kButtonWidth, 0, 0)];
    [button setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    button.tag = indexTag;
    return button;
}

- (void)itemButtonClicked:(id)sender
{
    UIButton* button = sender;
    if (_delegate && [_delegate respondsToSelector:@selector(moreItemButtonClicked:info:)]) {
        [_delegate moreItemButtonClicked:button.tag info:_dataArray[button.tag]];
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
