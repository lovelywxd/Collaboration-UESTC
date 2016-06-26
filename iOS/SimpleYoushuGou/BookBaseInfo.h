//
//  BookBaseInfo.h
//  MyBookRecycle
//
//  Created by 苏丽荣 on 16/6/26.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookBaseInfo : NSObject
@property (nonatomic,copy) NSString* bookID;
@property (nonatomic,copy) NSString* bookName;
@property (nonatomic,copy) NSString* author;
@property (nonatomic,copy) NSString* imageLink;
@property (nonatomic,copy) NSString* doubanScore;
@property (nonatomic,copy) NSString* doubanLink;
@property (nonatomic,copy) NSString* discription;
@end
