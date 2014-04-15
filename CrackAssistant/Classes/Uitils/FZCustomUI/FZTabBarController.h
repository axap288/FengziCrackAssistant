//
//  FZTabBarController.h
//  CrackAssistant
//
//  Created by yuan fang on 11-5-23.
//
//

#import <Foundation/Foundation.h>


@interface FZTabBarController : UITabBarController {
    
	NSMutableArray *buttons;
	UIImageView *slideBg;
    UIScrollView *backScrollView;
    int currentSelectedIndex;
    int lastSelected;
    BOOL initFlg;
}

@property (nonatomic, assign) int currentSelectedIndex;
@property (nonatomic, assign) int lastSelected;
@property (nonatomic, assign) BOOL initFlg;
@property (nonatomic, retain) NSMutableArray *buttons;
@property (nonatomic, retain) UIScrollView *backScrollView;

//- (void)hideRealTabBar;
- (void)customTabBar;
- (void)selectedTab:(UIButton *)button;

@end
