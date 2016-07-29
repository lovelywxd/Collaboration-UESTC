//
//  RegisterViewController.h
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/15.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *passwd;
@property (strong, nonatomic) IBOutlet UITextField *phone;
@property (strong, nonatomic) IBOutlet UITextField *school;
@property (strong, nonatomic) IBOutlet UITextField *studentNo;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *gender;
- (IBAction)register:(id)sender;
- (IBAction)goLogin:(id)sender;


@end
