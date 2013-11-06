//
//  DateGridViewController.m
//  exercise2
//
//  Created by koji on 13/10/16.
//  Copyright (c) 2013年 Free-quency Co.,Ltd. All rights reserved.
//

#import "DateGridViewController.h"
#import "DateViewController.h"

@interface DateGridViewController ()

@end

@implementation DateGridViewController{
    AppData *_appData;
    NSMutableArray *_dateViewControllers;

    int _width;
    int _height;

    int _currentYear;
    int _currentMonth;

    NSMutableArray *_weekLabels;

    int _weekNum;
    int _labelHeight;
    int _dateGridViewWidth;
    int _dateGridViewHeight;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        // Custom initialization
        _appData = [AppData sharedManager];
        if(IS_IPHONE == YES){
            _width = 302;
            _height = 290;
            _dateGridViewWidth = 42;
        }else{
            _width = 708;
            _height = 580;
            _dateGridViewWidth = 100;
        }
        _weekNum = 6;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    _weekLabels  = [NSMutableArray array];
    for(UIView *v in [[self view] subviews]){
        if([v tag] > 0) [_weekLabels addObject:v];
    }

    _dateViewControllers = [NSMutableArray array];
    for(int i = 0; i < _weekNum; i++){
        for(int j = 0; j < 7; j++){
            DateViewController *dvc = [[DateViewController alloc] initWithNibName:@"DateViewController" bundle:nil];
            [[self view] addSubview:[dvc view]];

            [_dateViewControllers addObject:dvc];
        }
    }
    
    [self setDateSize];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onChangeOrientation:) name:@"orientation" object:nil];
}


- (void)setDateSize{
    //セルの高さの計算
    _dateGridViewHeight = floor(((_height - DEFAULT_LABEL_HEIGHT) - (_weekNum + 2)) / _weekNum);
    _labelHeight = _height - (_dateGridViewHeight * _weekNum + (_weekNum + 2));

    //LABELの幅・高さの調整
    for(int i = 0; i < [_weekLabels count]; i++){
        UIView *weekLabel = [_weekLabels objectAtIndex:i];
        weekLabel.height = _labelHeight;
        
        if(IS_IPAD == YES){
            weekLabel.width = _dateGridViewWidth;
            weekLabel.x = 1 + (_dateGridViewWidth + 1) * i;
        }

        for(UIView *v in [weekLabel subviews]){
            if([v tag] == 1){
                v.width = _dateGridViewWidth;
                v.y = (_labelHeight - v.height) / 2;
                if(IS_IPAD == YES){
                    weekLabel.width = _dateGridViewWidth;
                    weekLabel.x = 1 + (_dateGridViewWidth + 1) * i;
                }
            }
        }

    }

    for(int i = 0; i < 6; i++){
        for(int j = 0; j < 7; j++){
            DateViewController *dvc = [_dateViewControllers objectAtIndex:(i * 7 + j)];

            [dvc view].x = 1 + j * (_dateGridViewWidth + 1);
            [dvc view].y = 1 + _labelHeight + 1 + i * (_dateGridViewHeight + 1);
            
            [dvc setSize:_dateGridViewWidth height:_dateGridViewHeight];

            [[dvc view] setHidden:NO];
            if(_weekNum <= i) [[dvc view] setHidden:YES];
        }
    }
}

- (void)onChangeOrientation:(NSNotification*)note{
    [self adjust];
}

