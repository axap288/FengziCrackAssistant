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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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

@end
