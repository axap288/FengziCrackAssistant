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

@interface FZGameDetailViewController ()

// 获取游戏详情
- (void)getGameDetailInfo;

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
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = @"abc";
    
    return cell;
}

@end
