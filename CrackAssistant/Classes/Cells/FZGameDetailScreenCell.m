//
//  FZGameDetailScreenCell.m
//  CrackAssistant
//
//  Created by enalex on 14-5-14.
//  Copyright (c) 2014年 疯子. All rights reserved.
//

#import "FZGameDetailScreenCell.h"
#import "UIImageView+WebCache.h"

#define kLeftMarginWidth 67
#define kRightMarginWidth 5

@interface FZGameDetailScreenCell ()

@property (strong, nonatomic) UIScrollView *imageScrollView;
@property (assign, nonatomic) CGPoint scrollStratPoint;

@end

@implementation FZGameDetailScreenCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *gameDetailSrceen = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 190, 15)];
        gameDetailSrceen.backgroundColor = [UIColor clearColor];
        gameDetailSrceen.textColor = UIColorFromRGB(14, 14, 14);
        gameDetailSrceen.font = [UIFont systemFontOfSize:13];
        gameDetailSrceen.text = @"游戏截图";
        [self addSubview:gameDetailSrceen];
        
        // Initialization code
        self.imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, 320, 270)];
        self.imageScrollView.pagingEnabled = NO;
        self.imageScrollView.backgroundColor = [UIColor clearColor];
        self.imageScrollView.showsHorizontalScrollIndicator = NO;
        self.imageScrollView.delegate = self;
        self.imageScrollView.bounces = YES;
        self.imageScrollView.decelerationRate = 0.7f;
        self.imageScrollView.scrollsToTop = NO;
        [self addSubview:self.imageScrollView];
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImage *cellNormalImage = Cell_normal_bg;
        cellNormalImage = [cellNormalImage stretchableImageWithLeftCapWidth:0 topCapHeight:2];
        
        UIImage *cellSelectedImage = Cell_normal_bg;
        cellSelectedImage = [cellSelectedImage stretchableImageWithLeftCapWidth:0 topCapHeight:2];
        
        self.backgroundView = [[UIImageView alloc] initWithImage:cellNormalImage];
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:cellSelectedImage];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setScrollViewImage:(NSArray *)imageArray
{
    float originX = kLeftMarginWidth;
    
    if (imageArray.count > 0) {
        // 设定图片
        self.imageScrollView.contentSize = CGSizeMake(180 * imageArray.count + 10 * (imageArray.count - 1) + kLeftMarginWidth + kRightMarginWidth, 240);
        for (int i = 0; i < imageArray.count; i++) {
            
            UIImageView *productView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, 5, 165, 270)];
            
            // 图片
            [productView setImageWithURL:[NSURL URLWithString:[[imageArray objectAtIndex:i] objectForKey:@"url"]]
                                     placeholderImage:nil];
            

            productView.tag = 100 + i;
            productView.userInteractionEnabled = YES;
            
            [self.imageScrollView addSubview:productView];
            originX = originX + productView.frame.size.width + 5;
        }
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.scrollStratPoint = scrollView.contentOffset;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate
        && scrollView.contentOffset.x > 0
        && scrollView.contentOffset.x < scrollView.contentSize.width - 320) {
        
        CGPoint scrollEndPoint = scrollView.contentOffset;
        if (scrollEndPoint.x - _scrollStratPoint.x > 0) {
            int page = (scrollEndPoint.x - kLeftMarginWidth) / 190;
            int offectX = page * 190 + kLeftMarginWidth + 10;
            [scrollView setContentOffset:CGPointMake(offectX, 0) animated:YES];
            
        } else {
            int page = (scrollEndPoint.x - kLeftMarginWidth) / 190 + 1;
            int offectX = page * 190 - kLeftMarginWidth + 10;
            [scrollView setContentOffset:CGPointMake(offectX, 0) animated:YES];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (!scrollView.decelerating
        && scrollView.contentOffset.x > 0
        && scrollView.contentOffset.x < scrollView.contentSize.width - 320) {
        
        CGPoint scrollEndPoint = scrollView.contentOffset;
        if (scrollEndPoint.x - _scrollStratPoint.x > 0) {
            int page = (scrollEndPoint.x - kLeftMarginWidth) / 190;
            int offectX = page * 190 + kLeftMarginWidth + 10;
            [scrollView setContentOffset:CGPointMake(offectX, 0) animated:YES];
            
        } else {
            int page = (scrollEndPoint.x - kLeftMarginWidth) / 190 + 1;
            int offectX = page * 190 - kLeftMarginWidth + 10;
            [scrollView setContentOffset:CGPointMake(offectX, 0) animated:YES];
        }
    }
}

@end
