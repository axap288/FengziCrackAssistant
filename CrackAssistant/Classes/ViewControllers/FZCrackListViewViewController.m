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
        m1.name = @"flappy bird";
        m1.fileName = @"app1";
        m1.downloadUrl = @"http://60.220.196.205/cdn.baidupcs.com/file/71067fbd9c8347f61a068c45eaab6dcb?xcode=7057de888f5b5e426fe7c8f796cc8fc9c1ff80696170e02a&fid=103343628-250528-3152335705&time=1397649235&sign=FDTAXER-DCb740ccc5511e5e8fedcff06b081203-0GTwNkkF7fHzediuvqxosAGqFzU%3D&to=cb&fm=Q,B,T,nc&newver=1&expires=1397649835&rt=sh&r=642203731&logid=3914459495&sh=1&vuk=151445773&fn=Flappy%20Bird-v1.2-Locophone.ipa&wshc_tag=0&wsiphost=ipdbm";
        m1.iD = [NSString stringWithFormat:@"%d",m1.hash];
        [array addObject:m1];
        
        FZGameFile *m2 = [[FZGameFile alloc] init];
        m2.name = @"Doodle_Jump_Race";
        m2.fileName = @"app2";
        m2.downloadUrl = @"http://qd.baidupcs.com/file/dbc86f3ef444d4a4905f0279c89825b5?xcode=90416ca096d4d0a4106516e74abda0edcc49be0693571206&fid=103343628-250528-382013696562502&time=1397649394&sign=FDTAXER-DCb740ccc5511e5e8fedcff06b081203-3alZ6hJ731ATmmDzy2Z%2F1oafvDw%3D&to=qb&fm=Q,B,T,nc&newver=1&expires=1397649994&rt=sh&r=907954548&logid=2486665437&sh=1&vuk=151445773&fn=Doodle_Jump_Race-v1.1.1-Orbicos.ipa";
        m2.iD = [NSString stringWithFormat:@"%d",m2.hash];
        [array addObject:m2];
        
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
    FZGameFile *model = [array objectAtIndex:[indexPath row]];
    cell.textLabel.text = model.name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FZGameFile *model = [array objectAtIndex:indexPath.row];
    [downloadManager addDownloadToList:model];
}

-(void)pushdownloadList
{
    FZdownloadViewController *downloadVc = [[FZdownloadViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:downloadVc animated:YES];
}


@end
