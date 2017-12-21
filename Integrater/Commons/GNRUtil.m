//
//  NSDate+GNRExtension.m
//  Integrater
//
//  Created by LvYuan on 2017/3/25.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRUtil.h"

@implementation GNRUtil

+ (void)alertMessage:(NSString *)msg{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"知道了"];
    [alert setMessageText:msg];
    [alert setAlertStyle:NSAlertStyleWarning];
    [alert beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSModalResponse returnCode) {
    }];
}

+ (void)alertMessage:(NSString *)msg cancel:(NSString *)cancel confirm:(NSString *)confirm completion:(void (^)(NSInteger code))completion{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:confirm?:@"确定"];
    [alert addButtonWithTitle:cancel?:@"取消"];
    [alert setMessageText:msg];
    [alert setAlertStyle:NSAlertStyleCritical];
    [alert beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSModalResponse returnCode) {
        if(completion){
            completion(returnCode);
        }
    }];
}

+ (void)alertMessage:(NSString *)msg cancel:(NSString *)cancel ortherBtns:(NSArray *)ortherBtns completion:(void (^)(NSInteger code))completion{
    NSAlert *alert = [[NSAlert alloc] init];
    [ortherBtns enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [alert addButtonWithTitle:obj?:@""];
    }];
    [alert addButtonWithTitle:cancel?:@"取消"];
    [alert setMessageText:msg];
    [alert setAlertStyle:NSAlertStyleInformational];
    [alert beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSModalResponse returnCode) {
        if(completion){
            completion(returnCode);
        }
    }];
}

+ (BOOL)createPlist:(id)data path:(NSString *)path{
    BOOL flag = NO;
    if ([data isKindOfClass:[NSDictionary class]]||
        [data isKindOfClass:[NSArray class]]) {
        flag = [data writeToFile:path atomically:YES];
        if (flag) {
            GLog(@"plist 文件写入成功");
        }else{
            GLog(@"plist 文件写入失败");
        }
    }else{
        GLog(@"写入数据错误！");
    }
    return flag;
}

+ (BOOL)createDir:(NSString *)path{
    NSError * error = nil;
    BOOL ret = [[NSFileManager defaultManager]createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    GLog(@"Create path error %@",error.domain);
    return ret;
}

+ (NSColor *)randColor{
    float r = arc4random_uniform(256);
    float g = arc4random_uniform(256);
    float b = arc4random_uniform(256);
    return [NSColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:1];
}

+ (NSColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    // if ([cString length] < 6) return DEFAULT_VOID_COLOR;
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }
    
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    
    // if ([cString length] != 6) return DEFAULT_VOID_COLOR;
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    NSColor  * cl = [NSColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:1];
    return cl;
}

//MARK: - path select board
+ (NSString *)openPanelForCanCreateDir:(BOOL)canCreateDir canChooseDir:(BOOL)canChooseDir canChooseFiles:(BOOL)canChooseFiles{
    NSOpenPanel * panel = [NSOpenPanel openPanel];
    [panel setMessage:canCreateDir?@"请选择文件夹":@"请选择文件"];
    [panel setPrompt:@"确定"];
    [panel setCanChooseDirectories:canCreateDir];//是否可选择目录
    [panel setCanCreateDirectories:canChooseDir];//是否可创建目录
    [panel setCanChooseFiles:canChooseFiles];//是否可选择文件
    NSString * path = nil;
    NSInteger result = [panel runModal];
    if (result == NSFileHandlingPanelOKButton) {
        path = [panel URL].path;
    }
    return path;
}

+ (NSString*)standardTimeForFile:(NSDate*)date{
    NSDateFormatter *Formatter=[[NSDateFormatter alloc]init];
    [Formatter setDateFormat:@"yyyy_MM_dd_HH_mm_ss"];
    return [Formatter stringFromDate:date];
}

+ (NSString*)standardDateForFile:(NSDate*)date{
    NSDateFormatter *Formatter=[[NSDateFormatter alloc]init];
    [Formatter setDateFormat:@"yyyy_MM_dd"];
    return [Formatter stringFromDate:date];
}

+ (NSString*)standardTime:(NSDate*)date{
    NSDateFormatter *Formatter=[[NSDateFormatter alloc]init];
    [Formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [Formatter stringFromDate:date];
}

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

//复制到剪贴板
+ (BOOL)writeFileContentsToPastBoard:(NSString *)content{
    if (content) {
        NSPasteboard *pastboard = [NSPasteboard generalPasteboard];
        [pastboard clearContents];
        BOOL ret = [pastboard writeObjects:@[content]];
        return ret;
    }
    return NO;
}

@end
