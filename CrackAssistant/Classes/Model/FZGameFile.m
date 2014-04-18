//
//  FZGameFile.m
//  CrackAssistant
//
//  Created by LiuNian on 14-4-16.
//
//

#import "FZGameFile.h"

@implementation FZGameFile


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.fileName forKey:@"fileName"];
    [aCoder encodeObject:self.downloadUrl forKey:@"downloadUrl"];
    [aCoder encodeObject:self.fileSize forKey:@"fileSize"];
    [aCoder encodeObject:self.receviedSize forKey:@"receviedSize"];
    [aCoder encodeObject:self.iD forKey:@"iD"];
    [aCoder encodeObject:self.name forKey:@"name"];

}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.iD = [aDecoder decodeObjectForKey:@"iD"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.thumbnail = [aDecoder decodeObjectForKey:@"thumbnail"];
        self.fileName = [aDecoder decodeObjectForKey:@"fileName"];
        self.downloadUrl =[aDecoder decodeObjectForKey:@"downloadUrl"];
        self.fileSize = [aDecoder decodeObjectForKey:@"fileSize"];
        self.receviedSize = [aDecoder decodeObjectForKey:@"receviedSize"];
    }
    return self;
}

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
