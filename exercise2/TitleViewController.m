//
//  TitleViewController.m
//  exercise2
//
//  Created by koji on 13/10/16.
//  Copyright (c) 2013年 Free-quency Co.,Ltd. All rights reserved.
//

#import "TitleViewController.h"

@interface TitleViewController ()

@end

@implementation TitleViewController{
    AppData *_appData;
    
    IBOutlet UIView *_portraitView;
    IBOutlet UILabel *_portraitMonth;
    IBOutlet UILabel *_portraitMonthName;
    IBOutlet UILabel *_portraitYear;

    IBOutlet UIView *_landscapeView;
    IBOutlet UILabel *_landscapeMonth;
    IBOutlet UILabel *_landscapeMonthName;
    IBOutlet UILabel *_landscapeYear;
    
    NSArray *_monthName;
    NSArray *_monthColor;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        // Custom initialization
        _appData = [AppData sharedManager];
        
        _monthName = [NSArray arrayWithObjects:@"", @"JANUARY", @"FEBRUARY", @"MARCH ", @"APRIL", @"MAY", @"JUNE", @"JULY", @"AUGUST", @"SEPTEMBER", @"OCTOBER", @"NOVEMBER", @"DECEMBER", nil];
        _monthColor = [NSArray arrayWithObjects:@"",
                       RGB(0xff, 0x14, 0x93), RGB(0xff, 0xd7, 0x00), RGB(0x2e, 0x8b, 0x57),
                       RGB(0xdb, 0x70, 0x93), RGB(0x32, 0xcd, 0x32), RGB(0xba, 0x55, 0xd3),
                       RGB(0x64, 0x95, 0xed), RGB(0xff, 0x8c, 0xed), RGB(0xff, 0xa0, 0x7a),
                       RGB(0xd2, 0x69, 0x1e), RGB(0x77, 0x88, 0x99), RGB(0x00, 0x00, 0x8b), nil];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onChangeOrientation:) name:@"orientation" object:nil];
}
- (void)onChangeOrientation:(NSNotification*)note{
    [self adjust];
}

- (void)adjust{
    //FUNC();
    int w = [_appData width];
    int h = [_appData height];

    int gap;
    
    [_portraitView setHidden:YES];
    [_landscapeView setHidden:YES];

    //PORTRAIT
    if(w < h){
        [_portraitView setHidden:NO];
        if(IS_IPHONE == YES){
            //LOG(@"PORTRAIT IPHONE");
            [self view].x = 9;
            [self view].width = w - ([self view].x*2);

            [self view].height = 100;

            //dategrid:290
            gap = 10;
            
            int calendarHeight = [self view].height + gap + 290;
            [self view].y = (h - calendarHeight) / 2;
            
            
        }else{
            [self view].x = 30;
            [self view].width = w - ([self view].x*2);
            
            [self view].height = 150;
            
            //dategrid:290
            gap = 10;
            
            int calendarHeight = [self view].height + gap + 580;
            [self view].y = (h - calendarHeight) / 2;

            _portraitYear.y = 5;
            _portraitYear.x = [self view].width - _portraitYear.width - 10;
        }
        
    //LANDSCAPE
    }else{
        [_landscapeView setHidden:NO];
        if(IS_IPHONE == YES){
            [self view].width = 100;
            
            int dategridWidth = 302;
            gap = 10;
            int calendarWidth = [self view].width + gap + dategridWidth;
            
            [self view].x = (w - calendarWidth) / 2;
            
            [self view].height = 290;
            [self view].y = (h - [self view].height) / 2;
            
            _landscapeYear.x = [self view].width - _landscapeYear.width - 10;
            _landscapeYear.y = [self view].height - _landscapeYear.height;
        }else{
            [self view].width = 150;
            
            int dategridWidth = 708;
            gap = 20;
            int calendarWidth = [self view].width + gap + dategridWidth;
            
            [self view].x = (w - calendarWidth) / 2;
            
            [self view].height = 580;
            [self view].y = (h - [self view].height) / 2;
            
            _landscapeYear.x = [self view].width - _landscapeYear.width - 10;
            _landscapeYear.y = [self view].height - _landscapeYear.height;
            
        }
    }
}
/*
 IBOutlet UIView *_portraitView;
 IBOutlet UILabel *_portraitMonth;
 IBOutlet UILabel *_portraitMonthName;
 IBOutlet UILabel *_portraitYear;
 
 IBOutlet UIView *_landscapeView;
 IBOutlet UILabel *_landscapeMonth;
 IBOutlet UILabel *_landscapeMonthName;
 IBOutlet UILabel *_landscapeYear;
 */

- (void)setYM:(int)year month:(int)month{
    [_portraitMonth setText:ITOSTR(month)];
    [_portraitMonthName setText:[_monthName objectAtIndex:month]];
    [_portraitYear setText:ITOSTR(year)];

    [_landscapeMonth setText:ITOSTR(month)];
    [_landscapeMonthName setText:[_monthName objectAtIndex:month]];
    [_landscapeYear setText:ITOSTR(year)];
    
    [[self view] setBackgroundColor:[_monthColor objectAtIndex:month]];
}

@end
