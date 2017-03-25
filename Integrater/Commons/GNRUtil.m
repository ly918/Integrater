//
//  NSDate+GNRExtension.m
//  Integrater
//
//  Created by LvYuan on 2017/3/25.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRUtil.h"

@implementation GNRUtil

+ (NSString*)showDetailTime:(NSTimeInterval) msglastTime{
    return [GNRUtil showTime:msglastTime showDetail:YES];
}

+ (NSString*)showTime:(NSTimeInterval) msglastTime showDetail:(BOOL)showDetail
{
    //今天的时间
    NSDate * nowDate = [NSDate date];
    NSDate * msgDate = [NSDate dateWithTimeIntervalSince1970:msglastTime];
    NSString *result = nil;
    NSCalendarUnit components = (NSCalendarUnit)(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitHour | NSCalendarUnitMinute);
    NSDateComponents *nowDateComponents = [[NSCalendar currentCalendar] components:components fromDate:nowDate];
    NSDateComponents *msgDateComponents = [[NSCalendar currentCalendar] components:components fromDate:msgDate];
    
    NSInteger hour = msgDateComponents.hour;
    NSTimeInterval gapTime = -msgDate.timeIntervalSinceNow;
    double onedayTimeIntervalValue = 24*60*60;  //一天的秒数
    result = [GNRUtil getPeriodOfTime:hour withMinute:msgDateComponents.minute];
    if (hour > 12)
    {
        hour = hour - 12;
    }
    if (gapTime < onedayTimeIntervalValue * 3) {
        int gapDay = gapTime/(60*60*24) ;
        if(gapDay == 0) //在24小时内,存在跨天的现象. 判断两个时间是否在同一天内
        {
            BOOL isSameDay = msgDateComponents.day == nowDateComponents.day;
            result = isSameDay ? [[NSString alloc] initWithFormat:@"%@ %zd:%02d",result,hour,(int)msgDateComponents.minute] : (showDetail?  [[NSString alloc] initWithFormat:@"昨天%@ %zd:%02d",result,hour,(int)msgDateComponents.minute] : @"昨天");
        }
        else if(gapDay == 1)//昨天
        {
            result = showDetail?  [[NSString alloc] initWithFormat:@"昨天%@ %zd:%02d",result,hour,(int)msgDateComponents.minute] : @"昨天";
        }
        else if(gapDay == 2) //前天
        {
            result = showDetail? [[NSString alloc] initWithFormat:@"前天%@ %zd:%02d",result,hour,(int)msgDateComponents.minute] : @"前天";
        }
    }
    else if([nowDate timeIntervalSinceDate:msgDate] < 7 * onedayTimeIntervalValue)//一周内
    {
        NSString *weekDay = [GNRUtil weekdayStr:msgDateComponents.weekday];
        result = showDetail? [weekDay stringByAppendingFormat:@"%@ %zd:%02d",result,hour,(int)msgDateComponents.minute] : weekDay;
    }
    else//显示日期
    {
        NSString *day = [NSString stringWithFormat:@"%zd-%zd-%zd", msgDateComponents.year, msgDateComponents.month, msgDateComponents.day];
        result = showDetail? [day stringByAppendingFormat:@" %@ %zd:%02d",result,hour,(int)msgDateComponents.minute]:day;
    }
    return result;
}

#pragma mark - Private

+ (NSString *)getPeriodOfTime:(NSInteger)time withMinute:(NSInteger)minute
{
    NSInteger totalMin = time *60 + minute;
    NSString *showPeriodOfTime = @"";
    if (totalMin > 0 && totalMin <= 5 * 60)
    {
        showPeriodOfTime = @"凌晨";
    }
    else if (totalMin > 5 * 60 && totalMin < 12 * 60)
    {
        showPeriodOfTime = @"上午";
    }
    else if (totalMin >= 12 * 60 && totalMin <= 18 * 60)
    {
        showPeriodOfTime = @"下午";
    }
    else if ((totalMin > 18 * 60 && totalMin <= (23 * 60 + 59)) || totalMin == 0)
    {
        showPeriodOfTime = @"晚上";
    }
    return showPeriodOfTime;
}

+(NSString*)weekdayStr:(NSInteger)dayOfWeek
{
    static NSDictionary *daysOfWeekDict = nil;
    daysOfWeekDict = @{@(1):@"星期日",
                       @(2):@"星期一",
                       @(3):@"星期二",
                       @(4):@"星期三",
                       @(5):@"星期四",
                       @(6):@"星期五",
                       @(7):@"星期六",};
    return [daysOfWeekDict objectForKey:@(dayOfWeek)];
}

@end
