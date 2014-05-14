//
//  FZdownloadLayoutViewController.h
//  CrackAssistant
//
//  Created by LiuNian on 14-5-15.
//  Copyright (c) 2014年 疯子. All rights reserved.
//

#import "FZBaseTableViewController.h"

@interface FZdownloadLayoutViewController : FZBaseTableViewController
/**
 *  选择的当前视图序号 1、下载中  2、已下载  3、更新
 */
@property(assign) NSInteger selectedPageIndex;
/**
 *  无数据时显示此view
 */
@property(nonatomic,strong) UIView *nodataView;

-(void)drawCellForDownloadTableView:(UITableViewCell *)cell;
-(void)drawCellForDownloadEndTableView:(UITableViewCell *)cell;
-(void)drawCellForUpdateTableView:(UITableViewCell *)cell;

-(void)topButtonClicked:(id)sender;

@end
