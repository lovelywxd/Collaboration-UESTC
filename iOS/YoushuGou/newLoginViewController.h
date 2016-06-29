//
//  newLoginViewController.h
//  YouShuGou
//
//  Created by 苏丽荣 on 16/6/29.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface newLoginViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITextField *usrname;
@property (strong, nonatomic) IBOutlet UITextField *password;
- (IBAction)Login:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *enableInput;

@end
