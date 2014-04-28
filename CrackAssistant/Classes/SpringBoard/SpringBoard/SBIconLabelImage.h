/*
 *     Generated by class-dump 3.3.4 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2011 by Steve Nygard.
 */

#import "UIImage.h"

#import "SBCountedMapValue-Protocol.h"

@class SBIconLabelImageParameters;

@interface SBIconLabelImage : UIImage <SBCountedMapValue>
{
    SBIconLabelImageParameters *_parameters;
    struct CGPoint _maxSizeOffset;
}

+ (void)checkinLabelImage:(id)arg1;
+ (id)checkoutLabelImageForParameters:(id)arg1;
+ (id)_drawLabelImageForParameters:(id)arg1;
+ (id)_labelImageCountedMap;
+ (void)drawImageInRect:(struct CGRect)arg1 fromParameters:(id)arg2;
+ (struct CGRect)rectIncludingShadow:(BOOL)arg1 fromParameters:(id)arg2 constrainedToRect:(struct CGRect)arg3;
+ (struct CGRect)_rectIncludingShadow:(BOOL)arg1 withDrawing:(BOOL)arg2 inRect:(struct CGRect)arg3 fromParameters:(id)arg4;
@property(readonly, nonatomic) struct CGPoint maxSizeOffset; // @synthesize maxSizeOffset=_maxSizeOffset;
@property(readonly, nonatomic) SBIconLabelImageParameters *parameters; // @synthesize parameters=_parameters;
@property(readonly, nonatomic) id <NSCopying> countedMapKey;
- (void)dealloc;
- (id)initWithCGImage:(struct CGImage *)arg1 scale:(float)arg2 orientation:(int)arg3;
- (id)_initWithCGImage:(struct CGImage *)arg1 scale:(float)arg2 orientation:(int)arg3 parameters:(id)arg4 maxSizeOffset:(struct CGPoint)arg5;

@end

