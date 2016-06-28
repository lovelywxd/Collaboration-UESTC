//
//  Promotion.h
//  YouShuGou
//
//  Created by 苏丽荣 on 16/6/28.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, PromotionType) {
    GroupBuy = 0,//满减类的，需要拼购的
    PartDiscout = 1,//非满减类，但是只有部分书籍参加活动，需要我们给出活动书籍列表
    Other = 2,//直接将用户导向电商网站的活动
};

@interface Promotion : NSObject <NSCopying>
@property (nonatomic, copy) NSString *promotionID;
@property (nonatomic, copy) NSString *promotionName;
@property (nonatomic, copy) NSString *promotionLink;
@property (nonatomic, copy) NSString *promotionCompany;
@property (nonatomic, copy) NSString *promotionDeadline;

@property (readwrite, nonatomic, assign) PromotionType promotionType;

- (instancetype) initPromotion:(NSString*)pID withName:(NSString*)pName urlString:(NSString*)pLink company:(NSString*)pCompany deadLine:(NSString*)pDeadLine type:(PromotionType) pType;


@end
