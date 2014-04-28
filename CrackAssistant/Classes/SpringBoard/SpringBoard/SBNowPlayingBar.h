/*
 *     Generated by class-dump 3.3.4 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2011 by Steve Nygard.
 */

#import "NSObject.h"

#import "SBIconViewDelegate-Protocol.h"
#import "SBSwitcherPopoverWindowControllerDelegate-Protocol.h"
#import "UIPopoverControllerDelegate-Protocol.h"

@class MPAudioDeviceController, MPAudioVideoRoutingActionSheet, MPAudioVideoRoutingPopoverController, SBAirPlayBarView, SBAppSwitcherVolumeSlider, SBApplication, SBNowPlayingBarView, UIButton, UIViewController;

@interface SBNowPlayingBar : NSObject <SBIconViewDelegate, UIPopoverControllerDelegate, SBSwitcherPopoverWindowControllerDelegate>
{
    SBNowPlayingBarView *_barView;
    SBAirPlayBarView *_airPlayView;
    MPAudioVideoRoutingActionSheet *_airPlayActionSheet;
    UIViewController *_airPlayController;
    SBAppSwitcherVolumeSlider *_volumeSlider;
    UIButton *_airPlayButton;
    SBApplication *_nowPlayingApp;
    int _scanDirection;
    MPAudioDeviceController *_audioDeviceController;
    MPAudioVideoRoutingPopoverController *_audioRoutingPopoverController;
    BOOL _audioRoutingPopoverVisible;
    BOOL _showPopoverWhenRotationComplete;
    struct BKSDisplayBrightnessTransaction *_brightnessTransaction;
}

- (void)viewControllerRequestsDismissal:(id)arg1;
- (void)switcherPopoverController:(id)arg1 didRotateFromInterfaceOrientation:(int)arg2;
- (void)switcherPopoverController:(id)arg1 willRotateToOrientation:(int)arg2 duration:(double)arg3;
- (void)popoverControllerDidDismissPopover:(id)arg1;
- (void)audioDeviceControllerMediaServerDied:(id)arg1;
- (void)audioDeviceControllerAudioRoutesChanged:(id)arg1;
- (void)backlightLevelChanged;
- (void)iconTouchBegan:(id)arg1;
- (BOOL)iconShouldAllowTap:(id)arg1;
- (void)iconTapped:(id)arg1;
- (BOOL)_isAirPlayOn;
- (void)_showAudioRoutingPopover;
- (BOOL)_shouldShowAirPlayButton;
- (void)_dismissAirPlayDetail;
- (void)_airPlayButtonHit:(id)arg1;
- (void)_brightnessSliderTouchEnded:(id)arg1;
- (void)_brightnessSliderChanged:(id)arg1;
- (void)_iapExtendedModeChanged:(id)arg1;
- (void)_updateAudioRouteDisplay:(BOOL)arg1;
- (void)_updateNowPlayingButtonImages;
- (void)_nowPlayingInfoChanged;
- (void)_updateNowPlayingInfo;
- (void)_updateNowPlayingApp;
- (void)_fifteenSecondSkip:(id)arg1;
- (void)_trackButtonDownSeek:(id)arg1;
- (void)_trackButtonDown:(id)arg1;
- (void)_trackButtonCancel:(id)arg1;
- (void)_trackButtonUp:(id)arg1;
- (void)_playButtonHit:(id)arg1;
- (void)_toggleButtonHit:(id)arg1;
- (void)_updateDisplay;
- (BOOL)shouldScrollCancelInContentForView:(id)arg1;
- (void)prepareToDisappear;
- (void)warmup;
- (void)viewAtIndexDidDisappear:(int)arg1;
- (void)viewAtIndexDidAppear:(int)arg1;
- (void)setVisible:(BOOL)arg1;
- (int)scanDirection;
- (id)views;
- (void)dealloc;
- (id)init;

@end

