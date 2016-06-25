//
//  Activity.m
//  MyBookRecycle
//
//  Created by 苏丽荣 on 16/6/25.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "Activity.h"

@implementation Activity
- (instancetype) init:(NSString*)id withName:(NSString*)name urlString:(NSString*)url
{
    if (self = [super init])
    {
        self.activityId = id;
        self.activityName = name;
        self.activityUrl = url;
    }
    return  self;
}

- (NSString*)description{
    return [NSString stringWithFormat:@"activityId:%@,activityName:%@,activityUrl:%@",self.activityId,self.activityName,self.activityUrl];
}

@end
