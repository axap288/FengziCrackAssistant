//
//  FZTabBarController.h
//  CrackAssistant
//
//  Created by yuan fang on 11-5-23.
//
//

#import <Foundation/Foundation.h>


@interface FZTabBarController : UITabBarController

@property (nonatomic, assign) int currentSelectedIndex;
@property (nonatomic, assign) int lastSelected;
@property (nonatomic, assign) BOOL tabIsHidden;
@property (nonatomic, retain) NSMutableArray *buttons;
@property (nonatomic, retain) UIImageView *tabBarBackGroundView;

- (void)customTabBar;
- (void)selectedTab:(UIButton *)button;
- (void)showTabBar:(BOOL)show withAnimation:(BOOL)animated;

@end
