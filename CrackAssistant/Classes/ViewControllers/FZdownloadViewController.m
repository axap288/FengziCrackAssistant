//
//  FZdownloadViewController.m
//  CrackAssistant
//
//  Created by LiuNian on 14-4-14.
//
//

#import "FZdownloadViewController.h"
#import "FZCommonUitils.h"


@interface FZdownloadViewController ()

@end

@implementation FZdownloadViewController
{
    FZDownloadManager *downloadManager;
    NSArray *downloadList;
    NSArray *waitingList;
    UITableView *tableview;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        downloadManager = [FZDownloadManager getShareInstance];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:RefreshDownloadNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    tableview = [[UITableView alloc] initWithFrame:self.view.frame];
    [tableview setDelegate:self];
    [tableview setDataSource:self];
    [self.view addSubview: tableview];
}

-(void)viewDidAppear:(BOOL)animated
{
    downloadList = downloadManager.downloadingQueue;
    waitingList = downloadManager.waitDownloadQueue;
    [tableview reloadData];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger number = 0;
    if (section == 0) {
        number = [waitingList count];
    }
    if (section == 1) {
        number = [downloadList count];
    }
    return number;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"等待队列";
    }
    if (section == 1) {
        return @"下载队列";
    }
    return nil;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    FZDownloadListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (indexPath.section == 1) {
        if (!cell) {
            NSArray *nib =   [[NSBundle mainBundle] loadNibNamed:@"downloadListCell" owner:self options:nil];
            cell = (FZDownloadListCell *)[nib objectAtIndex:0];
            
//            UIButton *controlbutton = cell.controlButton;
//            [controlbutton setTitle:@"暂停" forState:UIControlStateNormal];
//            [controlbutton addTarget:self action:@selector(stopDownloadAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        FZGameFile *gamefile = [downloadList objectAtIndex:indexPath.row];
        cell.filename.text = gamefile.name;
        cell.downladRate.text = [NSString stringWithFormat:@"%@/%@",[FZCommonUitils getFileSizeString:gamefile.receviedSize],[FZCommonUitils getFileSizeString:gamefile.fileSize]];
        float filesize = [FZCommonUitils getFileSizeNumber:gamefile.fileSize];
        float receivedSize = [FZCommonUitils getFileSizeNumber:gamefile.receviedSize];
        [cell.downloadProgress setProgress:receivedSize/filesize];
    }
    if (indexPath.section == 0) {
        if (!cell) {
            NSArray *nib =   [[NSBundle mainBundle] loadNibNamed:@"downloadListCell" owner:self options:nil];
            cell = (FZDownloadListCell *)[nib objectAtIndex:0];
            
//            UIButton *controlbutton = cell.controlButton;
//            [controlbutton setTitle:@"暂停" forState:UIControlStateNormal];
//            [controlbutton addTarget:self action:@selector(stopDownloadAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        FZGameFile *gamefile = [waitingList objectAtIndex:indexPath.row];
        cell.filename.text = gamefile.name;
        cell.downladRate.text = [NSString stringWithFormat:@"%@/%@",[FZCommonUitils getFileSizeString:gamefile.receviedSize],[FZCommonUitils getFileSizeString:gamefile.fileSize]];
        float filesize = [FZCommonUitils getFileSizeNumber:gamefile.fileSize];
        float receivedSize = [FZCommonUitils getFileSizeNumber:gamefile.receviedSize];
        [cell.downloadProgress setProgress:receivedSize/filesize];
    }
    return cell;
}


-(void)stopDownloadAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    FZDownloadListCell *cell = (FZDownloadListCell *)button.superview.superview;
    NSIndexPath *indexPath = [tableview indexPathForCell:cell];
    NSLog(@"index %d",indexPath.row);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        FZGameFile *model = [waitingList objectAtIndex:indexPath.row];
        if (model.state == suspend)
        {
            [downloadManager restartDownloadWithGameId:model.iD];
        }
    }
    
    if (indexPath.section == 1)
    {
        FZGameFile *model = [downloadList objectAtIndex:indexPath.row];
        if(model.state == downloading)
        {
            [downloadManager stopDownloadWithGameId:model.iD];
        }
    }
    

}


#pragma mark -
-(void)refreshTableView
{
    //刷新表格
    downloadList = downloadManager.downloadingQueue;
    [tableview reloadData];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end
