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
#import "FZCommonUitils.h"
#import "FZInterfaceServer.h"
#import "JSONKit.h"
#import "UIImageView+WebCache.h"



#define SectionView_bg_image [UIImage imageNamed:@"fz_crackview_sectionview_bg.png"]
#define SectionView_logo1_image [UIImage imageNamed:@"fz_crackview_sectionview_logo1.png"]
#define SectionView_logo2_image [UIImage imageNamed:@"fz_crackview_sectionview_logo2.png"]
#define Cell_button_close_image [UIImage imageNamed:@"fz_crackview_cell_close.png"]
#define Cell_button_open_image [UIImage imageNamed:@"fz_crackview_cell_open.png"]
#define Cell_button_crack_image [UIImage imageNamed:@"fz_crackview_cell_button_crack.png"]
#define Cell_button_start_image [UIImage imageNamed:@"fz_crackview_cell_button_start.png"]
#define Cell_button_recover_image [UIImage imageNamed:@"fz_crackview_cell_button_recover.png"]
#define crackVerButton_bg_image [UIImage imageNamed:@"fz_crackview_button_bg_crackVer.png"]
#define generalVerButton_bg_image [UIImage imageNamed:@"fz_crackview_button_bg_ generalVer.png"]


@interface FZCrackListViewViewController ()
{
    FZDownloadManager *downloadManager;
    NSUInteger selectCellAtlocalGame;
    UIButton *selectButtonAtLocalGame;
    FZInterfaceServer *interfaceServer;
}
@property (strong,nonatomic) UITableView *tableview;
@property (strong,nonatomic) NSMutableArray *localGamesArray; //设备中的游戏列表
@property (strong,nonatomic) NSMutableArray *crackGamesArray; //破解游戏

@end

@implementation FZCrackListViewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        selectCellAtlocalGame = 0;
        downloadManager = [FZDownloadManager getShareInstance];
        interfaceServer = [FZInterfaceServer getShareInstance];

//        [downloadManager setMaxDownLoad:3];
        }
    return self;
}

- (void)viewDidLoad
{
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    [self getRemoteCrackGames];
    [self findlocalGames];
    
    CGRect tableviewCgrect = self.view.frame;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
         tableviewCgrect = CGRectMake(0, 20, self.view.frame.size.width,self.view.frame.size.height - 20 - 49);//tabbar高度：40
    }
    
    self.tableview = [[UITableView alloc] initWithFrame:tableviewCgrect style:UITableViewStylePlain];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    [self.view addSubview:self.tableview];
}

- (void)didReceiveMemoryWarning
{
    // Dispose of any resources that can be recreated.
}


-(void)findlocalGames
{
    NSArray *test = [NSArray arrayWithObjects:@"com.glu.ewarriors2",@"com.popcap.ios.chs.PVZ2",@"com.kiloo.subwaysurfers",nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:test forKey:@"data"];
    
     self.localGamesArray = [NSMutableArray array];
    
    //接口调用
    [interfaceServer loadUsefulGameSaveFile:dic withSuccessBlock:^(id responseObject) {
        NSDictionary *responseDict = [responseObject objectFromJSONString];
        NSArray *result = [responseDict allValues];
        [result enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *content = obj;
            
             FZGameFile *fzGame = [[FZGameFile alloc] init];
            fzGame.name = [content objectForKey:@"title"];
            fzGame.version = [content objectForKey:@"version"];
            fzGame.downloadNum = [content objectForKey:@"loadnum"];
            fzGame.thumbnail = [content objectForKey:@"thumb"];
            NSLog(@"%@",fzGame.name);
//            [temp addObject:fzGame];
            [self.localGamesArray addObject:fzGame];
    }];
    [self.tableview reloadData];
    } withFailureBlock:^(NSString *errorMessage) {
        NSLog(@"errorMessage:%@",errorMessage);
    }];
}

