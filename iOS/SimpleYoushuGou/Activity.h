//
//  Activity.h
//  MyBookRecycle
//
//  Created by 苏丽荣 on 16/6/25.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Activity : NSObject
@property (nonatomic,copy)NSString* activityId;
@property (nonatomic,copy)NSString* activityName;
//@property (nonatomic,copy)NSString* detail;
@property (nonatomic,copy)NSString* activityUrl;
- (instancetype) init:(NSString*)id withName:(NSString*)name urlString:(NSString*)url;
@end
