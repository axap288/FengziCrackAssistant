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
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"



#define SectionView_bg_image [UIImage imageNamed:@"fz_crackview_sectionview_bg.png"]
#define SectionView_logo1_image [UIImage imageNamed:@"fz_crackview_sectionview_logo1.png"]
#define SectionView_logo2_image [UIImage imageNamed:@"fz_crackview_sectionview_logo2.png"]
#define Cell_button_close_image [UIImage imageNamed:@"fz_crackview_cell_close.png"]
#define Cell_button_open_image [UIImage imageNamed:@"fz_crackview_cell_open.png"]
#define Cell_button_crack_image [UIImage imageNamed:@"fz_crackview_cell_button_crack.png"]
#define Cell_button_start_image [UIImage imageNamed:@"fz_crackview_cell_button_start.png"]
#define Cell_button_recover_image [UIImage imageNamed:@"fz_crackview_cell_button_recover.png"]
#define Cell_button_recover_disable_image [UIImage imageNamed:@"fz_crackview_cell_button_recover_disable.png"]
#define crackVerButton_bg_image [UIImage imageNamed:@"fz_crackview_button_bg_crackVer.png"]
#define generalVerButton_bg_image [UIImage imageNamed:@"fz_crackview_button_bg_ generalVer.png"]

#define Cell_button_installCrackAPP_normal_image [UIImage imageNamed:@"fz_crackview_cell_installButton1_normal.png"]
#define Cell_button_installCrackAPP_selected_image [UIImage imageNamed:@"fz_crackview_cell_installButton1_selected.png"]

#define Cell_button_installAPP_normal_image [UIImage imageNamed:@"fz_crackview_cell_installButton_normal.png"]
#define Cell_button_installAPP_selected_image [UIImage imageNamed:@"fz_crackview_cell_installButton_selected.png"]

#define Cell_button_install_close_image [UIImage imageNamed:@"fz_crackview_cell_install_close.png"]
#define Cell_button_install_open_image [UIImage imageNamed:@"fz_crackview_cell_install_open.png"]



@interface FZCrackListViewViewController ()
{
    FZDownloadManager *downloadManager;
    FZCrackGameInstaller *crackGameInstaller;
    NSUInteger selectCellAtlocalGame;
    NSUInteger selectCellAtInstallGame;
    UIButton *selectButtonAtLocalGame;
    UIButton *selectButtonAtInstallGame;
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
//        self.localGamesArray = [NSMutableArray array];
        self.crackGamesArray = [NSMutableArray array];
        
        selectCellAtlocalGame = 0;
        selectCellAtInstallGame = 0;
        downloadManager = [FZDownloadManager getShareInstance];
        interfaceServer = [FZInterfaceServer getShareInstance];
        crackGameInstaller = [FZCrackGameInstaller getShareInstance];
        crackGameInstaller.delegate = self;

    }
    return self;
}