- (void)adjust{
    //FUNC();
    int w = [_appData width];
    int h = [_appData height];
    
    int gap;
    //PORTRAIT
    if(w < h){
        if(IS_IPHONE == YES){
            //LOG(@"PORTRAIT IPHONE");
            [self view].x = 9;
            [self view].width = w - ([self view].x*2);
            [self view].height = _height;
            
            int titleHeight = 100;
            gap = 10;
            int calendarHeight = titleHeight + gap + [self view].height;

            [self view].y = titleHeight + gap + (h - calendarHeight) / 2;
            
            
        }else{
            [self view].x = 30;
            [self view].width = w - ([self view].x*2);
            [self view].height = _height;
            
            int titleHeight = 150;
            gap = 20;
            int calendarHeight = titleHeight + gap + [self view].height;
            
            [self view].y = titleHeight + gap + (h - calendarHeight) / 2;
            
        }
        
    //LANDSCAPE
    }else{
        if(IS_IPHONE == YES){

            [self view].width = _width;

            int titleWidth = 100;
            gap = 10;
            int calendarWith = titleWidth + gap + [self view].width;

            [self view].x = titleWidth + gap + (w - calendarWith) / 2;
            
            [self view].height = _height;
            [self view].y = (h - [self view].height) / 2;

        }else{
            [self view].width = _width;
            
            int titleWidth = 150;
            gap = 20;
            int calendarWith = titleWidth + gap + [self view].width;
            
            [self view].x = titleWidth + gap + (w - calendarWith) / 2;
            
            [self view].height = _height;
            [self view].y = (h - [self view].height) / 2;
            
        }
    }
}


- (void)setYM:(int)year month:(int)month{
    FUNC();
    LOG(@"   year:%d", year);
    LOG(@"  month:%d", month);
    LOG(@"====================");

    _currentYear = year;
    _currentMonth = month;

    //指定月の1日
    NSDate *thisFirstDate = [self createDate:_currentYear month:_currentMonth day:1];

    //指定月の1日の曜日(1:日、2:月〜7:土)
    int thisFirstDateWeekday = [self getWeekday:thisFirstDate];

    int nextYear = _currentYear;
    int nextMonth = _currentMonth + 1;
    if(nextMonth > 12){
        nextYear++;
        nextMonth = 1;
    }

    //指定月の翌月の1日
    NSDate *nextFirstDate = [self createDate:nextYear month:nextMonth day:1];

    //指定月の最後の日
    NSDate *thisLastDate = [nextFirstDate initWithTimeInterval:-DAY_SECOND sinceDate:nextFirstDate];

    //指定月の日数
    int dayNum = [self getDay:thisLastDate];
    //LOG(@"dayNum:%d", dayNum);

    //最初の週の日数
    int firstWeekDays = 7 - thisFirstDateWeekday + 1;

    //指定月の週の数
    _weekNum = ceil((dayNum - firstWeekDays) / 7.0) + 1;
    //LOG(@"weekNum:%d", weekNum);


    //今日の取得
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy"];
    int thisYear = [[df stringFromDate:[NSDate date]] intValue];
    [df setDateFormat:@"MM"];
    int thisMonth = [[df stringFromDate:[NSDate date]] intValue];
    [df setDateFormat:@"dd"];
    int thisDay = [[df stringFromDate:[NSDate date]] intValue];
    
    int day = 1 - thisFirstDateWeekday + 1;
    LOG(@"day:%d", day);
    LOG(@"dayNum:%d", dayNum);

    for(int i = 0; i < [_dateViewControllers count]; i++){
        DateViewController *dvc = [_dateViewControllers objectAtIndex:i];

        BOOL isToday = NO;
        if(thisYear == _currentYear && thisMonth == _currentMonth && thisDay == day) isToday = YES;
        
        if(day >= 1 && day <= dayNum){
            int weekDay = (day + thisFirstDateWeekday - 2) % 7 + 1;
            [dvc setDay:day weekDay:weekDay isToday:isToday];
        }else{
            [dvc setDay:0 weekDay:0 isToday:isToday];
        }
        day++;
    }
    //LOG(@"weekday:%d", [self getWeekday:date]);

    [self setDateSize];

    LOG(@"thisLastDate:%@", thisLastDate);
    LOG(@"====================");
    
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    [df setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
//    NSString *str = [df stringFromDate:date];
//    LOG(@"%@", str);
//    LOG(@"====================");
}

- (int)getDay:(NSDate *)date{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd"];
    return [[df stringFromDate:date] intValue];
    
}


- (NSDate *)createDate:(int)year month:(int)month day:(int)day{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    
    return [calendar dateFromComponents:components];
}

- (int)getWeekday:(NSDate *)date{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    components = [calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit) fromDate:date];
    return [components weekday];
}

@end
