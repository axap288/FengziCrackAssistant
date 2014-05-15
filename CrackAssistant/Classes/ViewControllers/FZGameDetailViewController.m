//
//  FZGameDetailViewController.m
//  CrackAssistant
//
//  Created by enalex on 14-4-16.
//  Copyright (c) 2014年 疯子. All rights reserved.
//

#import "FZGameDetailViewController.h"
#import "FZInterfaceServer.h"
#import "UIImageView+WebCache.h"
#import "FZGameDetailScreenCell.h"
#import "FZCommonUitils.h"

#define kDetailCellScreenHeight 305
#define kDetailCellContentHeight 100

#define kCommentCellHeight 67

#define kRecommendCellHeight 132

@interface FZGameDetailViewController ()

// 获取游戏详情
- (void)getGameDetailInfo;

// 获取游戏评论
- (void)getGameCommentInfo;

// 获取游戏推荐
- (void)getGameRecommendInfo;

// 创建游戏详情视图
- (UIView *)createGameInfoView;

// 详情，评论，相关按钮
- (void)gameDetailButtonClicked:(id)sender;
- (void)gameCommentButtonClicked:(id)sender;
- (void)gameRelateButtonClicked:(id)sender;

@end

@implementation FZGameDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"navTitleGameDetail", @"");
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.baseTableView.frame = CGRectMake(0, 0, 320, 416 + yOffect);
    
    self.userCommentArray = [NSMutableArray array];
    
    [self getGameDetailInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Method
// 获取游戏详情
- (void)getGameDetailInfo
{
    FZInterfaceServer *interfaceServer = [FZInterfaceServer getShareInstance];
    [interfaceServer loadGameDetailWithClassId:self.classId
                                        gameId:self.gameId
                              WithSuccessBlock:^(id responseObject) {
                                  
                                  self.gameInfoDic = [responseObject mutableObjectFromJSONString];
                                  
                                  self.baseTableView.tableHeaderView = [self createGameInfoView];
                                  [self.baseTableView reloadData];
                                  
                              } withFailureBlock:^(NSString *errorMessage) {
                                  
                              }];
}

// 获取游戏评论
- (void)getGameCommentInfo
{
    FZInterfaceServer *interfaceServer = [FZInterfaceServer getShareInstance];
    [interfaceServer loadGameCommentWithClassId:self.classId
                                         gameId:self.gameId
                                       WithPage:@"1"
                               WithSuccessBlock:^(id responseObject) {

                                   [self.userCommentArray addObjectsFromArray:[responseObject mutableObjectFromJSONString]];
                                   [self.baseTableView reloadData];
                                   
                               } withFailureBlock:^(NSString *errorMessage) {
                                   
                               }];
}

// 获取游戏推荐
- (void)getGameRecommendInfo
{
    FZInterfaceServer *interfaceServer = [FZInterfaceServer getShareInstance];
    [interfaceServer loadGameRecommendWithClassId:self.classId
                                 WithSuccessBlock:^(id responseObject) {
                                     
                                     self.gameRecommendArray = [[responseObject mutableObjectFromJSONString] allValues];
                                     [self.baseTableView reloadData];
                                     
                                 } withFailureBlock:^(NSString *errorMessage) {
                                     
                                 }];
}

// 创建游戏详情视图
- (UIView *)createGameInfoView
{
    UIView *gameInfoView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 117)];
    
    //缩略图
    UIImageView *thumbnailView = [[UIImageView alloc] init];
    thumbnailView.frame = CGRectMake(25, 25, 51, 51);
    thumbnailView.tag = 101;
    [thumbnailView setImageWithURL:[NSURL URLWithString:[self.gameInfoDic objectForKey:@"thumb"]]
                  placeholderImage:Image_plcaeholder_bg];
    [gameInfoView addSubview:thumbnailView];
    
    //标题
    UILabel *gameTitle = [[UILabel alloc] initWithFrame:CGRectMake(85, 25, 190, 15)];
    gameTitle.backgroundColor = [UIColor clearColor];
    gameTitle.textColor = UIColorFromRGB(46, 46, 46);
    gameTitle.font = [UIFont systemFontOfSize:14];
    gameTitle.text = [self.gameInfoDic objectForKey:@"title"];
    [gameInfoView addSubview:gameTitle];
    
    //大小
    UILabel *gameSize = [[UILabel alloc] initWithFrame:CGRectMake(85, 45, 80, 15)];
    gameSize.backgroundColor = [UIColor clearColor];
    gameSize.textColor = [UIColor darkGrayColor];
    gameSize.font = [UIFont systemFontOfSize:12];
    gameSize.text = [NSString stringWithFormat:@"大小:%@", [self.gameInfoDic objectForKey:@"filesize"]];
    [gameInfoView addSubview:gameSize];
    
    //下载
    UILabel *gameDownload = [[UILabel alloc] initWithFrame:CGRectMake(165, 45, 80, 15)];
    gameDownload.backgroundColor = [UIColor clearColor];
    gameDownload.textColor = [UIColor darkGrayColor];
    gameDownload.font = [UIFont systemFontOfSize:12];
    gameDownload.text = [NSString stringWithFormat:@"下载:%@", [self.gameInfoDic objectForKey:@"loadnum"]];
    [gameInfoView addSubview:gameDownload];
    
    //下载按钮
    if ([[self.gameInfoDic objectForKey:@"iscrack"] isEqualToString:@"1"]) {
        UIButton *openInstallCellButton = [UIButton buttonWithType:UIButtonTypeCustom];
        openInstallCellButton.frame = CGRectMake(240, 45, 52, 26);
        [openInstallCellButton setImage:Cell_button_install_open_image
                               forState:UIControlStateNormal];
        [openInstallCellButton setImage:Cell_button_install_close_image
                               forState:UIControlStateHighlighted];
        // [openInstallCellButton addTarget:self action:@selector(gameInstallButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [gameInfoView addSubview:openInstallCellButton];
    } else {
        UIButton *installCrackGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        installCrackGameButton.frame = CGRectMake(230, 20, 75, 23);
        [installCrackGameButton setImage:Cell_button_installCrackAPP_normal_image forState:UIControlStateNormal];
        [installCrackGameButton setImage:Cell_button_installCrackAPP_selected_image forState:UIControlStateHighlighted];
        // [installCrackGameButton addTarget:self action:@selector(clickInstallCrackGameButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [gameInfoView addSubview:installCrackGameButton];
        
        UIButton *installGeneralGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        installGeneralGameButton.frame = CGRectMake(230, 48, 75, 23);
        [installGeneralGameButton setImage:Cell_button_installAPP_normal_image forState:UIControlStateNormal];
        [installGeneralGameButton setImage:Cell_button_installAPP_selected_image forState:UIControlStateHighlighted];
        [gameInfoView addSubview:installGeneralGameButton];
    
    }
    
    //详情，评论，相关按钮
    [self setupSegmentedControl:gameInfoView];
    [self.gameDetailButton setBackgroundImage:Detail_segment_left_selected_bg forState:UIControlStateNormal];
    [self.gameDetailButton setBackgroundImage:Detail_segment_left_normal_bg forState:UIControlStateHighlighted];
    [self.gameDetailButton setTitleColor:UIColorFromRGB(255, 255, 255) forState:UIControlStateNormal];
    self.detailType = FZGameDetailTypeDetail;
    return gameInfoView;
}

