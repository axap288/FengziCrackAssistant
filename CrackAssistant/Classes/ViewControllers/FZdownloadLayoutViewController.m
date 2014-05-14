//
//  FZdownloadLayoutViewController.m
//  CrackAssistant
//
//  Created by LiuNian on 14-5-15.
//  Copyright (c) 2014年 疯子. All rights reserved.
//

#import "FZdownloadLayoutViewController.h"

@interface FZdownloadLayoutViewController ()

@end

@implementation FZdownloadLayoutViewController
{
    UIImageView *indicatorLight1;
    UIImageView *indicatorLight2;
    UIImageView *indicatorLight3;
    
    UIButton *downloadingButton;
    UIButton *downloadOverButton;
    UIButton *updateButton;

}


- (instancetype)init
{
    self = [super init];
    if (self) {
   
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createTableView];
    
    if (isIOS7) {
        UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, yOffectStatusBar)];
        statusBarView.backgroundColor = UIColorFromRGB(219, 83, 42);
        [self.view addSubview:statusBarView];
    }
    
    [self createTopButtons];
    [self createActionButtons];
    [self createEmprtyDataView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 创建顶部按钮
- (void)createTopButtons
{
    //下载中
    downloadingButton = [[UIButton alloc] initWithFrame:CGRectMake(7, yOffectStatusBar + 8, 103, 32)];
    [downloadingButton setBackgroundImage:Download_topbutton_normal_bg
                                 forState:UIControlStateNormal];
    [downloadingButton addTarget:self action:@selector(topButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [downloadingButton setTitle:@"下载中" forState:UIControlStateNormal];
    downloadingButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [downloadingButton setTitleColor:UIColorFromRGB(232, 103, 65) forState:UIControlStateNormal];
    downloadingButton.titleLabel.font = [UIFont systemFontOfSize:12];
    downloadingButton.tag = 701;
    [self.view addSubview:downloadingButton];
    
    //黄色的指示条
    indicatorLight1 = [[UIImageView alloc] initWithFrame:CGRectMake(7, yOffectStatusBar+38, 103, 2)];
    [indicatorLight1 setImage:Download_topbutton_indicatorlight];
    [self.view addSubview:indicatorLight1];
    
    // 已下载
    downloadOverButton = [[UIButton alloc] initWithFrame:CGRectMake(109, yOffectStatusBar +8, 103, 32)];
    [downloadOverButton setBackgroundImage:Download_topbutton_normal_bg
                                  forState:UIControlStateNormal];
    [downloadOverButton addTarget:self action:@selector(topButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    downloadOverButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [downloadOverButton setTitle:@"已下载" forState:UIControlStateNormal];
    [downloadOverButton setTitleColor:UIColorFromRGB(57, 57, 57) forState:UIControlStateNormal];
    downloadOverButton.tag = 702;
    [self.view addSubview:downloadOverButton];
    
    //黄色的指示条
    indicatorLight2 = [[UIImageView alloc] initWithFrame:CGRectMake(109, yOffectStatusBar+38, 103, 2)];
    [indicatorLight2 setImage:Download_topbutton_indicatorlight];
    [indicatorLight2 setHidden:YES];
    [self.view addSubview:indicatorLight2];
    
    // 更新
    updateButton = [[UIButton alloc] initWithFrame:CGRectMake(211, yOffectStatusBar + 8, 103, 32)];
    [updateButton setBackgroundImage:Download_topbutton_normal_bg
                            forState:UIControlStateNormal];
    [updateButton addTarget:self action:@selector(topButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    updateButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [updateButton setTitle:@"更新" forState:UIControlStateNormal];
    [updateButton  setTitleColor:UIColorFromRGB(57, 57, 57) forState:UIControlStateNormal];
    updateButton.tag = 703;
    [self.view addSubview:updateButton];
    
    //黄色的指示条
    indicatorLight3 = [[UIImageView alloc] initWithFrame:CGRectMake(211, yOffectStatusBar+38, 103, 2)];
    [indicatorLight3 setImage:Download_topbutton_indicatorlight];
    [indicatorLight3 setHidden:YES];
    [self.view addSubview:indicatorLight3];
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
    self.baseTableView.frame = CGRectMake(0, yOffectStatusBar + 81, 320, tableHeigh - 49);
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)createEmprtyDataView
{
    CGFloat backgroundViewHeigh = 487;
    
    self.nodataView = [[UIView alloc] initWithFrame:CGRectMake(0, yOffectStatusBar + 81, 320.0f, backgroundViewHeigh - 49)];
    [self.nodataView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.nodataView];
    
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 28)];
    [icon setImage:Download_no_download_icon];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 69, 21)];
    label.text = @"暂无任何下载";
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:11];
    label.textColor = [UIColor grayColor];
    
    UIView *centerDisplayContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 109, 29)];
    [centerDisplayContent addSubview:icon];
    [centerDisplayContent addSubview:label];
    
    centerDisplayContent.center = CGPointMake(self.nodataView.center.x, self.nodataView.center.y - yOffectStatusBar - 81);
    
    [self.nodataView addSubview:centerDisplayContent];
}

/**
 *  3种tableviewcell的绘制
 */

-(void)drawCellForDownloadTableView:(UITableViewCell *)cell
{
    UIImage *cellNormalImage = Cell_normal_bg;
    cellNormalImage = [cellNormalImage stretchableImageWithLeftCapWidth:0 topCapHeight:2];
    
    UIImage *cellSelectedImage = Cell_selected_bg;
    cellSelectedImage = [cellSelectedImage stretchableImageWithLeftCapWidth:0 topCapHeight:2];
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:cellNormalImage];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:cellSelectedImage];
    
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

-(void)drawCellForDownloadEndTableView:(UITableViewCell *)cell
{
    
}
-(void)drawCellForUpdateTableView:(UITableViewCell *)cell
{
    
}


-(void)topButtonClicked:(id)sender
{
    UIButton *button = sender;
    [button setTitleColor:UIColorFromRGB(232, 103, 65) forState:UIControlStateNormal];
    
    switch (button.tag) {
        case 701:
        {
            [downloadOverButton setTitleColor:UIColorFromRGB(57, 57,57) forState:UIControlStateNormal];
            [updateButton setTitleColor:UIColorFromRGB(57, 57,57) forState:UIControlStateNormal];
            [indicatorLight1 setHidden:NO];
            [indicatorLight2 setHidden:YES];
            [indicatorLight3 setHidden:YES];
            self.selectedPageIndex = 1;
        }
            break;
         case 702:
        {
            [downloadingButton setTitleColor:UIColorFromRGB(57, 57,57) forState:UIControlStateNormal];
            [updateButton setTitleColor:UIColorFromRGB(57, 57,57) forState:UIControlStateNormal];
            [indicatorLight1 setHidden:YES];
            [indicatorLight2 setHidden:NO];
            [indicatorLight3 setHidden:YES];
            self.selectedPageIndex = 2;
        }
            break;
        case 703:
        {
            [downloadingButton setTitleColor:UIColorFromRGB(57, 57,57) forState:UIControlStateNormal];
            [downloadOverButton setTitleColor:UIColorFromRGB(57, 57,57) forState:UIControlStateNormal];
            [indicatorLight1 setHidden:YES];
            [indicatorLight2 setHidden:YES];
            [indicatorLight3 setHidden:NO];
            self.selectedPageIndex = 3;
        }
            break;
        default:
            break;
    }
}


@end
