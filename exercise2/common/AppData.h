//
//  AppData.h
//  common
//
//  Created by koji.
//  Copyright (c) 2012年 fq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppData : NSObject

@property (readwrite, nonatomic) int width;
@property (readwrite, nonatomic) int height;
@property (readwrite, strong, nonatomic) NSString *userName;

+ (AppData *)sharedManager;

@end

