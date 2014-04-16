//
//  FZCrackListViewViewController.m
//  CrackAssistant
//
//  Created by LiuNian on 14-4-15.
//
//

#import "FZCrackListViewViewController.h"
#import "FZdownloadViewController.h"
#import "FZDownloadManager.h"
#import "FZGame.h"
#import "FZdownloadViewController.h"

@interface FZCrackListViewViewController ()
{
    NSMutableArray *array;
    FZDownloadManager *downloadManager;
    UITableView *tableview;
}

@end

@implementation FZCrackListViewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        array = [NSMutableArray array];
        //测试数据
        FZGameFile *m1 = [[FZGameFile alloc] init];
        m1.name = @"app1";
        m1.fileName = @"app1";
        m1.downloadUrl = @"http://www.fengzigame.com/uploadfile/ipa/%E5%8F%A3%E8%A2%8B%E4%BF%9D%E5%8D%AB-1.0.ipa";
        m1.iD = [NSString stringWithFormat:@"%d",m1.hash];
        [array addObject:m1];
        
        FZGameFile *m2 = [[FZGameFile alloc] init];
        m2.name = @"app2";
        m2.fileName = @"app2";
        m2.downloadUrl = @"http://www.fengzigame.com/uploadfile/ipa/%E6%B0%B8%E6%81%92%E6%88%98%E5%A3%AB2.ipa";
        m2.iD = [NSString stringWithFormat:@"%d",m2.hash];
        [array addObject:m2];
        
        FZGameFile *m3 = [[FZGameFile alloc] init];
        m3.name = @"app3";
        m3.downloadUrl = @"http://www.fengzigame.com/uploadfile/ipa/%E4%B8%93%E6%89%93%E8%84%B8%20%E5%85%8D%E8%B4%B9%20%E7%B2%BE%E7%AE%80%E7%89%88.ipa";
        m3.fileName = @"app3";
        m3.iD = [NSString stringWithFormat:@"%d",m3.hash];
        [array addObject:m3];
        
        downloadManager = [FZDownloadManager getShareInstance];
        }
    return self;
}

- (void)viewDidLoad
{
    
//    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"下载列表" style:UIBarButtonItemStylePlain target:self action:@select(pushdownloadList)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(pushdownloadList)];
    self.navigationItem.rightBarButtonItem =rightItem;
    UITableView *tv = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableview = tv;
    tableview.dataSource = self;
    tableview.delegate = self;
    [self.view addSubview:tableview];
}

- (void)didReceiveMemoryWarning
{
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
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    FZGame *model = [array objectAtIndex:[indexPath row]];
    cell.textLabel.text = model.name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FZGame *model = [array objectAtIndex:indexPath.row];
    [downloadManager addDownloadToList:model];
}

-(void)pushdownloadList
{
    FZdownloadViewController *downloadVc = [[FZdownloadViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:downloadVc animated:YES];
}


@end
