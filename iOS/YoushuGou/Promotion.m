//
//  Promotion.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/6/28.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "Promotion.h"

@implementation Promotion
- (instancetype) initPromotion:(NSString*)pID withName:(NSString*)pName urlString:(NSString*)pLink company:(NSString*)pCompany deadLine:(NSString*)pDeadLine type:(PromotionType) pType {
    if (self = [super init])
    {
        self.promotionID = pID;
        self.promotionName = pName;
        self.promotionLink = pLink;
        self.promotionCompany = pCompany;
        self.promotionDeadline = pDeadLine;
        self.promotionType = pType;
    }
    return  self;
}

- (id)copyWithZone:(NSZone *)zone {
    Promotion *info = [[[self class] allocWithZone:zone] init];
    info.promotionID = self.promotionID;
    info.promotionName = self.promotionName;
    info.promotionLink = self.promotionLink;
    info.promotionCompany = self.promotionCompany;
    info.promotionDeadline = self.promotionDeadline;
    info.promotionType = self.promotionType;
    return info;
}



@end
