//
//  BookBaseInfo.m
//  MyBookRecycle
//
//  Created by 苏丽荣 on 16/6/26.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "BookBaseInfo.h"

@implementation BookBaseInfo
- (instancetype)initBook:(NSString*)Isbn withOriginalPrice:(NSString*)oPrice currentPrice:(NSString*)cPrice inPromotion:(NSString*)promotionId
{
    self = [super init];
    if (self) {
        self.PromotionBookISBN = Isbn;
        self.PromotionID = promotionId;
        self.PromotionBookPrice = oPrice;
        self.PromotionBookCurrentPrice = cPrice;
    }
    return self;
}
@end