// 详情，评论，相关按钮
- (void)gameDetailButtonClicked:(id)sender
{
    [self.gameDetailButton setBackgroundImage:Detail_segment_left_selected_bg forState:UIControlStateNormal];
    [self.gameDetailButton setBackgroundImage:Detail_segment_left_normal_bg forState:UIControlStateHighlighted];
    [self.gameDetailButton setTitleColor:UIColorFromRGB(255, 255, 255) forState:UIControlStateNormal];
    
    [self.gameCommentButton setBackgroundImage:Detail_segment_middle_normal_bg forState:UIControlStateNormal];
    [self.gameCommentButton setBackgroundImage:Detail_segment_middle_selected_bg forState:UIControlStateHighlighted];
    [self.gameCommentButton setTitleColor:UIColorFromRGB(135, 135, 135) forState:UIControlStateNormal];
    
    [self.gameRelateButton setBackgroundImage:Detail_segment_right_normal_bg forState:UIControlStateNormal];
    [self.gameRelateButton setBackgroundImage:Detail_segment_right_selected_bg forState:UIControlStateHighlighted];
    [self.gameRelateButton setTitleColor:UIColorFromRGB(135, 135, 135) forState:UIControlStateNormal];
    
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self getGameDetailInfo];
}

- (void)gameCommentButtonClicked:(id)sender
{
    [self.gameDetailButton setBackgroundImage:Detail_segment_left_normal_bg forState:UIControlStateNormal];
    [self.gameDetailButton setBackgroundImage:Detail_segment_left_selected_bg forState:UIControlStateHighlighted];
    [self.gameDetailButton setTitleColor:UIColorFromRGB(135, 135, 135) forState:UIControlStateNormal];
    
    [self.gameCommentButton setBackgroundImage:Detail_segment_middle_selected_bg forState:UIControlStateNormal];
    [self.gameCommentButton setBackgroundImage:Detail_segment_middle_normal_bg forState:UIControlStateHighlighted];
    [self.gameCommentButton setTitleColor:UIColorFromRGB(255, 255, 255) forState:UIControlStateNormal];
    
    [self.gameRelateButton setBackgroundImage:Detail_segment_right_normal_bg forState:UIControlStateNormal];
    [self.gameRelateButton setBackgroundImage:Detail_segment_right_selected_bg forState:UIControlStateHighlighted];
    [self.gameRelateButton setTitleColor:UIColorFromRGB(135, 135, 135) forState:UIControlStateNormal];
    
    self.detailType = FZGameDetailTypeComment;
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.userCommentArray removeAllObjects];
    [self getGameCommentInfo];
}

