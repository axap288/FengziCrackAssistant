//
//  FZHomeScrollImageView.h
//  CrackAssistant
//
//  Created by enalex on 14-5-7.
//  Copyright (c) 2014年 疯子. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FZHomeScrollImageViewDelegate <NSObject>

- (void)homeScrollImageViewDidSelected:(NSInteger)selectedIndex;

@end

@interface FZHomeScrollImageView : UIView <UIScrollViewDelegate>

@property (assign, nonatomic) id<FZHomeScrollImageViewDelegate> delegate;

// 设定滚动视图图片
- (void)setScrollImageViewImage:(NSArray *)imageArray;

@end
