//
//  HomeSearchListItem.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/6/29.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "HomeSearchListItem.h"

@implementation HomeSearchListItem
- (instancetype)initBook:(NSString*)aName doubanLink:(NSString*)aLink imgLink:(NSString*)bLink  detail:(NSString*)aDetail lowestPrice:(NSString*)aPrice {
    self = [super init];
    if (self) {
        self.bookName = aName;
        self.booSubject = aLink;
        self.bookImageLink = bLink;
        self.bookDetail = aDetail;
        self.bookLowestPrice = aPrice;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    HomeSearchListItem *info = [[[self class] allocWithZone:zone] init];
    info.bookName = self.bookName;
    info.booSubject = self.booSubject;
    info.bookImageLink = self.bookImageLink;
    info.bookDetail = self.bookDetail;
    info.bookLowestPrice = self.bookLowestPrice;
    return info;
}
@end
