//
//  Activity.h
//  MyBookRecycle
//
//  Created by 苏丽荣 on 16/6/25.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ActivityType) {
    GroupBuy = 0,//满减类的，需要拼购的
    PartDiscout = 1,//非满减类，但是只有部分书籍参加活动，需要我们给出活动书籍列表
    Other = 2,//直接将用户导向电商网站的活动
};

@interface Activity : NSObject
@property (nonatomic,copy)NSString* activityId;
@property (nonatomic,copy)NSString* activityName;
//@property (nonatomic,copy)NSString* detail;
@property (nonatomic,copy)NSString* activityUrl;
@property (readwrite, nonatomic, assign) ActivityType activityType;

- (instancetype) init:(NSString*)id withName:(NSString*)name activiType:(ActivityType) type urlString:(NSString*)url;
@end
