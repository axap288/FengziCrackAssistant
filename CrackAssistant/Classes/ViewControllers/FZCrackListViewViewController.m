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
#import "FZGameFile.h"
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
        m1.name = @"91手机助手";
        m1.fileName = @"app1";
        m1.downloadUrl = @"http://bcs.91rb.com/rbreszy/msoft/91assistant_v3.2.8_2.ipa";
        m1.iD = [NSString stringWithFormat:@"%d",m1.hash];
        [array addObject:m1];
        
        FZGameFile *m2 = [[FZGameFile alloc] init];
        m2.name = @"春雨医生";
        m2.fileName = @"app3";
        m2.downloadUrl = @"http://bcs.91rb.com/rbreszy/iphone/soft/2014/4/2/ce1ba0b8b8254baca79ef6c7fb5e2bba/com.chunyu.SymptomChecker_4.7.10325_4.7.1_635320447319931250.ipa";
        m2.iD = [NSString stringWithFormat:@"%d",m2.hash];
        [array addObject:m2];
        
        FZGameFile *m3 = [[FZGameFile alloc] init];
        m3.name = @"旅游攻略";
        m3.fileName = @"app4";
        m3.downloadUrl = @"http://bcs.91rb.com/rbreszy/iphone/soft/2014/4/11/f146984e29b44b9eadde85b23c348dbc/cn.mafengwo.www_6.0.1_6.0.1_635328241513209463.ipa";
        m3.iD = [NSString stringWithFormat:@"%d",m3.hash];
        [array addObject:m3];
        
        FZGameFile *m4 = [[FZGameFile alloc] init];
        m4.name = @"天天酷跑";
        m4.fileName = @"app5";
        m4.downloadUrl = @"http://bcs.91rb.com/rbreszy/iphone/soft/2014/3/14/8cfe010d07154991a3b36ead425be1ae/com.xiaor.KuPaTool_2.0.0_2.0.0_635304095451126072.ipa";
        m4.iD = [NSString stringWithFormat:@"%d",m4.hash];
        [array addObject:m4];
        
        downloadManager = [FZDownloadManager getShareInstance];
//        [downloadManager setMaxDownLoad:3];
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
    FZGameFile *model = [array objectAtIndex:[indexPath row]];
    cell.textLabel.text = model.name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FZGameFile *model = [[array objectAtIndex:indexPath.row] copy];
    [downloadManager addDownloadToList:model];
    [self pushdownloadList];
    
}

-(void)pushdownloadList
{
    FZdownloadViewController *downloadVc = [[FZdownloadViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:downloadVc animated:YES];
}


@end
