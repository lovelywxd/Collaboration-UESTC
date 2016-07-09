//
//  GoodModel.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/8.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "GoodModel.h"

@implementation GoodModel
- (instancetype) initWithDictionary:(NSDictionary*)dic {
    self = [super init];
    if (self) {
        self.bookISBN = [dic objectForKey:@"promotionBookISBN"];
        self.bookName = [dic objectForKey:@"bookName"];
        self.bookImageLink = [dic objectForKey:@"promotionBookImageLink"];
        self.bookPrice = [dic objectForKey:@"promotionBookPrice"];
        self.relatedPromotionID = [dic objectForKey:@"promotionID"];
        self.amout = [dic objectForKey:@"bookAmount"];
        self.promotionName = [dic objectForKey:@"promotionName"];
        self.isSelected = NO;//初始化为未选择
        self.isEditStyle = NO;//初始化为非编辑状态

    }
    return  self;
}

- (id)copyWithZone:(NSZone *)zone {
    GoodModel *item = [[[self class] allocWithZone:zone] init];
    item.bookISBN = self.bookISBN;
    item.bookName = self.bookName;
    item.bookImageLink = self.bookImageLink;
    item.bookPrice = self.bookPrice;
    item.relatedPromotionID = self.relatedPromotionID;
    item.amout = self.amout;
    item.promotionName = self.promotionName;
    item.isSelected = self.isSelected;//初始化为未选择
    item.isEditStyle = self.isEditStyle;//初始化为非编辑状态
    return item;
}

@end
