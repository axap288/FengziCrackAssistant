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


@interface FZdownloadViewController ()

@end

@implementation FZdownloadViewController
{
    FZDownloadManager *downloadManager;
    NSArray *downloadList;
    UITableView *tableview;
    UIView *backgroundView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        downloadManager = [FZDownloadManager getShareInstance];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:RefreshDownloadNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableViewCell:) name:didReceiverefreshNotification object:nil];

    }
    return self;
}

-(void)loadView
{
    [super loadView];
    
    if (isIOS7) {
        UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, yOffectStatusBar)];
        statusBarView.backgroundColor = UIColorFromRGB(219, 83, 42);
        [self.view addSubview:statusBarView];
    }
    
    [self createTopButtons];
    [self createActionButtons];
//    [self createTableView];
    [self createEmprtyDataView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    downloadList = [downloadManager.downloadingQueue copy];
    
    /*
    tableview = [[UITableView alloc] initWithFrame:self.view.frame];
    [tableview setDelegate:self];
    [tableview setDataSource:self];
    [tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview: tableview];
     */
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

// 创建顶部按钮
- (void)createTopButtons
{
    //下载中
    UIButton *downloadingButton = [[UIButton alloc] initWithFrame:CGRectMake(7, yOffectStatusBar + 8, 103, 32)];
    [downloadingButton setBackgroundImage:Download_topbutton_normal_bg
                          forState:UIControlStateNormal];
//    [downloadingButton addTarget:self action:@selector(showGameListButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [downloadingButton setTitle:@"下载中" forState:UIControlStateNormal];
//    [downloadingButton setTintColor:UIColorFromRGB(57, 57, 57)];
    downloadingButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [downloadingButton setTitleColor:UIColorFromRGB(57, 57, 57) forState:UIControlStateNormal];
    downloadingButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:downloadingButton];
    
    // 已下载
    UIButton *downloadOverButton = [[UIButton alloc] initWithFrame:CGRectMake(109, yOffectStatusBar +8, 103, 32)];
    [downloadOverButton setBackgroundImage:Download_topbutton_normal_bg
                          forState:UIControlStateNormal];
    downloadOverButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [downloadOverButton setTitle:@"已下载" forState:UIControlStateNormal];
    [downloadOverButton setTitleColor:UIColorFromRGB(57, 57, 57) forState:UIControlStateNormal];
    [self.view addSubview:downloadOverButton];
    
    // 更新
    UIButton *updateButton = [[UIButton alloc] initWithFrame:CGRectMake(211, yOffectStatusBar + 8, 103, 32)];
    [updateButton setBackgroundImage:Download_topbutton_normal_bg
                            forState:UIControlStateNormal];
    updateButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [updateButton setTitle:@"更新" forState:UIControlStateNormal];
    [updateButton  setTitleColor:UIColorFromRGB(57, 57, 57) forState:UIControlStateNormal];
    [self.view addSubview:updateButton];
}
//操作及全部删除按钮
-(void)createActionButtons
{
    UIImageView *useCapacityIcon = [[UIImageView alloc] initWithImage:Download_usecapacity_icon];
    useCapacityIcon.frame = CGRectMake(8, yOffectStatusBar+58, 8, 8);
    [self.view addSubview:useCapacityIcon];
    
    UIImageView *usablecapacityIcon = [[UIImageView alloc] initWithImage:Download_usablecapacity_icon];
    usablecapacityIcon.frame = CGRectMake(82, yOffectStatusBar+58, 8, 8);
    [self.view addSubview:usablecapacityIcon];
    
    UILabel *useCapacitylabel = [[UILabel alloc] initWithFrame:CGRectMake(20, yOffectStatusBar + 52, 47, 21)];
    useCapacityIcon.tintColor = [UIColor blackColor];
    useCapacitylabel.text = @"已用1.8G";
    useCapacitylabel.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:useCapacitylabel];
    
    UILabel *usableCapacitylabel = [[UILabel alloc] initWithFrame:CGRectMake(93, yOffectStatusBar + 52, 47, 21)];
    usableCapacitylabel.font = [UIFont systemFontOfSize:10];
    usableCapacitylabel.text = @"剩余1.8G";
    [self.view addSubview:usableCapacitylabel];

    
    //操作按钮
    UIButton *actionButton = [[UIButton alloc] initWithFrame:CGRectMake(150, yOffectStatusBar +49, 77, 23)];
    [actionButton setBackgroundImage:Download_actionbutton_normal_bg
                                  forState:UIControlStateNormal];
    [actionButton setBackgroundImage:Download_actionbutton_click_bg
                            forState:UIControlStateHighlighted];
    actionButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [actionButton setTitle:@"操作" forState:UIControlStateNormal];
    [actionButton setTitleColor:UIColorFromRGB(57, 57, 57) forState:UIControlStateNormal];
    [self.view addSubview:actionButton];
    //删除按钮
    UIButton *alldelButton = [[UIButton alloc] initWithFrame:CGRectMake(237, yOffectStatusBar +49, 77, 23)];
    [alldelButton setBackgroundImage:Download_allDelbutton_normal_bg
                            forState:UIControlStateNormal];
    [alldelButton setBackgroundImage:Download_allDelbutton_click_bg
                            forState:UIControlStateHighlighted];
    alldelButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [alldelButton setTitle:@"全部删除" forState:UIControlStateNormal];
    [alldelButton setTitleColor:UIColorFromRGB(255, 255, 255) forState:UIControlStateNormal];
    [self.view addSubview:alldelButton];
    
    //分割线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, yOffectStatusBar + 80, 320, 1)];
    [line setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:line];
}

