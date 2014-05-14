//
//  FZdownloadViewController.m
//  CrackAssistant
//
//  Created by LiuNian on 14-4-14.
//
//

#import "FZdownloadViewController.h"
#import "FZCommonUitils.h"
#import "UIImageView+WebCache.h"

@implementation FZdownloadViewController
{
    FZDownloadManager *downloadManager;
    NSArray *downloadList;          //下载中
    NSArray *downloadOverList;//下载结束
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selectedPageIndex = 1;
        downloadManager = [FZDownloadManager getShareInstance];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:downloadQueuedidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableViewCell:) name:didReceiverefreshNotification object:nil];

    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self refreshTableView];
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
    NSInteger rowNumber = 0;
    switch (self.selectedPageIndex) {
        case 1:
            rowNumber = [downloadList count];
            break;
        case 2:
            rowNumber = [downloadOverList count];
            break;
        default:
            break;
    }
    return rowNumber;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 89;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            switch (self.selectedPageIndex) {
                case 1:
                    [self drawCellForDownloadTableView:cell];
                    break;
                case 2:
                    [self drawCellForDownloadEndTableView:cell];
                    break;
                case 3:
                    [self drawCellForUpdateTableView:cell];
                    break;
                default:
                    break;
            }
        }
    
    switch (self.selectedPageIndex) {
        case 1:
            [self updateCellView:cell withIndex:indexPath];
            break;
        case 2:
#warning 未完成
        case 3:
#warning 未完成
        default:
            break;
    }
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
    switch (gamefile.downloadState) {
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
    UIImageView *gameIconView = (UIImageView *)[cell.contentView viewWithTag:1106];

    
    FZGameFile *gamefile = [downloadList objectAtIndex:indexPath.row];
    float filesize = [FZCommonUitils getFileSizeNumber:gamefile.fileSize];
    float receivedSize = [FZCommonUitils getFileSizeNumber:gamefile.receviedSize];
    float lastReceivedSize = [FZCommonUitils getFileSizeNumber:gamefile.last_receviedSize];
    
    UILabel *indexlabel = [[UILabel alloc] init];//不显示，只作为传值使用
    indexlabel.tag = 4444;
    indexlabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    [controlbutton addSubview:indexlabel];
    [controlbutton addTarget:self action:@selector(clickCellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (gamefile.downloadState == downloading) {
        [controlbutton setTitle:@"暂停" forState:UIControlStateNormal];
        [controlbutton setBackgroundColor:[UIColor orangeColor]];
        //downloadStateLabel.text = @"正在下载";
        
        float lastTime = (filesize - receivedSize) / (receivedSize - lastReceivedSize);//计算剩余下载时间
        NSString *timeIntervalStr = [NSString stringWithFormat:@"%02li:%02li:%02li",
                                     lround(floor(lastTime / 3600.)) % 100,
                                     lround(floor(lastTime / 60.)) % 60,
                                     lround(floor(lastTime)) % 60];
        downloadStateLabel.text = timeIntervalStr;

        
    }
    if (gamefile.downloadState == suspend) {
        [controlbutton setTitle:@"继续" forState:UIControlStateNormal];
        [controlbutton setBackgroundColor:[UIColor lightGrayColor]];
        downloadStateLabel.text = @"暂停下载";
    }
    if (gamefile.downloadState == waitting) {
        [controlbutton setTitle:@"移除" forState:UIControlStateNormal];
        [controlbutton setBackgroundColor:[UIColor darkGrayColor]];
        downloadStateLabel.text = @"等待下载";
    }
    
    gameNameLabel.text = gamefile.name;
    downloadRateLabel.text = [NSString stringWithFormat:@"%@/%@",[FZCommonUitils getFileSizeString:gamefile.receviedSize],[FZCommonUitils getFileSizeString:gamefile.fileSize]];
    [gameIconView setImageWithURL:[NSURL URLWithString:gamefile.thumbnail] placeholderImage:[UIImage imageNamed:@"fz_placeholder.png"]];

   
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

-(void)topButtonClicked:(id)sender
{
    [super topButtonClicked:sender];
    [self refreshTableView];
}

#pragma mark -

-(void)refreshTableViewCell:(NSNotification *)notification
{
    @synchronized(downloadList)
    {
        for (int i = 0; i < [downloadList count]; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            UITableViewCell *cell = (UITableViewCell *)[self.baseTableView cellForRowAtIndexPath:indexPath];
//            [self updateCellView:cell withIndex:indexPath];
//            [tableview reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self updateCellView:cell withIndex:indexPath];
            
            if ([downloadList count] !=0) {
                FZGameFile *obj = (FZGameFile*)[downloadList objectAtIndex:0];
            }

        }

    }
}


-(void)refreshTableView
{
    //刷新表格
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *currentList ;
        switch (self.selectedPageIndex) {
            case 1:
            {
                downloadList = downloadManager.downloadingQueue;
                currentList = downloadList;
            }
                break;
            case 2:
            {
                downloadOverList = downloadManager.overDownloadQueue;
                currentList = downloadOverList;
            }
                break;
            default:
                break;
        }
        
        if ([currentList count] == 0) {
            [self.baseTableView setHidden:YES];
            [self.nodataView setHidden:NO];
            
        }else{
            [self.baseTableView setHidden:NO];
            [self.nodataView setHidden:YES];
            [self.baseTableView reloadData];
        }
    });
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end
