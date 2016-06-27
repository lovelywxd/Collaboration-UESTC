//
//  BookDetailInfo.m
//  MyBookRecycle
//
//  Created by 苏丽荣 on 16/6/26.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "BookDetailInfo.h"


@implementation BookDetailInfo
- (instancetype)initBook:(BookBaseInfo*)baseInfo withImages:(NSDictionary*)imgs title:(NSString*)bTitle publisher:(NSString*)bPublisher pubdate:(NSString*)bPubdate pages:(NSString*)bPage author:(NSArray*)bAuthor summary:(NSString*)bSummary author_intro:(NSString*)authorIntro rating:(NSDictionary*)bRating catalog:(NSString*)bCatalog tags:(NSArray*)bTag doubanLink:(NSString*)bDoubanLink
{
    self = [super init];
    if (self) {
        self.baseInfo = baseInfo;
        self.images = imgs;
        self.title = bTitle;
        self.publisher = bPublisher;
        self.pubdate = bPubdate;
        self.pages = bPage;
        self.author = bAuthor;
        self.summary = bSummary;
        self.author_intro = authorIntro;
        self.rating = bRating;
        self.catalog = bCatalog;
        self.tags = bTag;
        self.doubanLink = bDoubanLink;
    }
    return self;
}
@end
