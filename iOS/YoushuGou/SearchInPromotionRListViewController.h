//
//  SearchInPromotionRListViewController.h
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/1.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchInPromotionRListViewController : UITableViewController

@property (nonatomic ,copy) NSString *bookName;
- (IBAction)Back:(id)sender;
@property (nonatomic ,copy) NSString *promotionID;
@end
