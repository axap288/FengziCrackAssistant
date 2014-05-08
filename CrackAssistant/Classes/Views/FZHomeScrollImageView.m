//
//  FZHomeScrollImageView.m
//  CrackAssistant
//
//  Created by enalex on 14-5-7.
//  Copyright (c) 2014年 疯子. All rights reserved.
//

#import "FZHomeScrollImageView.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"

#define kImageViewWidth 310.0
#define kImageViewHeight  130
#define kBigNum		1
#define kBannerChangeTitleTime 5.0f
#define kBannerAnimationTime 0.5f

@interface FZHomeScrollImageView ()

@property (strong, nonatomic) UIScrollView *scrollImageView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) NSArray *imageItems;
@property (assign, nonatomic) int cpage;
@property (strong, nonatomic) NSTimer *timer;

// 滚动图点击事件
- (void)didReceiveImageTapGesture:(UITapGestureRecognizer *)gesture;

@end

@implementation FZHomeScrollImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // ScrollView
        self.scrollImageView = [[UIScrollView alloc] initWithFrame:CGRectMake(5,
                                                                              5,
                                                                              frame.size.width - 10,
                                                                              frame.size.height - 10)];
        self.scrollImageView.pagingEnabled = YES;
        self.scrollImageView.backgroundColor = [UIColor clearColor];
        self.scrollImageView.showsHorizontalScrollIndicator = NO;
        self.scrollImageView.delegate = self;
        self.scrollImageView.bounces = YES;
        self.scrollImageView.decelerationRate = 0.7f;
        self.scrollImageView.scrollsToTop = NO;
        [self addSubview:self.scrollImageView];
        
        // PageControl
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height - 15, kImageViewWidth, 4)];
        self.pageControl.currentPage = 0;
        self.pageControl.pageIndicatorTintColor = [UIColor blackColor];
        [self addSubview:self.pageControl];
    }
    return self;
}

- (void)dealloc
{
    [self.timer invalidate];
}

#pragma mark -
#pragma mark Method
// 设定滚动视图图片
- (void)setScrollImageViewImage:(NSArray *)imageArray
{
    if (imageArray.count > 0) {
        
        // 图片地址数组
        self.imageItems = imageArray;
        // PageControl
        self.pageControl.numberOfPages = imageArray.count;
        
        // ScrollView左右各增加一个ImageView，偏移位置为320.
        self.scrollImageView.contentSize = CGSizeMake((imageArray.count) * kImageViewWidth,
                                                      self.scrollImageView.frame.size.height);
        self.scrollImageView.contentOffset = CGPointMake(0, 0);
        
        for (int i = 0; i < imageArray.count; i++) {
            
            UIImageView *productImage = (UIImageView *)[self.scrollImageView viewWithTag:900 + i];
            if (productImage == nil) {
                UIImageView *productImage = [[UIImageView alloc] initWithFrame:CGRectMake(kImageViewWidth * i,
                                                                                          0,
                                                                                          self.scrollImageView.frame.size.width,
                                                                                          self.scrollImageView.frame.size.height)];
                
                [productImage setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:i]]
                             placeholderImage:[UIImage imageNamed:@""]];
                productImage.userInteractionEnabled = YES;
                
                // 添加点击手势
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                             action:@selector(didReceiveImageTapGesture:)];
                tapGesture.numberOfTapsRequired = 1;
                [productImage addGestureRecognizer:tapGesture];
                
                // Tag
                productImage.tag = 900 + i;
                [self.scrollImageView addSubview:productImage];
            } else {
                productImage.image = nil;
                [productImage setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:i]]
                             placeholderImage:[UIImage imageNamed:@""]];
            }
        }
        
        // 设定初始page，启动Timer
        self.pageControl.currentPage = 0;
        [self performSelector:@selector(startBannerLoop) withObject:nil afterDelay:kBannerChangeTitleTime];
    }
}

// 启动定时器
- (void)startBannerLoop
{
    if ([self.timer isValid]) {
        [self.timer invalidate];
    }
    
    // Timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kBannerChangeTitleTime
                                                  target:self
                                                selector:@selector(scrollForceView)
                                                userInfo:nil
                                                 repeats:YES];
    
    [self.timer fire];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer
                                 forMode:NSRunLoopCommonModes];
}

- (void)scrollForceView
{
    CGPoint contentOffset = _scrollImageView.contentOffset;
    [UIView animateWithDuration:(kBannerAnimationTime)
                     animations:^{
                         
                         if (contentOffset.x == kImageViewWidth * (self.imageItems.count - 1)) {
                             [self.scrollImageView setContentOffset:CGPointMake(0, 0)];
                         } else {
                             self.scrollImageView.contentOffset = CGPointMake(contentOffset.x + kImageViewWidth, 0);
                         }
                         
                     } completion:^(BOOL finished) {
                    
                         CGPoint offset = _scrollImageView.contentOffset;
                         _cpage = (int)(offset.x / kImageViewWidth);
                         _pageControl.currentPage = _cpage;
                         
                     }];
}

// 滚动图点击事件
- (void)didReceiveImageTapGesture:(UITapGestureRecognizer *)gesture
{
    UIImageView *imageView = (UIImageView *)gesture.view;
    NSInteger index = imageView.tag % 900;
    
    // CallBack
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(homeScrollImageViewDidSelected:)]) {
        [self.delegate homeScrollImageViewDidSelected:index];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 滑动时取消Timer
    if ([self.timer isValid]) {
        [self.timer invalidate];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate) {
        // 滑动停止，开启Timer
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startBannerLoop) object:nil];
        [self performSelector:@selector(startBannerLoop) withObject:nil afterDelay:kBannerChangeTitleTime];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = _scrollImageView.contentOffset;
    _cpage = (int)(offset.x / kImageViewWidth);
    _pageControl.currentPage = _cpage;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.isDragging) {
        CGPoint offset = _scrollImageView.contentOffset;
        _cpage = (int)(offset.x / kImageViewWidth);
        _pageControl.currentPage = _cpage;
    }
}

@end
