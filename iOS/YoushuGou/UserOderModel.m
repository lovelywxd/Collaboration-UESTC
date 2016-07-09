//
//  UserOderModel.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/9.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "UserOderModel.h"

@implementation UserOderModel
- (instancetype)init:(NSString*)orderID with:(NSArray*)bookList inPromotion:(NSString*)proID {
    self = [super init];
    if (self) {
        self.orderID = orderID;
        self.bookIsbnList = bookList;
        self.promotionID = proID;
    }
    return self;

}

- (id)copyWithZone:(NSZone *)zone {
    UserOderModel *item = [[[self class] allocWithZone: zone] init];
    item.orderID = self.orderID;
    item.bookIsbnList = self.bookIsbnList;
    item.promotionID = self.promotionID;
    return self;
}

@end
