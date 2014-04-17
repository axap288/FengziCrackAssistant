//
//  FZMacro.h
//  CrackAssistant
//
//  Created by yuan fang on 14-4-16.
//  Copyright (c) 2014年 疯子. All rights reserved.
//

/**
 iPhone5标记
 */
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define yOffect (iPhone5 ? 88.f : 0)        // 4寸屏幕的增加高度
#define isIOS7 (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? YES : NO)
#define yOffectNavBar (isIOS7 ? 0 : 44)     // IOS6、IOS7导航栏的偏移高度
#define yOffectStatusBar (isIOS7 ? 20 : 0)  // IOS6、IOS7状态栏的偏移高度

/**
 IOS Version Check
 */
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define UIColorFromRGB(r,g,b) [UIColor colorWithRed:(float)r/255.0 green:(float)g/255.0 blue:(float)b/255.0 alpha:1.0]