- (void)gameRelateButtonClicked:(id)sender
{
    [self.gameDetailButton setBackgroundImage:Detail_segment_left_normal_bg forState:UIControlStateNormal];
    [self.gameDetailButton setBackgroundImage:Detail_segment_left_selected_bg forState:UIControlStateHighlighted];
    [self.gameDetailButton setTitleColor:UIColorFromRGB(135, 135, 135) forState:UIControlStateNormal];
    
    [self.gameCommentButton setBackgroundImage:Detail_segment_middle_normal_bg forState:UIControlStateNormal];
    [self.gameCommentButton setBackgroundImage:Detail_segment_middle_selected_bg forState:UIControlStateHighlighted];
    [self.gameCommentButton setTitleColor:UIColorFromRGB(135, 135, 135) forState:UIControlStateNormal];
    
    [self.gameRelateButton setBackgroundImage:Detail_segment_right_selected_bg forState:UIControlStateNormal];
    [self.gameRelateButton setBackgroundImage:Detail_segment_right_normal_bg forState:UIControlStateHighlighted];
    [self.gameRelateButton setTitleColor:UIColorFromRGB(255, 255, 255) forState:UIControlStateNormal];
    
    self.detailType = FZGameDetailTypeRelate;
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self getGameRecommendInfo];
}

