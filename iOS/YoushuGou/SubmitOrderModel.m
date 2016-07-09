//
//  SubmitOrderModel.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/9.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "SubmitOrderModel.h"
#import "Good.h"

@implementation SubmitOrderModel
- (instancetype)initWithDictionary:(NSDictionary*)dic {
    self = [super init];
    if (self) {
        self.submitOrderID = [dic objectForKey:@"submitOrderID"];
        self.currentStatus = [dic objectForKey:@"currentStatus"];
        
        NSArray *books = [dic objectForKey:@"bookList"];
        NSMutableArray *bList = [[NSMutableArray alloc] init];
        for (id book in books) {
            Good *bookInfo = [[Good alloc] initWithDictionary:book];
            [bList addObject:bookInfo];
        }
        self.bookList = [bList copy];
    }
    return  self;
}
@end
