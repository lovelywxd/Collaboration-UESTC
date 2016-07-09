//
//  NewCartViewController.h
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/7.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewCartViewController : UIViewController
- (IBAction)selectAll:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *submitBtn;
- (IBAction)submit:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *totalPrice;
@property (strong, nonatomic) IBOutlet UILabel *totalPriceIndicate;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editBtn;

@property (assign, nonatomic) BOOL isEditState;
@property (assign, nonatomic) BOOL isSelectedAll;
- (IBAction)changeCartState:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *selectAllBtn;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
- (IBAction)delete:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *table;

@end
