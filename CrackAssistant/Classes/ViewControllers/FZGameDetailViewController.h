//
//  FZGameDetailViewController.h
//  CrackAssistant
//
//  Created by enalex on 14-4-16.
//  Copyright (c) 2014年 疯子. All rights reserved.
//

#import "FZBaseViewController.h"
#import "FZBaseTableViewController.h"

@interface FZGameDetailViewController : FZBaseTableViewController

@property (nonatomic, strong) NSString *classId;
@property (nonatomic, strong) NSString *gameId;

@property (nonatomic, strong) NSDictionary *gameInfoDic;

@property (nonatomic, strong) UIButton *gameDetailButton;
@property (nonatomic, strong) UIButton *gameCommentButton;
@property (nonatomic, strong) UIButton *gameRelateButton;

@end
