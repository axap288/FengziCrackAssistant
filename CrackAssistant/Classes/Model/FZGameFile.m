//
//  FZGameFile.m
//  CrackAssistant
//
//  Created by LiuNian on 14-4-16.
//
//

#import "FZGameFile.h"

@implementation FZGameFile


-(id)copyWithZone:(NSZone *)zone
{
    FZGameFile *copy = [[[self class] allocWithZone:zone] init];
    copy.iD = self.iD;
    copy.name = self.name;
    copy.thumbnail = self.thumbnail;
    copy.fileName = self.fileName;
    copy.downloadUrl = self.downloadUrl;
    return copy;
}


@end
