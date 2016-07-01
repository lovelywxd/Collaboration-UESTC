//
//  promotionSearchListItem.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/1.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "promotionSearchListItem.h"

@implementation promotionSearchListItem
- (instancetype)initItem:(NSString*)aIsbn withName:(NSString*)name price:(NSString*)aPrice imageLink:(NSString*)imgLink detailLink:(NSString*)aLink {
    self = [super init];
    if (self) {
        self.promotionBookISBN = aIsbn;
        self.promotionBookName = name;
        self.promotionBookPrice = aPrice;
        self.promotionBookImageLink = imgLink;
        self.promotionBookDetailLink = aLink;
    }
    return  self;
}

- (id)copyWithZone:(NSZone *)zone {
    promotionSearchListItem *item = [[[self class] allocWithZone:zone] init];
    item.promotionBookISBN = self.promotionBookISBN;
    item.promotionBookName = self.promotionBookName;
    item.promotionBookPrice = self.promotionBookPrice;
    item.promotionBookImageLink = self.promotionBookImageLink;
    item.promotionBookDetailLink = self.promotionBookDetailLink;
    return item;
}
@end
