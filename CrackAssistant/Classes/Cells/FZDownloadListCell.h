//
//  FZDownloadListCell.h
//  CrackAssistant
//
//  Created by LiuNian on 14-4-16.
//
//

#import <UIKit/UIKit.h>

@interface FZDownloadListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *controlButton;
@property (weak, nonatomic) IBOutlet UIProgressView *downloadProgress;
@property (weak, nonatomic) IBOutlet UILabel *downladRate;
@property (weak, nonatomic) IBOutlet UILabel *filename;
@end
