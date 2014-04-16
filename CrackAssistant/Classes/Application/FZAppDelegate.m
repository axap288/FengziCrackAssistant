//
//  FZAppDelegate.m
//  CrackAssistant
//
//  Created by LiuNian on 14-4-9.
//
//

#import "FZAppDelegate.h"
#import "FZMainViewController.h"
#import "FZCrackViewController.h"
#import "FZdownloadViewController.h"
#import "FZSearchViewController.h"
#import "FZmoreViewController.h"

@implementation FZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //首页
    FZMainViewController *mainvc = [[FZMainViewController alloc] init];
    mainvc.title = @"首页";
    UINavigationController *mainNavCtrl = [[UINavigationController alloc] initWithRootViewController:mainvc];
    //破解
    FZCrackViewController *crackvc = [[FZCrackViewController alloc] init];
    crackvc.title = @"破解";
    //下载
    FZdownloadViewController *dlvc = [[FZdownloadViewController alloc] init];
    dlvc.title = @"下载";
    //搜索
    FZSearchViewController *searchvc = [[FZSearchViewController alloc] init];
    searchvc.title = @"搜索";
    //更多
    FZmoreViewController *morevc = [[FZmoreViewController alloc] init];
    morevc.title = @"更多";
    
    
    // UITabBarController初始化
    self.tabBarController = [[FZTabBarController alloc] init];
    self.tabBarController.viewControllers = @[mainNavCtrl, crackvc, dlvc, searchvc, morevc];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.tabBarController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