- (void)viewDidLoad
{
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    [self getRemoteCrackGames];
    [self findlocalGames];
    
    CGRect tableviewCgrect = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height -  49 );
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
    
    
    //接口调用
    [interfaceServer loadUsefulGameSaveFile:dic withSuccessBlock:^(id responseObject) {
        self.localGamesArray = [NSMutableArray array];
        NSDictionary *responseDict = [responseObject objectFromJSONString];
        NSArray *result = [responseDict allValues];
        
        NSLog(@"resul:%@",result);
        
        [result enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *content = obj;
            
             FZGameFile *fzGame = [[FZGameFile alloc] init];
            fzGame.name = [content objectForKey:@"title"];
            fzGame.version = [content objectForKey:@"version"];
            fzGame.downloadNum = [content objectForKey:@"loadnum"];
            fzGame.thumbnail = [content objectForKey:@"thumb"];
            fzGame.packageName = [content objectForKey:@"bundleId"];
            fzGame.crackFileUrl = [content objectForKey:@"attach"];
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
    NSString *cid = [NSString stringWithFormat:@"%d",20];
    NSString *page = [NSString stringWithFormat:@"%d",1];
    
    [interfaceServer loadGamesListWithCatgoryId:cid withPage:page withSuccessBlock:^(id responseObject) {
        
        NSDictionary *responseDict = [responseObject objectFromJSONString];
        NSArray *result = [responseDict allValues];
          [result enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
              NSDictionary *content = obj;
              
              FZGameFile *fzGame = [[FZGameFile alloc] init];
              fzGame.name = [content objectForKey:@"title"];
              fzGame.version = [content objectForKey:@"version"];
              fzGame.downloadNum = [content objectForKey:@"loadnum"];
              fzGame.thumbnail = [content objectForKey:@"thumb"];
              fzGame.fileSize = [content objectForKey:@"filesize"];
              NSLog(@"%@",fzGame.name);
              
              [self.crackGamesArray addObject:fzGame];
          }];
        [self.tableview reloadData];
    } withFailureBlock:^(NSString *errorMessage) {
        NSLog(@"errorMessage:%@",errorMessage);
    }];
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
    
    //都没有数据的情况留出一个cell显示结果
    if (rowsNumber == 0) {
        rowsNumber = 1;
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 41.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
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
        UIView *installAPPPanelView = [self makeAppInstallPanelView];
 
        [cell.contentView addSubview:Contentview];
        [cell.contentView addSubview:operationPanelView];
        [cell.contentView addSubview:installAPPPanelView];
    }
    
    cell.textLabel.text = nil;
    switch (indexPath.section) {
        //设备中
        case 0:
        {
            //没有数据显示一个空白的cell
            if (self.localGamesArray == nil) {
                UIView *contentView = [[cell.contentView subviews] objectAtIndex:0];
                UIView *operationPanelView = [[cell.contentView subviews] objectAtIndex:1];
                UIView *installAPPPanelView = [[cell.contentView subviews] objectAtIndex:2];
                
                [contentView setHidden:YES];
                [operationPanelView setHidden:YES];
                [installAPPPanelView setHidden:YES];
                
                cell.textLabel.text = @"正在加载中";
                return cell;

            }
            
            if ([self.localGamesArray count] == 0) {
                UIView *contentView = [[cell.contentView subviews] objectAtIndex:0];
                UIView *operationPanelView = [[cell.contentView subviews] objectAtIndex:1];
                UIView *installAPPPanelView = [[cell.contentView subviews] objectAtIndex:2];
                
                [contentView setHidden:YES];
                [operationPanelView setHidden:YES];
                [installAPPPanelView setHidden:YES];
                
                cell.textLabel.text = @"没有发现可破解的游戏!";
                return cell;
            }
            
            if ([[self.localGamesArray objectAtIndex:[indexPath row]] isKindOfClass:[FZGameFile class]]) {
                
                UIView *contentView = [[cell.contentView subviews] objectAtIndex:0];
                UIView *operationPanelView = [[cell.contentView subviews] objectAtIndex:1];
                UIView *installAPPPanelView = [[cell.contentView subviews] objectAtIndex:2];

                
                UIImageView *thumbnailView = (UIImageView *)[contentView viewWithTag:2001];
                UILabel *gameTitle = (UILabel *)[contentView viewWithTag:2002];
                UILabel *scoreLabel = (UILabel *)[contentView viewWithTag:2003];
                UILabel *detailLabel = (UILabel *)[contentView viewWithTag:2004];
                UIButton *openPulldownButton = (UIButton *)[contentView viewWithTag:2005];
                UIButton *openInstallCellButton = (UIButton *)[contentView viewWithTag:2006];

                [openPulldownButton setHidden:NO];
                [contentView setHidden:NO];
                [operationPanelView setHidden:YES];
                [installAPPPanelView setHidden:YES];
                [openInstallCellButton setHidden:YES];


                FZGameFile *model = [self.localGamesArray objectAtIndex:[indexPath row]];
                gameTitle.text = model.name;
                [thumbnailView setImageWithURL:[NSURL URLWithString:model.thumbnail] placeholderImage:[UIImage imageNamed:@"fz_placeholder.png"]];
                scoreLabel.text = [NSString stringWithFormat:@"下载次数 %@",model.downloadNum];
                detailLabel.text = [NSString stringWithFormat:@"版本 %@ | %@M |",model.version,@"64.67"];
                
            }else{
    
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                UIView *operationPanelView = [[cell.contentView subviews] objectAtIndex:1];
                UIView *contentView = [[cell.contentView subviews] objectAtIndex:0];
                UIView *installAPPPanelView = [[cell.contentView subviews] objectAtIndex:2];
                [contentView setHidden:YES];
                [operationPanelView setHidden:NO];
                [installAPPPanelView setHidden:YES];
                
                UIButton *crackButton = (UIButton *)[operationPanelView viewWithTag:2006];
                UIButton *recoverButton = (UIButton *)[operationPanelView viewWithTag:2007];
                //判断按钮的可点击状态
                NSUInteger selectGameIndex = selectCellAtlocalGame - 1;
                FZGameFile *gamefile = [self.localGamesArray objectAtIndex:selectGameIndex];
                BOOL isCrack = [crackGameInstaller checkIsCrackByIdentifier:gamefile.packageName];
                if (isCrack) {
                    crackButton.enabled = NO;
                    recoverButton.enabled = YES;
                }else{
                    crackButton.enabled = YES;
                    recoverButton.enabled = NO;
                }
            }

        }
            break;
        //游戏列表
        case 1:
        {
            //没有数据显示一个空白的cell
            if ([self.crackGamesArray count] == 0) {
                UIView *contentView = [[cell.contentView subviews] objectAtIndex:0];
                UIView *operationPanelView = [[cell.contentView subviews] objectAtIndex:1];
                UIView *installAPPPanelView = [[cell.contentView subviews] objectAtIndex:2];
                
                [contentView setHidden:YES];
                [operationPanelView setHidden:YES];
                [installAPPPanelView setHidden:YES];
                
                cell.textLabel.text = @"没有发现可破解的游戏!";
                return cell;
            }

            
            if ([[self.crackGamesArray objectAtIndex:[indexPath row]] isKindOfClass:[FZGameFile class]]) {
                UIView *operationPanelView = [[cell.contentView subviews] objectAtIndex:1];
                UIView *contentView = [[cell.contentView subviews] objectAtIndex:0];
                UIView *installAPPPanelView = [[cell.contentView subviews] objectAtIndex:2];
                
                UIImageView *thumbnailView = (UIImageView *)[contentView viewWithTag:2001];
                UILabel *gameTitle = (UILabel *)[contentView viewWithTag:2002];
                UILabel *scoreLabel = (UILabel *)[contentView viewWithTag:2003];
                UILabel *detailLabel = (UILabel *)[contentView viewWithTag:2004];
                UIButton *openPulldownButton = (UIButton *)[contentView viewWithTag:2005];
                UIButton *openInstallCellButton = (UIButton *)[contentView viewWithTag:2006];
                
                [contentView setHidden:NO];
                [operationPanelView setHidden:YES];
                [installAPPPanelView setHidden:YES];
                
                [openPulldownButton setHidden:YES];
                [openInstallCellButton setHidden:NO];
                
                FZGameFile *model = [self.crackGamesArray objectAtIndex:[indexPath row]];
                gameTitle.text = model.name;
                [thumbnailView setImageWithURL:[NSURL URLWithString:model.thumbnail] placeholderImage:[UIImage imageNamed:@"fz_placeholder.png"]];
                scoreLabel.text = [NSString stringWithFormat:@"得分 %@分",@"2.3"];
                detailLabel.text = [NSString stringWithFormat:@"版本 %@ | %@ |",model.version,model.fileSize];
            }else{
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                UIView *operationPanelView = [[cell.contentView subviews] objectAtIndex:1];
                UIView *contentView = [[cell.contentView subviews] objectAtIndex:0];
                UIView *installAPPPanelView = [[cell.contentView subviews] objectAtIndex:2];
                [contentView setHidden:YES];
                [operationPanelView setHidden:YES];
                [installAPPPanelView setHidden:NO];

            }
           
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
    UILabel *gameTitle = [[UILabel alloc] initWithFrame:CGRectMake(77, 10, 190, 21)];
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
    [openPulldownButton addTarget:self action:@selector(openPullDownCellAction:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:openPulldownButton];
    
    //下拉框的按钮
    UIButton *openInstallCellButton = [UIButton buttonWithType:UIButtonTypeCustom];
    openInstallCellButton.frame = CGRectMake(263, 11, 52, 52);
    openInstallCellButton.tag = 2006;
    [openInstallCellButton setImage:Cell_button_install_open_image forState:UIControlStateNormal];
    [openInstallCellButton addTarget:self action:@selector(openPullDownCellAction:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:openInstallCellButton];


    
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
    [recoverButton setImage:Cell_button_recover_disable_image forState:UIControlStateDisabled];
    [opView addSubview:recoverButton];
    
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startButton.frame = CGRectMake(228, 14, 25, 25);
    startButton.tag = 2008;
    [startButton setImage:Cell_button_start_image forState:UIControlStateNormal];
    [opView addSubview:startButton];
    
    [crackButton addTarget:self action:@selector(clickCrackButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [recoverButton addTarget:self action:@selector(clickRecoverButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [startButton addTarget:self action:@selector(clickStartButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
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

//破解游戏安装 -
-(UIView *)makeAppInstallPanelView
{
    UIView *opView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 68)];
    
    UIButton *installCrackGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    installCrackGameButton.frame = CGRectMake(62, 22, 75, 23);
    installCrackGameButton.tag = 2009;
    [installCrackGameButton setImage:Cell_button_installCrackAPP_normal_image forState:UIControlStateNormal];
    [installCrackGameButton setImage:Cell_button_installCrackAPP_selected_image forState:UIControlStateHighlighted];
    [installCrackGameButton addTarget:self action:@selector(clickInstallCrackGameButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [opView addSubview:installCrackGameButton];
    
    UIButton *installGeneralGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    installGeneralGameButton.frame = CGRectMake(181, 22, 75, 23);
    installGeneralGameButton.tag = 2010;
    [installGeneralGameButton setImage:Cell_button_installAPP_normal_image forState:UIControlStateNormal];
    [installGeneralGameButton setImage:Cell_button_installAPP_selected_image forState:UIControlStateHighlighted];

    [opView addSubview:installGeneralGameButton];
    
    return opView;
}

//无限金币版、普通版 - 视图
-(void)makeSelectVersionPanelView
{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 68)];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /*
    FZGameFile *model = [[array objectAtIndex:indexPath.row] copy];
    [downloadManager addDownloadToList:model];
    [self pushdownloadList];
     */
}
//下拉弹出cell
-(void)openPullDownCellAction:(id)sender
{
    
    UIButton *button = (UIButton *)sender;
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableview];
    NSIndexPath *indexPath = [self.tableview indexPathForRowAtPoint:buttonPosition];
    
    switch (indexPath.section) {
        case 0:
        {
            if (selectCellAtlocalGame) {
                [self.localGamesArray removeObjectAtIndex:selectCellAtlocalGame];
                NSArray *indexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:selectCellAtlocalGame inSection:0]];
                [self.tableview beginUpdates];
                [self.tableview deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
                [self.tableview endUpdates];
                
                [selectButtonAtLocalGame setImage:Cell_button_close_image forState:UIControlStateNormal];
            }
            
            NSUInteger cellIndex = indexPath.row;
            
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
            break;
         case 1:
        {
            if (selectCellAtInstallGame) {
                [self.crackGamesArray removeObjectAtIndex:selectCellAtInstallGame];
                NSArray *indexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:selectCellAtInstallGame inSection:1]];
                [self.tableview beginUpdates];
                [self.tableview deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
                [self.tableview endUpdates];
                [selectButtonAtInstallGame setImage:Cell_button_install_close_image forState:UIControlStateNormal];
            }
            
            
            NSUInteger cellIndex = indexPath.row;
            
            if (cellIndex + 1 == selectCellAtInstallGame) {
                selectCellAtInstallGame = 0;
            }else{
                [button setImage:Cell_button_install_open_image forState:UIControlStateNormal];
                selectCellAtInstallGame = cellIndex + 1;
                [self.crackGamesArray insertObject:@"operation Panel" atIndex:selectCellAtInstallGame];
                NSArray *indexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:selectCellAtInstallGame inSection:1]];
                
                [self.tableview beginUpdates];
                [self.tableview insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
                [self.tableview endUpdates];
                
                selectButtonAtInstallGame = button;
            }

        }
        default:
            break;
    }

}

//点击破解按钮的操作
-(void)clickCrackButtonAction:(id)sender
{
    NSUInteger selectGameIndex = selectCellAtlocalGame - 1;
    FZGameFile *gamefile = [self.localGamesArray objectAtIndex:selectGameIndex];
    BOOL success = [crackGameInstaller installCrackFile:gamefile.crackFileUrl toAPP:gamefile.packageName];
    if (success) {
//        UIButton *crackbutton = (UIButton *)sender;
//        crackbutton.enabled = NO;
        [self.tableview reloadData];
        
        //使恢复按钮变成可用
//        UITableViewCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathWithIndex:selectGameIndex]];
//        UIView *operationView = cell.subviews[1];
//        UIButton *recoverButton = (UIButton *)[operationView viewWithTag:2007];
//        recoverButton.enabled = YES;
    }
}
//点击恢复按钮的操作
-(void)clickRecoverButtonAction:(id)sender
{
    NSUInteger selectGameIndex = selectCellAtlocalGame - 1;
    FZGameFile *gamefile = [self.localGamesArray objectAtIndex:selectGameIndex];
    BOOL success = [crackGameInstaller recoverCrackByIdentifier:gamefile.packageName];
    if (success) {
        [self.tableview reloadData];
    }
}
//点击启动按钮的操作
-(void)clickStartButtonAction:(id)sender
{
    NSUInteger selectGameIndex = selectCellAtlocalGame - 1;
    FZGameFile *gamefile = [self.localGamesArray objectAtIndex:selectGameIndex];
    [crackGameInstaller launchAppByIdentifier:gamefile.packageName];
}

-(void)clickInstallCrackGameButtonAction:(id)sender
{
    //安装测试
//    BOOL success = [crackGameInstaller installCrackGameFile:@"CL1024.ipa"];
    BOOL success = [crackGameInstaller installCrackGameFile:@"bxqy-1.6.0.ipa"];

        if (success) {
        [SVProgressHUD showSuccessWithStatus:@"安装成功!"];
    }
}

#pragma  mark FZCrackGameInstallDelegate

//破解成功
-(void)crackSuccess:(NSString *)Identifier
{
    [SVProgressHUD showSuccessWithStatus:@"破解成功!"];
}
//破解失败
-(void)crackFailure:(NSString *)Identifier
{
    [SVProgressHUD showErrorWithStatus:@"破解失败了..."];
}



-(void)pushdownloadList
{
    FZdownloadViewController *downloadVc = [[FZdownloadViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:downloadVc animated:YES];
}


@end
