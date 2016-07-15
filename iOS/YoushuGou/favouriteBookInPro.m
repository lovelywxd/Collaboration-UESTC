//
//  favouriteBookInPro.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/15.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "favouriteBookInPro.h"

@implementation favouriteBookInPro

- (instancetype)initWithDic:(NSDictionary*)dic {
    self = [super init];
    if (self) {
        self.bookISBN = [dic objectForKey:@"bookISBN"];
        NSMutableDictionary *priceDic = [[NSMutableDictionary alloc] init];
        NSMutableArray *keys = [NSMutableArray arrayWithArray:[dic allKeys]];
        [keys removeObject:@"bookISBN"];
        for (id pro in keys) {
            //所有的书
            priceDic[pro] = dic[pro];
        }

    }
    return self;
}

@end
