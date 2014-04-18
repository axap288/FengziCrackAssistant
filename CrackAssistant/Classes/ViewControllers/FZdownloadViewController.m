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
    [tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview: tableview];
}

-(void)viewDidAppear:(BOOL)animated
{
//    downloadList = downloadManager.downloadingQueue;
//    waitingList = downloadManager.waitDownloadQueue;
//    suspendList = downloadManager.suspendDownloadQueue;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.

    return [downloadList count];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"下载中";
    }
    if (section == 1) {
        return @"等待中";
    }
    return nil;
}
 */



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    FZDownloadListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            NSArray *nib =   [[NSBundle mainBundle] loadNibNamed:@"downloadListCell" owner:self options:nil];
            cell = (FZDownloadListCell *)[nib objectAtIndex:0];
            
//            UIButton *controlbutton = cell.controlButton;
//            [controlbutton setTitle:@"暂停" forState:UIControlStateNormal];
//            [controlbutton addTarget:self action:@selector(stopDownloadAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    
        FZGameFile *gamefile = [downloadList objectAtIndex:indexPath.row];
        UIButton *controlbutton = cell.controlButton;
        [controlbutton setBackgroundColor:[UIColor orangeColor]];
        controlbutton.tag = indexPath.row;
        cell.downloadProgress.progressTintColor = [UIColor orangeColor];

    if (gamefile.state == downloading) {
        [controlbutton setTitle:@"暂停" forState:UIControlStateNormal];
        [controlbutton addTarget:self action:@selector(stopDownloadAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.statelabel.text = @"正在下载";
    }
    if (gamefile.state == suspend) {
        [controlbutton setTitle:@"继续" forState:UIControlStateNormal];
        [controlbutton addTarget:self action:@selector(restartDownloadAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.statelabel.text = @"暂停下载";
    }
    if (gamefile.state == waitting) {
        [controlbutton setTitle:@"移除" forState:UIControlStateNormal];
        [controlbutton addTarget:self action:@selector(removeWaittingdAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.statelabel.text = @"排队等待";
    }
    
        cell.filename.text = gamefile.name;
        cell.downladRate.text = [NSString stringWithFormat:@"%@/%@",[FZCommonUitils getFileSizeString:gamefile.receviedSize],[FZCommonUitils getFileSizeString:gamefile.fileSize]];
        float filesize = [FZCommonUitils getFileSizeNumber:gamefile.fileSize];
        float receivedSize = [FZCommonUitils getFileSizeNumber:gamefile.receviedSize];
//        [cell.downloadProgress setProgress:receivedSize/filesize];
        [cell.downloadProgress setProgress:receivedSize/filesize];
        if (cell.downloadProgress.progress == 1.0f) {
            cell.downloadProgress.progress = 0.0f;
        }
    /*
    if (indexPath.section == 1) {
        if (!cell) {
            NSArray *nib =   [[NSBundle mainBundle] loadNibNamed:@"downloadListCell" owner:self options:nil];
            cell = (FZDownloadListCell *)[nib objectAtIndex:0];
        }
        
        UIButton *controlbutton = cell.controlButton;
        [controlbutton setTitle:@"移除" forState:UIControlStateNormal];
        [controlbutton addTarget:self action:@selector(removeWaittingdAction:) forControlEvents:UIControlEventTouchUpInside];
        controlbutton.tag = indexPath.row;

        
        FZGameFile *gamefile = [waitingList objectAtIndex:indexPath.row];
        cell.filename.text = gamefile.name;
        cell.downladRate.text = [NSString stringWithFormat:@"%@/%@",[FZCommonUitils getFileSizeString:gamefile.receviedSize],[FZCommonUitils getFileSizeString:gamefile.fileSize]];
        float filesize = [FZCommonUitils getFileSizeNumber:gamefile.fileSize];
        float receivedSize = [FZCommonUitils getFileSizeNumber:gamefile.receviedSize];

    }
     */
    /*
    if (indexPath.section == 2) {
        if (!cell) {
            NSArray *nib =   [[NSBundle mainBundle] loadNibNamed:@"downloadListCell" owner:self options:nil];
            cell = (FZDownloadListCell *)[nib objectAtIndex:0];
            
            
            //            UIButton *controlbutton = cell.controlButton;
            //            [controlbutton setTitle:@"暂停" forState:UIControlStateNormal];
            //            [controlbutton addTarget:self action:@selector(stopDownloadAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        UIButton *controlbutton = cell.controlButton;
        [controlbutton setTitle:@"继续" forState:UIControlStateNormal];
        [controlbutton addTarget:self action:@selector(restartDownloadAction:) forControlEvents:UIControlEventTouchUpInside];
        controlbutton.tag = indexPath.row;
        
        FZGameFile *gamefile = [suspendList objectAtIndex:indexPath.row];
        cell.filename.text = gamefile.name;
        cell.downladRate.text = [NSString stringWithFormat:@"%@/%@",[FZCommonUitils getFileSizeString:gamefile.receviedSize],[FZCommonUitils getFileSizeString:gamefile.fileSize]];
        float filesize = [FZCommonUitils getFileSizeNumber:gamefile.fileSize];
        float receivedSize = [FZCommonUitils getFileSizeNumber:gamefile.receviedSize];
        [cell.downloadProgress setProgress:receivedSize/filesize];
    }
     */
    return cell;
}


-(void)stopDownloadAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger index = [button tag];
    FZGameFile *model = [downloadList objectAtIndex:index];
    [downloadManager stopDownloadUseURL:model.downloadUrl];
}

-(void)restartDownloadAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger index = [button tag];
    FZGameFile *model = [downloadList objectAtIndex:index];
    [downloadManager restartDownloadUseURL:model.downloadUrl];
}
-(void)removeWaittingdAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger index = [button tag];
    FZGameFile *model = [downloadList objectAtIndex:index];
    [downloadManager removeOneWaittingUseURL:model.downloadUrl];
}

/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        FZGameFile *model = [downloadList objectAtIndex:indexPath.row];
        [downloadManager stopDownloadWithGameId:model.iD];
    }
    if (indexPath.section == 2) {
        FZGameFile *model = [suspendList objectAtIndex:indexPath.row];
        [downloadManager restartDownloadWithGameId:model.iD];
    }
    

}
*/

#pragma mark -
-(void)refreshTableView
{
    //刷新表格
    downloadList = [[downloadManager.downloadingQueue arrayByAddingObjectsFromArray:downloadManager.suspendDownloadQueue] arrayByAddingObjectsFromArray:downloadManager.waitDownloadQueue];
//    waitingList = downloadManager.waitDownloadQueue;
//    suspendList = downloadManager.suspendDownloadQueue;
    [tableview reloadData];

}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end
