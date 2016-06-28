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

- (id)copyWithZone:(NSZone *)zone
{
    BookDetailInfo *info = [[[self class] allocWithZone:zone] init];
    info.baseInfo = self.baseInfo;
    info.images = self.images;
    info.title = self.title;
    info.publisher = self.publisher;
    info.pubdate = self.pubdate;
    info.pages = self.pages;
    info.author = self.author;
    info.summary = self.summary;
    info.author_intro = self.author_intro;
    info.rating = self.rating;
    info.catalog = self.catalog;
    info.tags = self.tags;
    info.doubanLink = self.doubanLink;
    return info;
}
- (NSString*)description
{
    NSString *str = [NSString stringWithFormat:@"initBook:@\"%@\" withImages:\"%@\" title:\"%@\" publisher:\"%@\" pubdate:\"%@\" pages:\"%@\" author:\"%@\" summary:\"%@\" author_intro:\"%@\" rating:\"%@\" catalog:\"%@\" tags:\"%@\" doubanLink:\"%@]\"",self.baseInfo,self.images,self.title,self.publisher,self.pubdate,self.pages,self.author,self.summary,self.author_intro,self.rating,self.catalog,self.tags,self.doubanLink];
    return str;
}
@end
