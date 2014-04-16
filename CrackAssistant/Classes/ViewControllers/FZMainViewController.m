//
//  FZMainViewController.m
//  CrackAssistant
//
//  Created by LiuNian on 14-4-14.
//
//

#import "FZMainViewController.h"
#import "FZGameDetailViewController.h"
#import "FZAppDelegate.h"

@interface FZMainViewController ()

@end

@implementation FZMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    FZAppDelegate *appDelegate = (FZAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.tabBarController showTabbar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = @"abc";
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FZGameDetailViewController *gameDetailCtrl = [[FZGameDetailViewController alloc] init];
    gameDetailCtrl.hidesBottomBarWhenPushed = YES;
    
    FZAppDelegate *appDelegate = (FZAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.tabBarController hiddenTabbar];
    
    [self.navigationController pushViewController:gameDetailCtrl animated:YES];
}

@end
