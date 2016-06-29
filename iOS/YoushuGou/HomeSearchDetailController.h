//
//  HomeSearchDetailController.h
//  YouShuGou
//
//  Created by 苏丽荣 on 16/6/30.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeSearchListItem.h"

@interface HomeSearchDetailController : UITableViewController
//@property (nonatomic ,) NSString* targetBooSubject;
@property (nonatomic ,copy) HomeSearchListItem* targetItem;

@end
