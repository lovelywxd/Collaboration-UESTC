//
//  settingViewController.m
//  MyBookRecycle
//
//  Created by 苏丽荣 on 16/6/12.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "settingViewController.h"
#import "AppDelegate.h"

@interface settingViewController ()
{
    AppDelegate* appdele;
}
@end

@implementation settingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appdele.OnLineTest = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)submitModdify:(id)sender {
    appdele = [UIApplication sharedApplication].delegate;
    appdele.OnLineTest = self.onLine.on;
}
@end
