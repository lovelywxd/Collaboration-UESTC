//
//  LoginViewController.h
//  newBook
//
//  Created by 苏丽荣 on 16/4/15.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *headview;
@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *password;
- (IBAction)Login:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *enableInput;

- (IBAction)LoginBySina:(id)sender;


@end
