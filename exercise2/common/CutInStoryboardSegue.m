//
//  CutInStoryboardSegue.m
//  common
//
//  Created by koji on 12/10/19.
//  Copyright (c) 2012年 koji. All rights reserved.
//

#import "CutInStoryboardSegue.h"

@implementation CutInStoryboardSegue

- (void)perform{
    FUNC();
    [self.sourceViewController presentModalViewController:self.destinationViewController animated:NO];
}

@end
