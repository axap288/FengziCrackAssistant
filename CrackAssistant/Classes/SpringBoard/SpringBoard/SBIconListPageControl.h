/*
 *     Generated by class-dump 3.3.4 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2011 by Steve Nygard.
 */

#import "UIPageControl.h"

@interface SBIconListPageControl : UIPageControl
{
    id _delegate;
}

@property(nonatomic) id <SBIconListPageControlDelegate> delegate; // @synthesize delegate=_delegate;
- (void)setFrame:(struct CGRect)arg1;
- (id)_pageIndicatorCurrentImageForPage:(int)arg1;
- (id)_pageIndicatorImageForPage:(int)arg1;
- (void)touchesEnded:(id)arg1 withEvent:(id)arg2;
- (void)touchesMoved:(id)arg1 withEvent:(id)arg2;
- (void)touchesBegan:(id)arg1 withEvent:(id)arg2;

@end

