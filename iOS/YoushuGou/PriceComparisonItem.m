//
//  PriceComparisonItem.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/6/30.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "PriceComparisonItem.h"

@implementation PriceComparisonItem
- (instancetype)initSaler:(NSString*)saler withPrice:(NSString*)price link:(NSString*)aLink {
    self = [super init];
    if (self) {
        self.bookSaler = saler;
        self.bookCurrentPrice = price;
        self.bookLink = aLink;
    }
    return  self;
}
@end
