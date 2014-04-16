//
//  FZBaseTableViewController.h
//  CrackAssistant
//
//  Created by yuan fang on 14-4-14.
//
//

#import <UIKit/UIKit.h>
#import "FZBaseViewController.h"

@interface FZBaseTableViewController : FZBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *baseTableView;

@end
