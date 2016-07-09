//
//  Good.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/2.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "Good.h"

@implementation Good



- (instancetype)initWithDictionary:(NSDictionary*)dic {
    self = [super init];
    if (self) {
        self.bookISBN = [dic objectForKey:@"promotionBookISBN"];
        self.bookName = [dic objectForKey:@"promotionBookName"];
        self.bookImageLink = [dic objectForKey:@"promotionBookImageLink"];
        self.bookPrice = [dic objectForKey:@"promotionBookPrice"];
        self.relatedPromotionID = [dic objectForKey:@"promotionID"];
        self.amout = [dic objectForKey:@"bookAmount"];
        self.promotionName = [dic objectForKey:@"promotionName"];
    }
    return  self;
}

- (instancetype)initWithDicInCOrder:(NSDictionary*)dic{
    self = [super init];
    if (self) {
        self.bookISBN = [dic objectForKey:@"promotionBookISBN"];
        self.bookName = [dic objectForKey:@"bookName"];
        self.bookImageLink = [dic objectForKey:@"promotionBookImageLink"];
        self.bookPrice = [dic objectForKey:@"promotionBookPrice"];
        self.relatedPromotionID = [dic objectForKey:@"promotionID"];
        self.amout = [dic objectForKey:@"bookAmount"];
        self.promotionName = [dic objectForKey:@"promotionName"];
    }
    return  self;
}

- (id)copyWithZone:(NSZone *)zone {
    Good *item = [[[self class] allocWithZone:zone] init];
    item.bookISBN = self.bookISBN;
    item.bookName = self.bookName;
    item.bookImageLink = self.bookImageLink;
    item.bookPrice = self.bookPrice;
    item.relatedPromotionID = self.relatedPromotionID;
    item.amout = self.amout;
    item.promotionName = self.promotionName;
    return item;
}


@end
