//
//  FZGameDetailViewController.m
//  CrackAssistant
//
//  Created by enalex on 14-4-16.
//  Copyright (c) 2014年 疯子. All rights reserved.
//

#import "FZGameDetailViewController.h"

@interface FZGameDetailViewController ()

@end

@implementation FZGameDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // self.view.frame = CGRectMake(0, 0, 320, 416 + 88 + 49);
    self.baseTableView.backgroundColor = [UIColor grayColor];
    
//    UIButton *topButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
//    topButton.backgroundColor = [UIColor blueColor];
//    [self.view addSubview:topButton];
//    
//    UIButton *bottomButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 386, 320, 30)];
//    bottomButton.backgroundColor = [UIColor redColor];
//    [self.view addSubview:bottomButton];
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
    return 20;
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

@end
