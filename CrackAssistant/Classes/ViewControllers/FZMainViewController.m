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

#define kCellHeight 72

@interface FZMainViewController ()

@property (nonatomic, assign) BOOL isBannerFinish;
@property (nonatomic, assign) BOOL isGameListFinish;

// 获取首页Banner图片
- (void)getHomeBannerInfo;

// 获取首页推荐游戏列表
- (void)getHomeGameListInfo;

// 创建首页焦点图
- (UIView *)createHomeBannerScrollView:(NSArray *)imageArray;

// 停止下拉刷新
- (void)stopPullToRefreshStop;

@end

@implementation FZMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // 下拉刷新
    __unsafe_unretained FZMainViewController *mainViewCtrl = self;
    [self.baseTableView addPullToRefreshWithActionHandler:^{
        
        mainViewCtrl.isBannerFinish = NO;
        mainViewCtrl.isGameListFinish = NO;
        
        [mainViewCtrl getHomeBannerInfo];
        [mainViewCtrl getHomeGameListInfo];
    }];
    
    [self.baseTableView triggerPullToRefresh];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
        
        // [openInstallCellButton addTarget:self action:@selector(openPullDownCellAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:openInstallCellButton];

    }
    
    // Configure the cell...
    NSDictionary *gameInfo = [self.gameListArray objectAtIndex:indexPath.row];
    
    UIImageView *thumbnailView = (UIImageView *)[cell viewWithTag:101];
    [thumbnailView setImageWithURL:[NSURL URLWithString:[gameInfo objectForKey:@"thumb"]]
                     placeholderImage:[UIImage imageNamed:@""]];
    
    
    UILabel *gameTitle = (UILabel *)[cell viewWithTag:102];
    gameTitle.text = [gameInfo objectForKey:@"title"];
    
    UILabel *scoreLabel = (UILabel *)[cell viewWithTag:103];
    scoreLabel.text = [NSString stringWithFormat:@"下载次数 %@", [gameInfo objectForKey:@"loadnum"]];
    
    UILabel *detailLabel = (UILabel *)[cell viewWithTag:104];
    detailLabel.text = [NSString stringWithFormat:@"版本 %@ | %@M |",
                      [gameInfo objectForKey:@"version"],
                      [gameInfo objectForKey:@"filesize"]];
    
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FZGameDetailViewController *gameDetailCtrl = [[FZGameDetailViewController alloc] init];
    
    if (!isIOS7) {
        gameDetailCtrl.hidesBottomBarWhenPushed = YES;
    }
    
    [self showTabBar:NO withAnimation:YES];
    [self.navigationController pushViewController:gameDetailCtrl animated:YES];
}

@end
