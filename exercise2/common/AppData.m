//
//  AppData.m
//  common
//
//  Created by koji.
//  Copyright (c) 2012年 fq. All rights reserved.
//

#import "AppData.h"

@implementation AppData{

}

static AppData* sharedAppData = nil;

@synthesize userName;

+ (AppData*)sharedManager{
	@synchronized(self){
		if(sharedAppData == nil){
			sharedAppData = [[self alloc] init];
		}
	}
	return sharedAppData;
}

- (AppData *)init{
	return self;
}




@end
