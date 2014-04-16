//
//  FZBaseTableViewController.m
//  CrackAssistant
//
//  Created by yuan fang on 14-4-14.
//
//

#import "FZBaseTableViewController.h"

@interface FZBaseTableViewController ()

@end

@implementation FZBaseTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.baseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
                                                      style:UITableViewStylePlain];
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.baseTableView.backgroundColor = [UIColor clearColor];
    self.baseTableView.showsVerticalScrollIndicator = NO;
    self.baseTableView.dataSource = self;
    self.baseTableView.delegate = self;
    [self.view addSubview:self.baseTableView];
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
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...    
    return cell;
}

@end