//创建表格
-(void)createTableView
{
    CGFloat tableHeigh = 487;
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(7, yOffectStatusBar + 81, 320, tableHeigh - 49)];
    [tableview setDelegate:self];
    [tableview setDataSource:self];
    [tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview: tableview];
}

-(void)createEmprtyDataView
{
    CGFloat backgroundViewHeigh = 149;
    
    backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, yOffectStatusBar + 81, 320.0f, backgroundViewHeigh - 49)];
    [backgroundView setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:backgroundView];

    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 28)];
    [icon setImage:Download_no_download_icon];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 69, 21)];
    label.text = @"暂无任何下载";
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:11];
    
    UIView *centerDisplayContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 109, 29)];
    [centerDisplayContent addSubview:icon];
    [centerDisplayContent addSubview:label];
    
    centerDisplayContent.center = backgroundView.center;
    NSLog(@"centerDispContent x:%f",centerDisplayContent.frame.origin.x);
    NSLog(@"centerDispContent y:%f",centerDisplayContent.frame.origin.y);
    
    NSLog(@"centerDispContent center:%f",centerDisplayContent.center.x);
    NSLog(@"centerDispContent center:%f",centerDisplayContent.center.y);
    
    NSLog(@"backgroundView width:%f",backgroundView.frame.size.width);
    NSLog(@"backgroundView height:%f",backgroundView.frame.size.height);
    
    NSLog(@"backgroundView center:%f",backgroundView.center.x);
    NSLog(@"backgroundView center:%f",backgroundView.center.y);

    
    [backgroundView addSubview:centerDisplayContent];
    
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
    return 89;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            //游戏名称
            UILabel *gameNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(71.f, 23.f, 169.f, 21.f)];
            [gameNameLabel setTag:1101];
            [gameNameLabel setTextColor:[UIColor blackColor]];
            [gameNameLabel setBackgroundColor:[UIColor clearColor]];
            [gameNameLabel setFont:[UIFont systemFontOfSize:12]];
            [cell.contentView addSubview:gameNameLabel];
            //当前下载/文件大小
            UILabel *downloadRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(71.f, 45.f, 103.f, 21.f)];
            [downloadRateLabel setTag:1102];
            [downloadRateLabel setTextColor:[UIColor lightGrayColor]];
            [downloadRateLabel setBackgroundColor:[UIColor clearColor]];
            [downloadRateLabel setFont:[UIFont systemFontOfSize:8]];
            [cell.contentView addSubview:downloadRateLabel];
            //当前状态文字
            UILabel *downloadStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(182.f, 45.f, 48.f, 21.f)];
            [downloadStateLabel setTag:1103];
            [downloadStateLabel setTextColor:[UIColor lightGrayColor]];
            [downloadStateLabel setBackgroundColor:[UIColor clearColor]];
            [downloadStateLabel setFont:[UIFont systemFontOfSize:8]];
            [cell.contentView addSubview:downloadStateLabel];
            
            //图标
            UIImageView *gameIconView = [[UIImageView alloc]initWithFrame:CGRectMake(14, 20, 49, 49)];
            [gameIconView setTag:1106];
            [gameIconView setBackgroundColor:[UIColor clearColor]];
            [cell.contentView addSubview:gameIconView];

            //下载进度条
            UIProgressView *downloadProcess = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
            [downloadProcess setTag:1104];
            downloadProcess.progressTintColor = [UIColor orangeColor];
            downloadProcess.frame = CGRectMake(1.f,86,323.f,2.0f);
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
