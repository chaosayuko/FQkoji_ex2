//
//  BaseViewController.m
//  common
//
//  Created by koji.
//  Copyright (c) 2012年 fq. All rights reserved.
//


#import "BaseViewController.h"

@implementation BaseViewController{
}

@synthesize appData;

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        appData = [AppData sharedManager];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (NSUInteger)supportedInterfaceOrientations{
    if(ORIENTATION) [self setScreenSize:ORIENTATION];
	return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    [self setScreenSize:interfaceOrientation];
    return YES;
}

- (void)setScreenSize:(int)orientation{
    //FUNC();
    int w;
    int h;
    if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
        w = [[UIScreen mainScreen] bounds].size.width;
        h = [[UIScreen mainScreen] bounds].size.height;
    }else{
        w = [[UIScreen mainScreen] bounds].size.height;
        h = [[UIScreen mainScreen] bounds].size.width;
    }
    //LOG(@"w: %d", w);
    //LOG(@"h: %d", h);

    int preW = [appData width];
    [appData setWidth:w];
    [appData setHeight:h];
    
    if(w != preW){
        LOG(@" <<orientation changed>> ");
        LOG(@"  w: %d", w);
        LOG(@"  h: %d", h);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"orientation" object:nil userInfo:nil];
    }
}

@end
