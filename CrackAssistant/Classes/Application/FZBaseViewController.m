//
//  FZBaseViewController.m
//  CrackAssistant
//
//  Created by yuan fang on 14-4-14.
//
//

#import "FZBaseViewController.h"
#import "FZCommonUitils.h"
#import "FZAppDelegate.h"

@interface FZBaseViewController ()

@end

@implementation FZBaseViewController

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor colorWithRed:0xee/255.0 green:0xee/255.0 blue:0xee/255.0 alpha:1.0];
    
    // 创建返回按钮
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    barButton.frame = CGRectMake(0, 0, 50, 25);
    barButton.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    barButton.contentMode = UIViewContentModeCenter;

    [barButton setImage:Nav_back_button_normal_bg forState:UIControlStateNormal];
    [barButton setImage:Nav_back_button_selected_bg forState:UIControlStateHighlighted];
    
    [barButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    // 创建按钮项目
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showTabBar:(BOOL)show withAnimation:(BOOL)animated
{
    FZAppDelegate *appDelegate = [FZCommonUitils getApplicationDelegate];
    [appDelegate.tabBarController showTabBar:show withAnimation:animated];
}

// 返回按钮事件
- (void)backButtonClicked
{
//    // 取消网络请求回调
//    if (self.requestHash) {
//        [[WMInterfaceServer getShareInstance] cancleBaseRequestBlock:self.requestHash];
//    }
    
    // 弹栈处理
    [self.navigationController popViewControllerAnimated:YES];
}

@end
