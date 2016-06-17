//
//  LoginViewController.h
//  newBook
//
//  Created by 苏丽荣 on 16/4/15.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *headview;

- (IBAction)Login:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *enableInput;
@property (nonatomic,retain) UITextField *username;
@property (nonatomic,retain) UITextField *passwd;
//@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;

@end
