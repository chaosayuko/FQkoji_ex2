//
//  DateViewController.m
//  exercise2
//
//  Created by koji on 13/10/16.
//  Copyright (c) 2013年 Free-quency Co.,Ltd. All rights reserved.
//

#import "DateViewController.h"

@interface DateViewController ()

@end

@implementation DateViewController{
    IBOutlet UILabel *_dateLabel;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)setDay:(int)day weekDay:(int)weekDay isToday:(BOOL)isToday{
    LOG(@"setDay:%d (%d)", day, weekDay);
    if(day == 0){
        [_dateLabel setText:@""];
        [[self view] setAlpha:0.7];
    }else{
        [_dateLabel setText:ITOSTR(day)];
        [[self view] setAlpha:1];

        //(1:日、2:月〜7:土)
        if(weekDay == 1){
            [_dateLabel setTextColor:RGB(0xcc, 0, 0)];
        }else if(weekDay == 7){
            [_dateLabel setTextColor:RGB(0, 0, 0xcc)];
        }else{
            [_dateLabel setTextColor:RGB(0, 0, 0)];
        }
    }
    
    if(isToday == YES){
        [[self view] setBackgroundColor:RGB(255, 210, 210)];
    }else{
        [[self view] setBackgroundColor:[UIColor whiteColor]];
    }
}

- (void)setSize:(int)width height:(int)height{
    [self view].width = width;
    [self view].height = height;
    
    _dateLabel.y = floor((height - _dateLabel.height) / 2);


    if(IS_IPAD == YES){
        //_dateLabel.width = 100;
        _dateLabel.x = 0;
        _dateLabel.y = 8;
    }
}

@end
