//
//  Good.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/2.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "Good.h"

@implementation Good
- (instancetype)initBook:(NSString*)isbn name:(NSString*)bName imageLink:(NSString*)bLink price:(NSString*)bPrice inPromotionID:(NSString*)promotionID promotionName:(NSString*)pName amout:(NSString*)bAmout {
    self = [super init];
    self.bookISBN = isbn;
    self.bookName = bName;
    self.bookImageLink = bLink;
    self.bookPrice = bPrice;
    self.relatedPromotionID = promotionID;
    self.amout = bAmout;
    self.promotionName = pName;
    return  self;
}
@end