-(void)getRemoteCrackGames
{
    self.crackGamesArray = [NSMutableArray array];
    
    FZGameFile *m4 = [[FZGameFile alloc] init];
    m4.name = @"天天酷跑";
    m4.fileName = @"app5";
    m4.downloadUrl = @"http://bcs.91rb.com/rbreszy/iphone/soft/2014/3/14/8cfe010d07154991a3b36ead425be1ae/com.xiaor.KuPaTool_2.0.0_2.0.0_635304095451126072.ipa";
    [self.crackGamesArray addObject:m4];
    
    FZGameFile *m5 = [[FZGameFile alloc] init];
    m5.name = @"美团商家";
    m5.fileName = @"app6";
    m5.downloadUrl = @"http://bcs.91rb.com/rbreszy/iphone/soft/2014/4/18/4040196358234421bb30f3b01ace5bb8/com.meituan.imerchantbiz_2.1.0_2.1.0_635334388847033750.ipa";
    [self.crackGamesArray addObject:m5];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowsNumber = 0;
    if (section == 0) {
        rowsNumber = [self.localGamesArray count];
    }else if (section == 1){
        rowsNumber = [self.crackGamesArray count];
    }
    return rowsNumber;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView  *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 323.f, 41.f)];
    UIImage *bg_image = SectionView_bg_image;
    bg_image = [bg_image stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:sectionView.frame];
    bgView.image = bg_image;
    [sectionView addSubview:bgView];
    
    if (section == 0) {
        UIView  *localGamesSectionView = sectionView;
        
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 105, 25)];
        //图标
        UIImageView *logoview = [[UIImageView alloc] initWithImage:SectionView_logo1_image];
        logoview.frame = CGRectMake(0, 0, 25, 25);
        [titleView addSubview:logoview];
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 3, 70, 20)];
        titleLabel.text = @"设备中";
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.font = [UIFont systemFontOfSize:19];
        [titleView addSubview:titleLabel];
        
        titleView.center = localGamesSectionView.center;
        [localGamesSectionView addSubview:titleView];
        return localGamesSectionView;
    }else if (section == 1)
    {
        UIView  *crackGamesSectionView = sectionView;
        
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 105, 25)];
        
        //图标
        UIImageView *logoview = [[UIImageView alloc] initWithImage:SectionView_logo2_image];
        logoview.frame = CGRectMake(0, 0, 25, 25);
        [titleView addSubview:logoview];
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 3, 80, 20)];
        titleLabel.text = @"破解游戏";
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:19];
        titleLabel.textColor = [UIColor darkGrayColor];
        [titleView addSubview:titleLabel];
        
        titleView.center = crackGamesSectionView.center;
        [crackGamesSectionView addSubview:titleView];

        return crackGamesSectionView;
    }
    
    return nil;
}

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 41.0f;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UIView *Contentview = [self makeContentCellView];
        
        UIView *operationPanelView = [self makeOperationPanelView];
 
        [cell.contentView addSubview:Contentview];
        [cell.contentView addSubview:operationPanelView];
    }
    
    switch (indexPath.section) {
        //设备中
        case 0:
        {
            if ([[self.localGamesArray objectAtIndex:[indexPath row]] isKindOfClass:[FZGameFile class]]) {
                
                UIView *contentView = [[cell.contentView subviews] objectAtIndex:0];
                UIView *operationPanelView = [[cell.contentView subviews] objectAtIndex:1];
                
                UIImageView *thumbnailView = (UIImageView *)[contentView viewWithTag:2001];
                UILabel *gameTitle = (UILabel *)[contentView viewWithTag:2002];
                UILabel *scoreLabel = (UILabel *)[contentView viewWithTag:2003];
                UILabel *detailLabel = (UILabel *)[contentView viewWithTag:2004];
                UIButton *openPulldownButton = (UIButton *)[contentView viewWithTag:2005];
                [openPulldownButton setHidden:NO];
                [contentView setHidden:NO];
                [operationPanelView setHidden:YES];

                FZGameFile *model = [self.localGamesArray objectAtIndex:[indexPath row]];
                gameTitle.text = model.name;
//                thumbnailView.image = [UIImage image];
                [thumbnailView setImageWithURL:[NSURL URLWithString:model.thumbnail] placeholderImage:[UIImage imageNamed:@"fz_placeholder.png"]];
                scoreLabel.text = [NSString stringWithFormat:@"下载次数 %@",model.downloadNum];
                detailLabel.text = [NSString stringWithFormat:@"版本 %@ | %@M |",model.version,@"64.67"];
                
                //此label仅作为传参数用
                UILabel *parameter = [[UILabel alloc] init];
                parameter.tag = 4444;
                parameter.text = [NSString stringWithFormat:@"%d",indexPath.row];
                [openPulldownButton addSubview:parameter];
                [openPulldownButton addTarget:self action:@selector(openPullDownCellAction:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                UIView *operationPanelView = [[cell.contentView subviews] objectAtIndex:1];
                UIView *contentView = [[cell.contentView subviews] objectAtIndex:0];
                [contentView setHidden:YES];
                [operationPanelView setHidden:NO];
            }

        }
            break;
        //游戏列表
        case 1:
        {
            UIView *operationPanelView = [[cell.contentView subviews] objectAtIndex:1];
            UIView *contentView = [[cell.contentView subviews] objectAtIndex:0];
            UIImageView *thumbnailView = (UIImageView *)[contentView viewWithTag:2001];
            UILabel *gameTitle = (UILabel *)[contentView viewWithTag:2002];
            UILabel *scoreLabel = (UILabel *)[contentView viewWithTag:2003];
            UILabel *detailLabel = (UILabel *)[contentView viewWithTag:2004];
            UIButton *openPulldownButton = (UIButton *)[contentView viewWithTag:2005];
            [openPulldownButton setHidden:YES];
            [contentView setHidden:NO];
            [operationPanelView setHidden:YES];

            
            FZGameFile *model = [self.crackGamesArray objectAtIndex:[indexPath row]];
            gameTitle.text = model.name;
            thumbnailView.image = [UIImage imageNamed:@"fz_placeholder.png"];
            scoreLabel.text = [NSString stringWithFormat:@"得分 %@分",@"2.3"];
            detailLabel.text = [NSString stringWithFormat:@"版本 %@ | %@M |",@"1.00",@"64.67"];
        }
            break;
        default:
            break;
    }
    return cell;
    
}

// 列表视图
-(UIView *)makeContentCellView
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 68)];
    //缩略图
    UIImageView *thumbnailView = [[UIImageView alloc] init];
    thumbnailView.frame = CGRectMake(13, 10, 50, 50);
    thumbnailView.tag = 2001;
    [contentView addSubview:thumbnailView];
    //标题
    UILabel *gameTitle = [[UILabel alloc] initWithFrame:CGRectMake(77, 10, 172, 21)];
    gameTitle.backgroundColor = [UIColor clearColor];
    gameTitle.textColor = [UIColor darkGrayColor];
    gameTitle.font = [UIFont systemFontOfSize:15];
    gameTitle.tag = 2002;
    [contentView addSubview:gameTitle];
    //得分
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(77, 28, 80, 21)];
    scoreLabel.backgroundColor = [UIColor clearColor];
    scoreLabel.textColor = UIColorFromHex(0x0099cc);
    scoreLabel.font = [UIFont systemFontOfSize:11];
    scoreLabel.tag = 2003;
    [contentView addSubview:scoreLabel];
    //细节
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(77, 47, 152, 16)];
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.textColor = [UIColor darkGrayColor];
    detailLabel.font = [UIFont systemFontOfSize:11];
    detailLabel.tag = 2004;
    [contentView addSubview:detailLabel];
    
    //下拉框的按钮
    UIButton *openPulldownButton = [UIButton buttonWithType:UIButtonTypeCustom];
    openPulldownButton.frame = CGRectMake(263, 11, 52, 52);
    openPulldownButton.tag = 2005;
    [openPulldownButton setImage:Cell_button_close_image forState:UIControlStateNormal];
    [contentView addSubview:openPulldownButton];
    
    return contentView;
}

