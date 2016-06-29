//
//  newLoginViewController.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/6/29.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "newLoginViewController.h"
#import "AppDelegate.h"

@interface newLoginViewController ()

@end

@implementation newLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (IBAction)Login:(id)sender {
    NSLog(@"usrname:%@",self.usrname.text);
    NSLog(@"password:%@",self.password.text);
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
      NSString* url;
    if (appdele.OnLineTest) {
        url = @"http://115.159.219.141:8000/user/login/";
        //        url = @"http://192.168.1.100:8000/user/login/";
    }
    else
    {
        url = @"http://127.0.0.1:8000/api/authenticate";
    }
    NSString* username;
    NSString* passwd;
    if (self.enableInput.on) {
        username = self.usrname.text;
        passwd = self.password.text;
    }
    else
    {
        username = @"wxd";
        passwd = @"123456dd";
    }
    NSDictionary *logindata = [[NSDictionary alloc] initWithObjectsAndKeys:username, @"name",passwd,@"passwd",nil];
    [appdele.manager
     POST:url
     parameters:logindata  // 指定请求参数
     // 获取服务器响应成功时激发的代码块
     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *fields= [operation.response allHeaderFields];
         NSArray *cookies=[NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:[NSURL URLWithString:url]];
         [[NSUserDefaults standardUserDefaults] setObject:[[NSHTTPCookie requestHeaderFieldsWithCookies:cookies] objectForKey:@"Cookie"] forKey:@"userCookie"];
         [[NSUserDefaults standardUserDefaults] synchronize];
         
         NSMutableString* login_result = [[NSMutableString alloc] init];
        [login_result appendString:@"Login success"];
         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Login result" message:login_result preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
             
             UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
             UIViewController *homeVC = [storyboard instantiateViewControllerWithIdentifier:@"homeVC"];
             [self.navigationController pushViewController:homeVC animated:YES];
         }];
         [alert addAction:defaultAction];
         [self presentViewController:alert animated:YES completion:nil];
         
              }
     // 获取服务器响应失败时激发的代码块
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"无法获取服务器响应" preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
         [alert addAction:defaultAction];
         [self presentViewController:alert animated:YES completion:nil];
     }];
}
@end
