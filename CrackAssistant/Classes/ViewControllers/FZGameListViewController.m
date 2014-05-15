//
//  FZGameListViewController.m
//  CrackAssistant
//
//  Created by enalex on 14-5-12.
//  Copyright (c) 2014年 疯子. All rights reserved.
//

#import "FZGameListViewController.h"
#import "FZInterfaceServer.h"
#import "UIImageView+WebCache.h"
#import "SVPullToRefresh.h"

#define kCellHeight 72
#define kCellOpenHeight 144
#define kMaxInteger 10000

@interface FZGameListViewController ()

@property (nonatomic, assign) NSInteger openRow;

// 获取游戏列表
- (void)getGameListInfo;

@end

@implementation FZGameListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:Home_game_title_bg];
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.baseTableView.frame = CGRectMake(0, 0, 320, 416 + yOffect);
    
    // 下拉刷新
    __unsafe_unretained FZGameListViewController *gameListViewCtrl = self;
    [self.baseTableView addPullToRefreshWithActionHandler:^{
        
        [gameListViewCtrl getGameListInfo];
        gameListViewCtrl.openRow = kMaxInteger;
        
    }];
    
    [self.baseTableView triggerPullToRefresh];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Method
// 获取游戏列表
- (void)getGameListInfo
{
    FZInterfaceServer *interfaceServer = [FZInterfaceServer getShareInstance];
    [interfaceServer loadGameListWithClassId:@""
                                    WithPage:@"1"
                            WithSuccessBlock:^(id responseObject) {
                                
                                NSDictionary *gameDic = [responseObject mutableObjectFromJSONString];
                                self.gameListArray = (NSMutableArray *)[gameDic allValues];
                                
                                [self.baseTableView reloadData];
                                
                                [self.baseTableView.pullToRefreshView performSelector:@selector(stopAnimating)
                                                                           withObject:nil
                                                                           afterDelay:kStopPullToRefreshAfterTimeDelay];
                                
                            } withFailureBlock:^(NSString *errorMessage) {

                                [self.baseTableView.pullToRefreshView performSelector:@selector(stopAnimating)
                                                                           withObject:nil
                                                                           afterDelay:kStopPullToRefreshAfterTimeDelay];
                            }];
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

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    FZGameDetailViewController *gameDetailCtrl = [[FZGameDetailViewController alloc] init];
//    
//    if (!isIOS7) {
//        gameDetailCtrl.hidesBottomBarWhenPushed = YES;
//    }
//    
//    [self showTabBar:NO withAnimation:YES];
//    [self.navigationController pushViewController:gameDetailCtrl animated:YES];
//}

@end
