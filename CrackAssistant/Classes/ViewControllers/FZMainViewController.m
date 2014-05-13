//
//  FZMainViewController.m
//  CrackAssistant
//
//  Created by LiuNian on 14-4-14.
//
//

#import "FZMainViewController.h"
#import "FZGameDetailViewController.h"
#import "FZAppDelegate.h"
#import "FZInterfaceServer.h"
#import "FZHomeScrollImageView.h"
#import "UIImageView+WebCache.h"
#import "SVPullToRefresh.h"

#import "FZGameListViewController.h"

#define kCellHeight 72
#define kCellOpenHeight 144
#define kMaxInteger 10000

@interface FZMainViewController ()

@property (nonatomic, assign) BOOL isBannerFinish;
@property (nonatomic, assign) BOOL isGameListFinish;

@property (nonatomic, assign) NSInteger openRow;

// 获取首页Banner图片
- (void)getHomeBannerInfo;

// 获取首页推荐游戏列表
- (void)getHomeGameListInfo;

// 创建顶部按钮（游戏，咨询，插件）
- (void)createTopButtons;

// 创建首页焦点图
- (UIView *)createHomeBannerScrollView:(NSArray *)imageArray;

// 停止下拉刷新
- (void)stopPullToRefreshStop;

// 应用安装按钮事件
- (void)gameInstallButtonClicked:(id)sender;

// 展示游戏列表按钮事件
- (void)showGameListButtonClicked:(id)sender;

@end

