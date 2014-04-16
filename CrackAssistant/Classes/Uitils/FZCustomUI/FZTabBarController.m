//
//  FZTabBarController.m
//  CrackAssistant
//
//  Created by yuan fang on 11-5-23.
//
//

#import "FZTabBarController.h"

#define kButtonColor [UIColor colorWithRed:0.5921 green:0.0823 blue:0.0823 alpha:1.0]
#define kBackImageWidth 107
#define kScrollWidth 214
#define kLabelFont 11

@implementation FZTabBarController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self customTabBar];
}

- (void)customTabBar{
    
    // self.tabBar.hidden = YES;
    
    // TabBar自定义视图
	self.tabBarBackGroundView = [[UIImageView alloc] initWithFrame:self.tabBar.frame];
    self.tabBarBackGroundView.userInteractionEnabled = YES;
    
	//创建按钮
	int viewCount = self.viewControllers.count > 5 ? 5 : self.viewControllers.count;
	self.buttons = [NSMutableArray arrayWithCapacity:viewCount];
    
    //  按钮大小
	double buttonWidth = 320 / viewCount;
	double buttonHeight = self.tabBar.frame.size.height;
    
	for (int i = 0; i < viewCount; i++) {
        
        // 根据tabItem来设定button
		UIViewController *viewCtrl = [self.viewControllers objectAtIndex:i];
        
        // 创建按钮
		UIButton *tabButton = [UIButton buttonWithType:UIButtonTypeCustom];
		tabButton.frame = CGRectMake(i * buttonWidth, 0, buttonWidth, buttonHeight);
        tabButton.tag = i;
		tabButton.backgroundColor = [UIColor orangeColor];
        tabButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [tabButton setTitle:viewCtrl.tabBarItem.title forState:UIControlStateNormal];
        [tabButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [tabButton setBackgroundImage:[UIImage imageNamed:@"fz_tabbar_gray_bg@2x.png"]
                             forState:UIControlStateNormal];
        [tabButton setBackgroundImage:[UIImage imageNamed:@"fz_tabbar_gray_bg@2x.png"]
                             forState:UIControlStateHighlighted];
        [tabButton addTarget:self
                      action:@selector(selectedTab:)
            forControlEvents:UIControlEventTouchUpInside];
        tabButton.userInteractionEnabled = YES;
        
        // 添加按钮
		[self.buttons addObject:tabButton];
		[self.tabBarBackGroundView addSubview:tabButton];
	}
    
	// 添加背景视图
    // [self.view addSubview:self.tabBarBackGroundView];
    [self.tabBar insertSubview:self.tabBarBackGroundView atIndex:0];
    self.currentSelectedIndex = 1;
	[self selectedTab:[self.buttons objectAtIndex:0]];
}

- (void)selectedTab:(UIButton *)button{
    
	if (self.currentSelectedIndex != button.tag) {
        
        // 保存前次选择 
        self.lastSelected = self.currentSelectedIndex;
		self.currentSelectedIndex = button.tag;
		[self performSelector:@selector(slideTabBg:) withObject:button];
        
	}
}

- (void)slideTabBg:(UIButton *)button {
    
	[UIView beginAnimations:nil context:nil];  
	[UIView setAnimationDuration:0.1];
    
    // 选中按钮图片设定
    UIButton *currentSelectedBtn = [self.buttons objectAtIndex:self.currentSelectedIndex];
    switch (currentSelectedBtn.tag) {
            
        case 0:
            [currentSelectedBtn setBackgroundImage:[UIImage imageNamed:@"fz_tabbar_home_bg@2x.png"]
                                          forState:UIControlStateNormal];
            [currentSelectedBtn setBackgroundImage:[UIImage imageNamed:@"fz_tabbar_home_bg@2x.png"]
                                          forState:UIControlStateHighlighted];
            [currentSelectedBtn setTitle:@"" forState:UIControlStateNormal];
            break;
        case 1:
            [currentSelectedBtn setBackgroundImage:[UIImage imageNamed:@"fz_tabbar_crack_bg@2x.png"]
                                          forState:UIControlStateNormal];
            [currentSelectedBtn setBackgroundImage:[UIImage imageNamed:@"fz_tabbar_crack_bg@2x.png"]
                                          forState:UIControlStateHighlighted];
            [currentSelectedBtn setTitle:@"" forState:UIControlStateNormal];
            break;
        case 2:
            [currentSelectedBtn setBackgroundImage:[UIImage imageNamed:@"fz_tabbar_download_bg@2x.png"]
                                          forState:UIControlStateNormal];
            [currentSelectedBtn setBackgroundImage:[UIImage imageNamed:@"fz_tabbar_download_bg@2x.png"]
                                          forState:UIControlStateHighlighted];
            [currentSelectedBtn setTitle:@"" forState:UIControlStateNormal];
            break;
        case 3:
            [currentSelectedBtn setBackgroundImage:[UIImage imageNamed:@"fz_tabbar_search_bg@2x.png"]
                                          forState:UIControlStateNormal];
            [currentSelectedBtn setBackgroundImage:[UIImage imageNamed:@"fz_tabbar_search_bg@2x.png"]
                                          forState:UIControlStateHighlighted];
            [currentSelectedBtn setTitle:@"" forState:UIControlStateNormal];
            break;
        case 4:
            [currentSelectedBtn setBackgroundImage:[UIImage imageNamed:@"fz_tabbar_more_bg@2x.png"]
                                          forState:UIControlStateNormal];
            [currentSelectedBtn setBackgroundImage:[UIImage imageNamed:@"fz_tabbar_more_bg@2x.png"]
                                          forState:UIControlStateHighlighted];
            [currentSelectedBtn setTitle:@"" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    // 之前选中按钮的图片设定那个
    UIButton *lastSelectedBtn = [self.buttons objectAtIndex:_lastSelected];
    UIViewController *viewCtrl = [self.viewControllers objectAtIndex:_lastSelected];
    
    [lastSelectedBtn setTitle:viewCtrl.tabBarItem.title forState:UIControlStateNormal];
    [lastSelectedBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [lastSelectedBtn setBackgroundImage:[UIImage imageNamed:@"fz_tabbar_gray_bg@2x.png"]
                               forState:UIControlStateNormal];
    [lastSelectedBtn setBackgroundImage:[UIImage imageNamed:@"fz_tabbar_gray_bg@2x.png"]
                               forState:UIControlStateHighlighted];
    
	[UIView commitAnimations];
    
    self.selectedIndex = self.currentSelectedIndex;
}

- (void)hiddenTabbar
{
    self.tabBarBackGroundView.hidden = YES;
}

- (void)showTabbar
{
    self.tabBarBackGroundView.hidden = NO;
}

@end