//恢复、破解、打开 - 视图
-(UIView *)makeOperationPanelView
{
    UIView *opView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 68)];
    
    UIButton *crackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    crackButton.frame = CGRectMake(61, 14, 25, 25);
    crackButton.tag = 2006;
    [crackButton setImage:Cell_button_crack_image forState:UIControlStateNormal];
    [opView addSubview:crackButton];
    
    UIButton *recoverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    recoverButton.frame = CGRectMake(148, 14, 25, 25);
    recoverButton.tag = 2007;
    [recoverButton setImage:Cell_button_recover_image forState:UIControlStateNormal];
    [opView addSubview:recoverButton];
    
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startButton.frame = CGRectMake(228, 14, 25, 25);
    startButton.tag = 2008;
    [startButton setImage:Cell_button_start_image forState:UIControlStateNormal];
    [opView addSubview:startButton];
    
    UILabel *crackButtonTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 42, 34, 21)];
    crackButtonTitle.backgroundColor = [UIColor clearColor];
    crackButtonTitle.textColor = [UIColor redColor];
    crackButtonTitle.font = [UIFont systemFontOfSize:15];
    crackButtonTitle.text = @"破解";
    [opView addSubview:crackButtonTitle];
    
    UILabel *recoverButtonTitle = [[UILabel alloc] initWithFrame:CGRectMake(146, 42, 34, 21)];
    recoverButtonTitle.backgroundColor = [UIColor clearColor];
    recoverButtonTitle.textColor = [UIColor redColor];
    recoverButtonTitle.font = [UIFont systemFontOfSize:15];
    recoverButtonTitle.text = @"恢复";
    [opView addSubview:recoverButtonTitle];
    
    UILabel *startButtonTitle = [[UILabel alloc] initWithFrame:CGRectMake(226, 42, 34, 21)];
    startButtonTitle.backgroundColor = [UIColor clearColor];
    startButtonTitle.textColor = [UIColor redColor];
    startButtonTitle.font = [UIFont systemFontOfSize:15];
    startButtonTitle.text = @"启动";
    [opView addSubview:startButtonTitle];
    
    return opView;
}

