//
//  FavouriteItem.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/2.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "FavouriteItem.h"

@implementation FavouriteItem
- (instancetype)initBook:(NSString*)isbn name:(NSString*)bName imageLink:(NSString*)bLink {
    self = [super init];
    self.bookISBN = isbn;
    self.bookName = bName;
    self.bookImageLink = bLink;
    return  self;
}
@end
