//
//  CalendarViewController.m
//  exercise2
//
//  Created by koji on 13/10/17.
//  Copyright (c) 2013年 Free-quency Co.,Ltd. All rights reserved.
//

#import "CalendarViewController.h"
#import "TitleViewController.h"
#import "DateGridViewController.h"

@interface CalendarViewController ()

@end

@implementation CalendarViewController{
    AppData *_appData;
    TitleViewController *_titleViewController;
    DateGridViewController *_dateGridViewController;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        // Custom initialization
        _appData = [AppData sharedManager];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _titleViewController = [[TitleViewController alloc] initWithNibName:@"TitleViewController" bundle:nil];
    [[self view] addSubview:[_titleViewController view]];
    
    _dateGridViewController = [[DateGridViewController alloc] initWithNibName:@"DateGridViewController" bundle:nil];
    [[self view] addSubview:[_dateGridViewController view]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onChangeOrientation:) name:@"orientation" object:nil];
}
- (void)onChangeOrientation:(NSNotification*)note{
    [self adjust];
}

- (void)adjust{
    //FUNC();
    int w = [_appData width];
    int h = [_appData height];

    [self view].width = w;
    [self view].height = h;
    
    //PORTRAIT
    if(w < h){
        if(IS_IPHONE == YES){
            //LOG(@"PORTRAIT IPHONE");
            
        }else{
            
        }
        
        //LANDSCAPE
    }else{
        if(IS_IPHONE == YES){

        }else{
            
        }
    }
}

- (void)setYM:(int)year month:(int)month{
    [_dateGridViewController setYM:year month:month];
    [_titleViewController setYM:year month:month];
}














@end