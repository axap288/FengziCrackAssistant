//
//  FZCommonUitils.h
//  CrackAssistant
//
//  Created by LiuNian on 14-4-16.
//
//

#import <Foundation/Foundation.h>
#import "FZAppDelegate.h"

 #define UIColorFromHex(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]

@interface FZCommonUitils : NSObject

+(NSString *)getFileSizeString:(NSString *)size;

+(float)getFileSizeNumber:(NSString *)size;

+ (FZAppDelegate *)getApplicationDelegate;

// 计算文本高度
+ (CGFloat)getContentHeight:(NSString *)content
               contentWidth:(CGFloat)width fontSize:(NSInteger)size;

@end
