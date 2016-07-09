//
//  OrderViewController.h
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/9.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderViewController : UIViewController
- (IBAction)Recycled:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *table;
- (IBAction)selectOrderType:(id)sender;

@end
