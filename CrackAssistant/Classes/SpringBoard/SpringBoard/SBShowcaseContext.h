/*
 *     Generated by class-dump 3.3.4 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2011 by Steve Nygard.
 */

#import "NSObject.h"

@interface SBShowcaseContext : NSObject
{
    int _appOrientation;
    int _showcaseOrientation;
    struct CGAffineTransform _portraitRelativeViewTransform;
    struct CGAffineTransform _currentReleativeViewTransform;
    BOOL _onSpringBoard;
    BOOL _onApp;
    float _offset;
}

@property(nonatomic) float offset; // @synthesize offset=_offset;
@property(nonatomic) BOOL onApp; // @synthesize onApp=_onApp;
@property(nonatomic) BOOL onSpringBoard; // @synthesize onSpringBoard=_onSpringBoard;
@property(nonatomic) struct CGAffineTransform currentReleativeViewTransform; // @synthesize currentReleativeViewTransform=_currentReleativeViewTransform;
@property(nonatomic) struct CGAffineTransform portraitRelativeViewTransform; // @synthesize portraitRelativeViewTransform=_portraitRelativeViewTransform;
@property(nonatomic) int showcaseOrientation; // @synthesize showcaseOrientation=_showcaseOrientation;
@property(nonatomic) int appOrientation; // @synthesize appOrientation=_appOrientation;

@end

