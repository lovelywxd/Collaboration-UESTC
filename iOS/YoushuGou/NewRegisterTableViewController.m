//
//  NewRegisterTableViewController.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/6/29.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "NewRegisterTableViewController.h"
#import "AppDelegate.h"

@interface NewRegisterTableViewController ()

@end

@implementation NewRegisterTableViewController

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
    return 9;
}

- (IBAction)Register:(id)sender {
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    NSString *url = [NSString stringWithFormat:@"%@/user/register/",appdele.baseUrl];
    
    
    NSString* usrname;
    NSString* passwd;
    NSString* phone;
    NSString* school;
    NSString* studentNo;
    NSString* email;
    NSString* gender;
    
    if (self.enableAllInput.on) {
        usrname = self.name.text;
        passwd = self.passwd.text;
        phone = self.phone.text;
        school = self.school.text;
        studentNo = self.studentNo.text;
        email = self.email.text;
        gender = self.gender.text;
    }
    else
    {
        if (self.enableNameEmail.on)
        {
            usrname = self.name.text;
            email = self.email.text;
            phone = self.phone.text;
            
        }
        else
        {
            usrname = @"Slr";
            email = @"15528290768@163.com";
            phone =@"15528290768";
        }
        passwd = @"1234567";
        school = @"UESTC";
        studentNo = @"201422010535";
        gender = @"1";
        
    }

    NSDictionary *register_data = [[NSDictionary alloc] initWithObjectsAndKeys:usrname, @"name",passwd,@"passwd",phone,@"phone",school,@"school",studentNo,@"studentNo",email,@"email",gender,@"gender",nil];

    [appdele.manager
     POST:url
     parameters:register_data  // 指定请求参数
     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *fields= [operation.response allHeaderFields];
         NSArray *cookies=[NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:[NSURL URLWithString:url]];
         [[NSUserDefaults standardUserDefaults] setObject:[[NSHTTPCookie requestHeaderFieldsWithCookies:cookies] objectForKey:@"Cookie"] forKey:@"userCookie"];
         [[NSUserDefaults standardUserDefaults] synchronize];
         
         NSString *loginStatus = [responseObject objectForKey:@"status"];
         if ([loginStatus isEqualToString:@"0"]) {
             UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"register result" message:@"register success" preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                 UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                 UIViewController *registerVC = [storyboard instantiateViewControllerWithIdentifier:@"newLoginViewController"];
                 [self.navigationController pushViewController:registerVC animated:YES];
             }];
             [alert addAction:defaultAction];
             [self presentViewController:alert animated:YES completion:nil];
         }
         else {
             NSString *result = [NSString stringWithFormat:@"login fail.info:%@",[responseObject objectForKey:@"data"]];
             UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Login result" message:result preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
             }];
             [alert addAction:defaultAction];
             [self presentViewController:alert animated:YES completion:nil];
         }
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
