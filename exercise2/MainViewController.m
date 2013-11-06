//
//  MainViewController.m
//  exercise2
//
//  Created by koji on 13/10/16.
//  Copyright (c) 2013年 Free-quency Co.,Ltd. All rights reserved.
//

#import "MainViewController.h"
#import "CalendarViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController{
    CalendarViewController *_calendarViewController1;
    CalendarViewController *_calendarViewController2;
    
    int _currentYear;
    int _currentMonth;
    
    CalendarViewController *_currentCalendarViewController;
    CalendarViewController *_nextCalendarViewController;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad{
    FUNC();
    [super viewDidLoad];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"yyyy"];
    _currentYear = [[df stringFromDate:[NSDate date]] intValue];
    
    [df setDateFormat:@"MM"];
    _currentMonth = [[df stringFromDate:[NSDate date]] intValue];
    
    LOG(@"_currentYear:%d", _currentYear);
    LOG(@"_currentMonth:%d", _currentMonth);

    
    _calendarViewController1 = [[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil];
    [[self view] addSubview:[_calendarViewController1 view]];

    _calendarViewController2 = [[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil];
    [[self view] addSubview:[_calendarViewController2 view]];
    [[_calendarViewController2 view] setHidden:YES];
    

    [_calendarViewController1 setYM:_currentYear month:_currentMonth];

    
    _currentCalendarViewController = _calendarViewController1;
    _nextCalendarViewController = _calendarViewController2;

    
	UISwipeGestureRecognizer* swipeUpGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipe:)];
    [swipeUpGesture setDirection:UISwipeGestureRecognizerDirectionUp];
    [[self view] addGestureRecognizer:swipeUpGesture];
    
	UISwipeGestureRecognizer* swipeDownGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipe:)];
    [swipeDownGesture setDirection:UISwipeGestureRecognizerDirectionDown];
    [[self view] addGestureRecognizer:swipeDownGesture];

	UISwipeGestureRecognizer* swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipe:)];
    [swipeLeftGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:swipeLeftGesture];

	UISwipeGestureRecognizer* swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipe:)];
    [swipeRightGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:swipeRightGesture];
    
    
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [[self view] addGestureRecognizer:doubleTapGesture];
}

- (void)onSwipe:(id)sender{
	//LOG(@"onSwipe");
    
    if(_currentCalendarViewController == _calendarViewController1){
        _nextCalendarViewController = _calendarViewController2;
    }else{
        _nextCalendarViewController = _calendarViewController1;
    }

    int width = [[super appData] width];
    int height = [[super appData] height];

    int currentToX = 0;
    int currentToY = 0;
    int nextFromX = 0;
    int nextFromY = 0;

    [[_nextCalendarViewController view] setHidden:NO];

    if([sender direction] == UISwipeGestureRecognizerDirectionUp){
        LOG(@"UP:翌年");
        currentToY = -height;
        nextFromY = height;

        _currentYear++;

    }else if([sender direction] == UISwipeGestureRecognizerDirectionDown){
        LOG(@"DOWN:前年");
        currentToY = height;
        nextFromY = -height;

        _currentYear--;
        
    }else if([sender direction] == UISwipeGestureRecognizerDirectionLeft){
        LOG(@"LEFT:翌月");
        currentToX = -width;
        nextFromX = width;
        
        _currentMonth++;
        if(_currentMonth > 12){
            _currentYear++;
            _currentMonth = 1;
        }
    }else if([sender direction] == UISwipeGestureRecognizerDirectionRight){
        LOG(@"RIGHT:前月");
        currentToX = width;
        nextFromX = -width;

        _currentMonth--;
        if(_currentMonth < 1){
            _currentYear--;
            _currentMonth = 12;
        }
    }

    [_nextCalendarViewController setYM:_currentYear month:_currentMonth];

    [_nextCalendarViewController view].x = nextFromX;
    [_nextCalendarViewController view].y = nextFromY;

    [UIView animateWithDuration:0.3f
                      delay:0
                    options:UIViewAnimationOptionCurveEaseOut
                 animations:^{
                     [_currentCalendarViewController view].x = currentToX;
                     [_currentCalendarViewController view].y = currentToY;
                     [_nextCalendarViewController view].x = 0;
                     [_nextCalendarViewController view].y = 0;
                 }completion:^(BOOL finished){
                     [[_currentCalendarViewController view] setHidden:YES];
                     _currentCalendarViewController = _nextCalendarViewController;
                 }];

}

- (void)onDoubleTap:(UIGestureRecognizer *)sender{
    FUNC();
    NSDateFormatter *df = [[NSDateFormatter alloc] init];

    [df setDateFormat:@"yyyy"];
    int thisYear = [[df stringFromDate:[NSDate date]] intValue];
    
    [df setDateFormat:@"MM"];
    int thisMonth = [[df stringFromDate:[NSDate date]] intValue];


    if(_currentYear != thisYear || _currentMonth != thisMonth){
        _currentMonth = thisMonth;
        _currentYear = thisYear;
        
        if(_currentCalendarViewController == _calendarViewController1){
            _nextCalendarViewController = _calendarViewController2;
        }else{
            _nextCalendarViewController = _calendarViewController1;
        }
        
        [_nextCalendarViewController setYM:thisYear month:thisMonth];
        [[_nextCalendarViewController view] setAlpha:0];
        [[_nextCalendarViewController view] setHidden:NO];
        [_nextCalendarViewController view].x = 0;
        [_nextCalendarViewController view].y = 0;
        
        [UIView animateWithDuration:0.3f
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [[_currentCalendarViewController view] setAlpha:0];
                         }completion:^(BOOL finished){
                         }];
        [UIView animateWithDuration:0.3f
                              delay:0.2f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             [[_nextCalendarViewController view] setAlpha:1];
                         }completion:^(BOOL finished){
                             [[_currentCalendarViewController view] setHidden:YES];
                             [[_currentCalendarViewController view] setAlpha:1];
                             _currentCalendarViewController = _nextCalendarViewController;
                         }];
    }
    
}
@end
