//
//  FZCommonUitils.m
//  CrackAssistant
//
//  Created by LiuNian on 14-4-16.
//
//

#import "FZCommonUitils.h"

@implementation FZCommonUitils

+(NSString *)getFileSizeString:(NSString *)size
{
    if ([size floatValue] == 0 || size == nil) {
        return @"--";
    }
    if([size floatValue]>=1024*1024)//大于1M，则转化成M单位的字符串
    {
        return [NSString stringWithFormat:@"%.1fMB",[size floatValue]/1024/1024];
    }
    else if([size floatValue]>=1024&&[size floatValue]<1024*1024) //不到1M,但是超过了1KB，则转化成KB单位
    {
        return [NSString stringWithFormat:@"%.1fKB",[size floatValue]/1024];
    }
    else//剩下的都是小于1K的，则转化成B单位
    {
        return [NSString stringWithFormat:@"%.1fB",[size floatValue]];
    }
}

+(float)getFileSizeNumber:(NSString *)size
{
    NSInteger indexM=[size rangeOfString:@"M"].location;
    NSInteger indexK=[size rangeOfString:@"K"].location;
    NSInteger indexB=[size rangeOfString:@"B"].location;
    if(indexM<1000)//是M单位的字符串
    {
        return [[size substringToIndex:indexM] floatValue]*1024*1024;
    }
    else if(indexK<1000)//是K单位的字符串
    {
        return [[size substringToIndex:indexK] floatValue]*1024;
    }
    else if(indexB<1000)//是B单位的字符串
    {
        return [[size substringToIndex:indexB] floatValue];
    }
    else//没有任何单位的数字字符串
    {
        return [size floatValue];
    }
}

+ (FZAppDelegate *)getApplicationDelegate
{
    return (FZAppDelegate *)[UIApplication sharedApplication].delegate;
}

// 计算文本高度
+ (CGFloat)getContentHeight:(NSString *)content
               contentWidth:(CGFloat)width fontSize:(NSInteger)size
{
	CGSize constraint = CGSizeMake(width, 2000.0);
	CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:size]
                             constrainedToSize:constraint
                                 lineBreakMode:NSLineBreakByWordWrapping];
	CGFloat contentHeight = contentSize.height;
	return contentHeight;
}

@end
