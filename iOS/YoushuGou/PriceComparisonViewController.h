//
//  PriceComparisonViewController.h
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/1.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PriceComparisonViewController : UITableViewController
@property (nonatomic ,copy) NSString *bookIsbn;
@property (nonatomic ,copy) NSString *bookImageLink;
@property (nonatomic ,copy) NSString *bookName;
@property (nonatomic ,strong) NSArray *PriceList;
@property (nonatomic ,copy) NSString *bookLowestPrice;
@end
