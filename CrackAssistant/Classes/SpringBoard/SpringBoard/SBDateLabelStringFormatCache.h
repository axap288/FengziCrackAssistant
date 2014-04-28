/*
 *     Generated by class-dump 3.3.4 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2011 by Steve Nygard.
 */

#import "NSObject.h"

@class NSDateFormatter, NSNumberFormatter;

@interface SBDateLabelStringFormatCache : NSObject
{
    NSDateFormatter *_dayOfWeekFormatter;
    NSDateFormatter *_dayOfWeekWithTimeFormatter;
    NSDateFormatter *_dayMonthYearFormatter;
    NSDateFormatter *_shortDayMonthFormatter;
    NSDateFormatter *_shortDayMonthTimeFormatter;
    NSDateFormatter *_abbrevDayMonthFormatter;
    NSDateFormatter *_abbrevDayMonthTimeFormatter;
    NSDateFormatter *_timeFormatter;
    NSDateFormatter *_relativeDateTimeFormatter;
    NSNumberFormatter *_decimalFormatter;
}

+ (id)sharedInstance;
+ (void)load;
- (id)formatDateAsRelativeDateAndTimeStyle:(id)arg1;
- (id)formatDateAsTimeStyle:(id)arg1;
- (id)formatDateAsAbbreviatedDayMonthWithTimeStyle:(id)arg1;
- (id)formatDateAsAbbreviatedDayMonthStyle:(id)arg1;
- (id)formatDateAsShortDayMonthWithTimeStyle:(id)arg1;
- (id)formatDateAsDayMonthYearStyle:(id)arg1;
- (id)formatDateAsAbbreviatedDayOfWeekWithTime:(id)arg1;
- (id)formatDateAsDayOfWeek:(id)arg1;
- (id)formatNumberAsDecimal:(id)arg1;
- (void)resetFormatters:(id)arg1;
- (void)resetFormattersIfNecessary;
- (void)dealloc;
- (id)init;

@end

