//
//  searchResultTableViewController.h
//  MyBookRecycle
//
//  Created by 苏丽荣 on 16/6/21.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface searchResultTableViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, copy)NSString *searchStr;
@end
