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
        downloadManager = [FZDownloadManager getShareInstance];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:RefreshDownloadNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableViewCell:) name:didReceiverefreshNotification object:nil];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    downloadList = [downloadManager.downloadingQueue copy];
    
    tableview = [[UITableView alloc] initWithFrame:self.view.frame];
    [tableview setDelegate:self];
    [tableview setDataSource:self];
    [tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview: tableview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self refreshTableViewCell:nil];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            //游戏名称
            UILabel *gameNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(48.f, 16.f, 169.f, 21.f)];
            [gameNameLabel setTag:1101];
            [gameNameLabel setTextColor:[UIColor blackColor]];
            [gameNameLabel setBackgroundColor:[UIColor clearColor]];
            [gameNameLabel setFont:[UIFont systemFontOfSize:17]];
            [cell.contentView addSubview:gameNameLabel];
            //当前下载/文件大小
            UILabel *downloadRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(48.f, 45.f, 103.f, 21.f)];
            [downloadRateLabel setTag:1102];
            [downloadRateLabel setTextColor:[UIColor lightGrayColor]];
            [downloadRateLabel setBackgroundColor:[UIColor clearColor]];
            [downloadRateLabel setFont:[UIFont systemFontOfSize:12]];
            [cell.contentView addSubview:downloadRateLabel];
            //当前状态文字
            UILabel *downloadStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(169.f, 45.f, 48.f, 21.f)];
            [downloadStateLabel setTag:1103];
            [downloadStateLabel setTextColor:[UIColor lightGrayColor]];
            [downloadStateLabel setBackgroundColor:[UIColor clearColor]];
            [downloadStateLabel setFont:[UIFont systemFontOfSize:12]];
            [cell.contentView addSubview:downloadStateLabel];

            //下载进度条
            UIProgressView *downloadProcess = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
            [downloadProcess setTag:1104];
            downloadProcess.progressTintColor = [UIColor orangeColor];
            downloadProcess.frame = CGRectMake(1.f,74,323.f,3.0f);
            downloadProcess.progress=0.0f;
            [cell.contentView addSubview:downloadProcess];
            
            //按钮
            UIButton *controlbutton = [UIButton buttonWithType:UIButtonTypeCustom];
            controlbutton.frame = CGRectMake(237.0, 23.0f, 73.0, 30.0f);
            [controlbutton setTag:1105];
            [cell.contentView addSubview:controlbutton];
        }
    
    [self updateCellView:cell withIndex:indexPath];

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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


-(void)clickCellButtonAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    UILabel *value = (UILabel *)[button viewWithTag:4444];
    FZGameFile *gamefile = [downloadList objectAtIndex:[value.text integerValue]];
    switch (gamefile.state) {
        case downloading:
            [downloadManager stopDownloadUseURL:gamefile.downloadUrl];
            break;
        case suspend:
            [downloadManager restartDownloadUseURL:gamefile.downloadUrl];
            break;
        case waitting:
            [downloadManager removeOneWaittingUseURL:gamefile.downloadUrl];
            break;
        default:
            break;
    }
}

-(void)updateCellView:(UITableViewCell *)cell withIndex:(NSIndexPath *)indexPath
{
    UILabel *gameNameLabel = (UILabel *)[cell.contentView viewWithTag:1101];
    UILabel *downloadRateLabel = (UILabel *)[cell.contentView viewWithTag:1102];
    UILabel *downloadStateLabel = (UILabel *)[cell.contentView viewWithTag:1103];
    UIProgressView *downloadProcess = (UIProgressView *)[cell.contentView viewWithTag:1104];
    UIButton *controlbutton = (UIButton *)[cell.contentView viewWithTag:1105];
    
    FZGameFile *gamefile = [downloadList objectAtIndex:indexPath.row];
    
    UILabel *indexlabel = [[UILabel alloc] init];//不显示，只作为传值使用
    indexlabel.tag = 4444;
    indexlabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    [controlbutton addSubview:indexlabel];
    [controlbutton addTarget:self action:@selector(clickCellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (gamefile.state == downloading) {
        [controlbutton setTitle:@"暂停" forState:UIControlStateNormal];
        [controlbutton setBackgroundColor:[UIColor orangeColor]];
        downloadStateLabel.text = @"正在下载";
    }
    if (gamefile.state == suspend) {
        [controlbutton setTitle:@"继续" forState:UIControlStateNormal];
        [controlbutton setBackgroundColor:[UIColor lightGrayColor]];
        downloadStateLabel.text = @"暂停下载";
    }
    if (gamefile.state == waitting) {
        [controlbutton setTitle:@"移除" forState:UIControlStateNormal];
        [controlbutton setBackgroundColor:[UIColor darkGrayColor]];
        downloadStateLabel.text = @"等待下载";
    }
    
    gameNameLabel.text = gamefile.name;
    downloadRateLabel.text = [NSString stringWithFormat:@"%@/%@",[FZCommonUitils getFileSizeString:gamefile.receviedSize],[FZCommonUitils getFileSizeString:gamefile.fileSize]];
    
    float filesize = [FZCommonUitils getFileSizeNumber:gamefile.fileSize];
    float receivedSize = [FZCommonUitils getFileSizeNumber:gamefile.receviedSize];
    if (filesize == 0 || receivedSize == 0) {
        [downloadProcess setProgress:0];
    }else{
        [downloadProcess setProgress:receivedSize/filesize];
    }
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

-(void)refreshTableViewCell:(NSNotification *)notification
{
    @synchronized(downloadList)
    {
        for (int i = 0; i < [downloadList count]; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            UITableViewCell *cell = (UITableViewCell *)[tableview cellForRowAtIndexPath:indexPath];
//            [self updateCellView:cell withIndex:indexPath];
//            [tableview reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self updateCellView:cell withIndex:indexPath];
            
            if ([downloadList count] !=0) {
                FZGameFile *obj = (FZGameFile*)[downloadList objectAtIndex:0];
                NSLog(@"vc downloadList object state:%d",obj.state);
            }

        }

    }
}


-(void)refreshTableView
{
    //刷新表格
    dispatch_async(dispatch_get_main_queue(), ^{
        downloadList = downloadManager.downloadingQueue;
        [tableview reloadData];
    });

}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end