@implementation FZMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.baseTableView.frame = CGRectMake(0, yOffectStatusBar + 35, 320, 425 + yOffect - 49);
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (isIOS7) {
        UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, yOffectStatusBar)];
        statusBarView.backgroundColor = UIColorFromRGB(219, 83, 42);
        [self.view addSubview:statusBarView];
    }
    [self createTopButtons];
    
    // 下拉刷新
    __unsafe_unretained FZMainViewController *mainViewCtrl = self;
    [self.baseTableView addPullToRefreshWithActionHandler:^{
        
        mainViewCtrl.isBannerFinish = NO;
        mainViewCtrl.isGameListFinish = NO;
        
        [mainViewCtrl getHomeBannerInfo];
        [mainViewCtrl getHomeGameListInfo];
        
        mainViewCtrl.openRow = kMaxInteger;
    }];
    
    [self.baseTableView triggerPullToRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self showTabBar:YES withAnimation:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Method
// 获取首页Banner图片
- (void)getHomeBannerInfo
{
    FZInterfaceServer *interfaceServer = [FZInterfaceServer getShareInstance];
    [interfaceServer loadHomeBannerWithSuccessBlock:^(id responseObject) {
        
        NSArray *bannerArray = [responseObject mutableObjectFromJSONString];
        
        NSMutableArray *imageArray = [NSMutableArray array];
        for (NSDictionary *bannerDic in bannerArray) {
            [imageArray addObject:[bannerDic objectForKey:@"path"]];
        }
        
        self.baseTableView.tableHeaderView = [self createHomeBannerScrollView:imageArray];
        
        self.isBannerFinish = YES;
        [self stopPullToRefreshStop];
        
    } withFailureBlock:^(NSString *errorMessage) {
        self.isBannerFinish = YES;
        [self stopPullToRefreshStop];
    }];
}

// 获取首页推荐游戏列表
- (void)getHomeGameListInfo
{
    FZInterfaceServer *interfaceServer = [FZInterfaceServer getShareInstance];
    [interfaceServer loadHomeGameListWithPage:@"1"
                             WithSuccessBlock:^(id responseObject) {
                                 
                                 NSDictionary *gameDic = [responseObject mutableObjectFromJSONString];
                                 self.gameListArray = (NSMutableArray *)[gameDic allValues];
                                 
                                 [self.baseTableView reloadData];
                                 
                                 self.isGameListFinish = YES;
                                 [self stopPullToRefreshStop];
                                 
                             } withFailureBlock:^(NSString *errorMessage) {
                                 self.isGameListFinish = YES;
                                 [self stopPullToRefreshStop];
                             }];
}

// 创建顶部按钮（游戏，咨询，插件）
- (void)createTopButtons
{
    // 游戏
    UIButton *gameButton = [[UIButton alloc] initWithFrame:CGRectMake(0, yOffectStatusBar, 106, 35)];
    [gameButton setBackgroundImage:Home_button_game_normal_bg
                          forState:UIControlStateNormal];
    [gameButton setBackgroundImage:Home_button_game_selected_bg
                          forState:UIControlStateHighlighted];
    [gameButton addTarget:self action:@selector(showGameListButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gameButton];
    
    // 资讯
    UIButton *infoButton = [[UIButton alloc] initWithFrame:CGRectMake(106, yOffectStatusBar, 107, 35)];
    [infoButton setBackgroundImage:Home_button_information_normal_bg
                          forState:UIControlStateNormal];
    [infoButton setBackgroundImage:Home_button_information_selected_bg
                          forState:UIControlStateHighlighted];
    [self.view addSubview:infoButton];
    
    // 插件
    UIButton *pluginButton = [[UIButton alloc] initWithFrame:CGRectMake(213, yOffectStatusBar, 107, 35)];
    [pluginButton setBackgroundImage:Home_button_plugin_normal_bg
                            forState:UIControlStateNormal];
    [pluginButton setBackgroundImage:Home_button_plugin_selected_bg
                            forState:UIControlStateHighlighted];
    [self.view addSubview:pluginButton];
}

// 创建首页焦点图
- (UIView *)createHomeBannerScrollView:(NSArray *)imageArray
{
    FZHomeScrollImageView *imageScrollView = [[FZHomeScrollImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 140)];
    [imageScrollView setScrollImageViewImage:imageArray];
    
    return imageScrollView;
}

// 停止下拉刷新
- (void)stopPullToRefreshStop
{
    if (self.isBannerFinish && self.isGameListFinish) {
        [self.baseTableView.pullToRefreshView performSelector:@selector(stopAnimating)
                                                   withObject:nil
                                                   afterDelay:kStopPullToRefreshAfterTimeDelay];
    }
}

// 应用安装按钮事件
- (void)gameInstallButtonClicked:(id)sender
{
    UIView *view = (UIButton *)sender;
    while (![view isKindOfClass:[UITableViewCell class]]) {
        view = [view superview];
    }
    UITableViewCell *cell = (UITableViewCell *)view;
    NSIndexPath *indexPath = [self.baseTableView indexPathForCell:cell];
    
    self.openRow = indexPath.row;
    
    [self.baseTableView reloadData];
}

// 展示游戏列表按钮事件
- (void)showGameListButtonClicked:(id)sender
{
    FZGameListViewController *gameListCtrl = [[FZGameListViewController alloc] init];
    
    if (!isIOS7) {
        gameListCtrl.hidesBottomBarWhenPushed = YES;
    }
    
    [self showTabBar:NO withAnimation:YES];
    
    [self.navigationController pushViewController:gameListCtrl animated:YES];
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
    return self.gameListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
        UIImage *cellNormalImage = Cell_normal_bg;
        cellNormalImage = [cellNormalImage stretchableImageWithLeftCapWidth:0 topCapHeight:2];
        
        UIImage *cellSelectedImage = Cell_selected_bg;
        cellSelectedImage = [cellSelectedImage stretchableImageWithLeftCapWidth:0 topCapHeight:2];
        
        cell.backgroundView = [[UIImageView alloc] initWithImage:cellNormalImage];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:cellSelectedImage];
        
        //缩略图
        UIImageView *thumbnailView = [[UIImageView alloc] init];
        thumbnailView.frame = CGRectMake(13, 10, 50, 50);
        thumbnailView.tag = 101;
        [cell addSubview:thumbnailView];
        
        //标题
        UILabel *gameTitle = [[UILabel alloc] initWithFrame:CGRectMake(77, 10, 190, 21)];
        gameTitle.backgroundColor = [UIColor clearColor];
        gameTitle.textColor = UIColorFromRGB(57, 57, 57);
        gameTitle.font = [UIFont systemFontOfSize:15];
        gameTitle.tag = 102;
        [cell addSubview:gameTitle];
        
        //得分
        UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(77, 28, 80, 21)];
        scoreLabel.backgroundColor = [UIColor clearColor];
        scoreLabel.textColor = UIColorFromRGB(64, 204, 253);
        scoreLabel.font = [UIFont systemFontOfSize:11];
        scoreLabel.tag = 103;
        [cell addSubview:scoreLabel];
        
        //细节
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(77, 47, 152, 16)];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.textColor = [UIColor darkGrayColor];
        detailLabel.font = [UIFont systemFontOfSize:11];
        detailLabel.tag = 104;
        [cell addSubview:detailLabel];
        
        UIButton *openInstallCellButton = [UIButton buttonWithType:UIButtonTypeCustom];
        openInstallCellButton.frame = CGRectMake(263, 11, 52, 52);
        openInstallCellButton.tag = 105;
        [openInstallCellButton setImage:Cell_button_install_open_image
                               forState:UIControlStateNormal];
        [openInstallCellButton setImage:Cell_button_install_close_image
                               forState:UIControlStateHighlighted];
        [openInstallCellButton addTarget:self action:@selector(gameInstallButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:openInstallCellButton];
        
        UIButton *installCrackGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        installCrackGameButton.frame = CGRectMake(62, 92, 75, 23);
        installCrackGameButton.tag = 106;
        [installCrackGameButton setImage:Cell_button_installCrackAPP_normal_image forState:UIControlStateNormal];
        [installCrackGameButton setImage:Cell_button_installCrackAPP_selected_image forState:UIControlStateHighlighted];
        // [installCrackGameButton addTarget:self action:@selector(clickInstallCrackGameButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:installCrackGameButton];
        
        UIButton *installGeneralGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        installGeneralGameButton.frame = CGRectMake(181, 92, 75, 23);
        installGeneralGameButton.tag = 107;
        [installGeneralGameButton setImage:Cell_button_installAPP_normal_image forState:UIControlStateNormal];
        [installGeneralGameButton setImage:Cell_button_installAPP_selected_image forState:UIControlStateHighlighted];
        [cell addSubview:installGeneralGameButton];

    }
    
    // Configure the cell...
    NSDictionary *gameInfo = [self.gameListArray objectAtIndex:indexPath.row];
    
    // 图片
    UIImageView *thumbnailView = (UIImageView *)[cell viewWithTag:101];
    [thumbnailView setImageWithURL:[NSURL URLWithString:[gameInfo objectForKey:@"thumb"]]
                     placeholderImage:Image_plcaeholder_bg];
    
    // 名称
    UILabel *gameTitle = (UILabel *)[cell viewWithTag:102];
    gameTitle.text = [gameInfo objectForKey:@"title"];
    
    UILabel *scoreLabel = (UILabel *)[cell viewWithTag:103];
    scoreLabel.text = [NSString stringWithFormat:@"下载次数 %@", [gameInfo objectForKey:@"loadnum"]];
    
    UILabel *detailLabel = (UILabel *)[cell viewWithTag:104];
    detailLabel.text = [NSString stringWithFormat:@"版本 %@ | %@M |",
                      [gameInfo objectForKey:@"version"],
                      [gameInfo objectForKey:@"filesize"]];
    
    UIButton *installCrackGameButton = (UIButton *)[cell viewWithTag:106];
    UIButton *installGeneralGameButton = (UIButton *)[cell viewWithTag:107];
    
    if (indexPath.row == self.openRow) {
        installCrackGameButton.hidden = NO;
        installGeneralGameButton.hidden = NO;
    } else {
        installCrackGameButton.hidden = YES;
        installGeneralGameButton.hidden = YES;
    }
    
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.openRow) {
        return kCellOpenHeight;
    } else {
        return kCellHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *gameDic = [self.gameListArray objectAtIndex:indexPath.row];
    FZGameDetailViewController *gameDetailCtrl = [[FZGameDetailViewController alloc] init];
    gameDetailCtrl.classId = [gameDic objectForKey:@"catid"];
    gameDetailCtrl.gameId = [gameDic objectForKey:@"id"];
    
    if (!isIOS7) {
        gameDetailCtrl.hidesBottomBarWhenPushed = YES;
    }
    
    [self showTabBar:NO withAnimation:YES];
    [self.navigationController pushViewController:gameDetailCtrl animated:YES];
}

@end