//无限金币版、普通版 - 视图
-(void)makeSelectVersionPanelView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 68)];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    FZGameFile *model = [[array objectAtIndex:indexPath.row] copy];
    [downloadManager addDownloadToList:model];
    [self pushdownloadList];
     */
}
//下拉弹出cell
-(void)openPullDownCellAction:(id)sender
{
    if (selectCellAtlocalGame) {
        [self.localGamesArray removeObjectAtIndex:selectCellAtlocalGame];
        NSArray *indexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:selectCellAtlocalGame inSection:0]];
        [self.tableview beginUpdates];
        [self.tableview deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
        [self.tableview endUpdates];
        
        [selectButtonAtLocalGame setImage:Cell_button_close_image forState:UIControlStateNormal];
    }
    
    UIButton *button = (UIButton *)sender;
    UILabel *parameter = (UILabel *)[button viewWithTag:4444];
    NSUInteger cellIndex = [parameter.text integerValue];
    
    if (cellIndex + 1 == selectCellAtlocalGame) {
        selectCellAtlocalGame = 0;
    }else{
        [button setImage:Cell_button_open_image forState:UIControlStateNormal];
        selectCellAtlocalGame = cellIndex + 1;
        [self.localGamesArray insertObject:@"operation Panel" atIndex:selectCellAtlocalGame];
        
        NSArray *indexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:selectCellAtlocalGame inSection:0]];
        [self.tableview beginUpdates];
        [self.tableview insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        [self.tableview endUpdates];
        
        selectButtonAtLocalGame = button;
    }
}

-(void)pushdownloadList
{
    FZdownloadViewController *downloadVc = [[FZdownloadViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:downloadVc animated:YES];
}


@end
