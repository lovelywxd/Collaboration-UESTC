//
//  SearchInPromotionIndicageViewController.h
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/1.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookBaseInfo.h"

@protocol NavBookDetail <NSObject>

- (void)NavigateToBook:(BookBaseInfo*)baseInfo;
@end

@interface SearchInPromotionIndicageViewController : UITableViewController
@property (nonatomic, strong) NSArray* searchResults;
@property (nonatomic, copy) NSString* searchStr;
@property (nonatomic, copy) NSString* promotionID;
@property (nonatomic, weak) id<NavBookDetail> NavBookDelegate;
@end