- (void)setupSegmentedControl:(UIView *)segmentView
{
    // 详情
    self.gameDetailButton = [[UIButton alloc] initWithFrame:CGRectMake(31, 82, 86, 27)];
    [self.gameDetailButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self.gameDetailButton setTitle:@"详细信息" forState:UIControlStateNormal];
    [self.gameDetailButton setTitleColor:UIColorFromRGB(135, 135, 135) forState:UIControlStateNormal];
    [self.gameDetailButton setBackgroundImage:Detail_segment_left_normal_bg forState:UIControlStateNormal];
    [self.gameDetailButton setBackgroundImage:Detail_segment_left_selected_bg forState:UIControlStateHighlighted];
    [self.gameDetailButton addTarget:self action:@selector(gameDetailButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [segmentView addSubview:self.gameDetailButton];
   
    // 评论
    self.gameCommentButton = [[UIButton alloc] initWithFrame:CGRectMake(117, 82, 86, 27)];
    [self.gameCommentButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self.gameCommentButton setTitle:@"评论" forState:UIControlStateNormal];
    [self.gameCommentButton setTitleColor:UIColorFromRGB(135, 135, 135) forState:UIControlStateNormal];
    [self.gameCommentButton setBackgroundImage:Detail_segment_middle_normal_bg forState:UIControlStateNormal];
    [self.gameCommentButton setBackgroundImage:Detail_segment_middle_selected_bg forState:UIControlStateHighlighted];
    [self.gameCommentButton addTarget:self action:@selector(gameCommentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [segmentView addSubview:self.gameCommentButton];
    
    // 相关游戏
    self.gameRelateButton = [[UIButton alloc] initWithFrame:CGRectMake(203, 82, 86, 27)];
    [self.gameRelateButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self.gameRelateButton setTitle:@"相关游戏" forState:UIControlStateNormal];
    [self.gameRelateButton setTitleColor:UIColorFromRGB(135, 135, 135) forState:UIControlStateNormal];
    [self.gameRelateButton setBackgroundImage:Detail_segment_right_normal_bg forState:UIControlStateNormal];
    [self.gameRelateButton setBackgroundImage:Detail_segment_right_selected_bg forState:UIControlStateHighlighted];
    [self.gameRelateButton addTarget:self action:@selector(gameRelateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [segmentView addSubview:self.gameRelateButton];
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
    if (self.detailType == FZGameDetailTypeDetail && self.gameInfoDic != nil) {
        return 2;
    } else if (self.detailType == FZGameDetailTypeComment) {
        return self.userCommentArray.count;
    } else if (self.detailType == FZGameDetailTypeRelate) {
        return self.gameRecommendArray.count % 3 == 0 ? self.gameRecommendArray.count / 3 : self.gameRecommendArray.count / 3 + 1;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifierDetailScreen = @"cellIdentifierDetailScreen";
    static NSString *CellIdentifierDetailContent = @"cellIdentifierDetailContent";
    static NSString *CellIdentifierComment = @"cellIdentifierComment";
    static NSString *CellIdentifierRecommend = @"cellIdentifierRecommend";

    UITableViewCell *cell = nil;
    
    if (self.detailType == FZGameDetailTypeDetail) {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierDetailScreen];
            
            if (cell == nil) {
                cell = [[FZGameDetailScreenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierDetailScreen];
            }
            
            FZGameDetailScreenCell *gameDetailScreenCell = (FZGameDetailScreenCell *)cell;
            [gameDetailScreenCell setScrollViewImage:[self.gameInfoDic objectForKey:@"screen"]];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierDetailContent];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierDetailContent];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIImage *cellNormalImage = Cell_normal_bg;
                cellNormalImage = [cellNormalImage stretchableImageWithLeftCapWidth:0 topCapHeight:2];
                cell.backgroundView = [[UIImageView alloc] initWithImage:cellNormalImage];
                
                //内容介绍
                UILabel *gameDetailContentTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 190, 15)];
                gameDetailContentTitle.backgroundColor = [UIColor clearColor];
                gameDetailContentTitle.textColor = UIColorFromRGB(14, 14, 14);
                gameDetailContentTitle.font = [UIFont systemFontOfSize:13];
                gameDetailContentTitle.text = @"内容介绍";
                [cell addSubview:gameDetailContentTitle];
                
                UILabel *gameDetailContent = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 300, 50)];
                gameDetailContent.backgroundColor = [UIColor clearColor];
                gameDetailContent.textColor = UIColorFromRGB(112, 112, 112);
                gameDetailContent.numberOfLines = 0;
                gameDetailContent.lineBreakMode = NSLineBreakByCharWrapping;
                gameDetailContent.font = [UIFont systemFontOfSize:13];
                gameDetailContent.tag = 101;
                [cell addSubview:gameDetailContent];
            }
            
            UILabel *gameDetailContent = (UILabel *)[cell viewWithTag:101];
            float contentHeight = [FZCommonUitils getContentHeight:[self.gameInfoDic objectForKey:@"content"]
                                                      contentWidth:300
                                                          fontSize:13];
            
            CGRect gameDetailContentFrame = gameDetailContent.frame;
            gameDetailContent.frame = CGRectMake(gameDetailContentFrame.origin.x,
                                                 gameDetailContentFrame.origin.y,
                                                 gameDetailContentFrame.size.width,
                                                 contentHeight);
            gameDetailContent.text = [self.gameInfoDic objectForKey:@"content"];
        }
    } else if (self.detailType == FZGameDetailTypeComment) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierComment];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierComment];
            
            //缩略图
            UIImageView *thumbnailView = [[UIImageView alloc] init];
            thumbnailView.frame = CGRectMake(10, 11, 47, 40);
            thumbnailView.tag = 101;
            [cell addSubview:thumbnailView];
            
            //用户名
            UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(67, 11, 200, 15)];
            userName.backgroundColor = [UIColor clearColor];
            userName.textColor = UIColorFromRGB(67, 67, 67);
            userName.font = [UIFont systemFontOfSize:14];
            userName.tag = 102;
            [cell addSubview:userName];
            
            //评论
            UILabel *userComment = [[UILabel alloc] initWithFrame:CGRectMake(67, 30, 240, 30)];
            userComment.backgroundColor = [UIColor clearColor];
            userComment.textColor = UIColorFromRGB(92, 92, 92);
            userComment.font = [UIFont systemFontOfSize:12];
            userComment.numberOfLines = 0;
            userComment.lineBreakMode = NSLineBreakByCharWrapping;
            userComment.tag = 103;
            [cell addSubview:userComment];
        }
        
        NSDictionary *userCommentDic = [self.userCommentArray objectAtIndex:indexPath.row];
        
        //图片
        UIImageView *thumbnailView = (UIImageView *)[cell viewWithTag:101];
        [thumbnailView setImageWithURL:[NSURL URLWithString:[userCommentDic objectForKey:@"thumb"]]
                      placeholderImage:Image_plcaeholder_bg];
        
        //名称
        UILabel *userName = (UILabel *)[cell viewWithTag:102];
        userName.text = [userCommentDic objectForKey:@"username"];
        
        //评论
        UILabel *userComment = (UILabel *)[cell viewWithTag:103];
        userComment.text = [userCommentDic objectForKey:@"content"];
        
    } else if (self.detailType == FZGameDetailTypeRelate) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierRecommend];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierRecommend];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            //缩略图
            UIImageView *thumbnailViewOne = [[UIImageView alloc] init];
            thumbnailViewOne.frame = CGRectMake(25, 31, 69, 69);
            thumbnailViewOne.tag = 101;
            [cell addSubview:thumbnailViewOne];
            
            UIImageView *thumbnailViewTwo = [[UIImageView alloc] init];
            thumbnailViewTwo.frame = CGRectMake(124, 31, 69, 69);
            thumbnailViewTwo.tag = 102;
            [cell addSubview:thumbnailViewTwo];
            
            UIImageView *thumbnailViewThree = [[UIImageView alloc] init];
            thumbnailViewThree.frame = CGRectMake(223, 31, 69, 69);
            thumbnailViewThree.tag = 103;
            [cell addSubview:thumbnailViewThree];
            
            //游戏名
            UILabel *gameNameOne = [[UILabel alloc] initWithFrame:CGRectMake(25, 108, 80, 15)];
            gameNameOne.backgroundColor = [UIColor clearColor];
            gameNameOne.textColor = UIColorFromRGB(82, 82, 82);
            gameNameOne.font = [UIFont systemFontOfSize:12];
            gameNameOne.tag = 104;
            [cell addSubview:gameNameOne];
            
            UILabel *gameNameTwo = [[UILabel alloc] initWithFrame:CGRectMake(124, 108, 80, 15)];
            gameNameTwo.backgroundColor = [UIColor clearColor];
            gameNameTwo.textColor = UIColorFromRGB(82, 82, 82);
            gameNameTwo.font = [UIFont systemFontOfSize:12];
            gameNameTwo.tag = 105;
            [cell addSubview:gameNameTwo];
            
            UILabel *gameNameThree = [[UILabel alloc] initWithFrame:CGRectMake(223, 108, 80, 15)];
            gameNameThree.backgroundColor = [UIColor clearColor];
            gameNameThree.textColor = UIColorFromRGB(82, 82, 82);
            gameNameThree.font = [UIFont systemFontOfSize:12];
            gameNameThree.tag = 106;
            [cell addSubview:gameNameThree];
        }
        
        NSDictionary *gameDicOne = [self.gameRecommendArray objectAtIndex:indexPath.row * 3];
        NSDictionary *gameDicTwo = [self.gameRecommendArray objectAtIndex:indexPath.row * 3 + 1];
        NSDictionary *gameDicThree = [self.gameRecommendArray objectAtIndex:indexPath.row * 3 + 2];
        
        //图片
        UIImageView *thumbnailViewOne = (UIImageView *)[cell viewWithTag:101];
        [thumbnailViewOne setImageWithURL:[NSURL URLWithString:[gameDicOne objectForKey:@"thumb"]]
                      placeholderImage:Image_plcaeholder_bg];
        
        UIImageView *thumbnailViewTwo = (UIImageView *)[cell viewWithTag:102];
        [thumbnailViewTwo setImageWithURL:[NSURL URLWithString:[gameDicTwo objectForKey:@"thumb"]]
                         placeholderImage:Image_plcaeholder_bg];
        
        UIImageView *thumbnailViewThree = (UIImageView *)[cell viewWithTag:103];
        [thumbnailViewThree setImageWithURL:[NSURL URLWithString:[gameDicThree objectForKey:@"thumb"]]
                         placeholderImage:Image_plcaeholder_bg];
        
        //名称
        UILabel *gameNameOne = (UILabel *)[cell viewWithTag:104];
        gameNameOne.text = [gameDicOne objectForKey:@"title"];
        
        UILabel *gameNameTwo = (UILabel *)[cell viewWithTag:105];
        gameNameTwo.text = [gameDicTwo objectForKey:@"title"];
        
        UILabel *gameNameThree = (UILabel *)[cell viewWithTag:106];
        gameNameThree.text = [gameDicThree objectForKey:@"title"];
    }

    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.detailType == FZGameDetailTypeDetail) {
        if (indexPath.row == 0) {
            return kDetailCellScreenHeight;
        } else {
            float contentHeight = [FZCommonUitils getContentHeight:[self.gameInfoDic objectForKey:@"content"]
                                                      contentWidth:300
                                                          fontSize:13];
            return contentHeight + 30;
        }
    } else if (self.detailType == FZGameDetailTypeComment) {
        return kCommentCellHeight;
    } else if (self.detailType == FZGameDetailTypeRelate) {
        return kRecommendCellHeight;
    } else {
        return 0;
    }
}

@end
