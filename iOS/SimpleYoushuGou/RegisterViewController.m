//
//  RegisterViewController.m
//  newBook
//
//  Created by 苏丽荣 on 16/4/15.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "RegisterViewController.h"
#import "AppDelegate.h"
@interface RegisterViewController ()
{
     AppDelegate* appdele;
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)Register:(id)sender {
    appdele = [UIApplication sharedApplication].delegate;
    NSString* url;
    if (appdele.OnLineTest) {
//        url = @"http://192.168.1.100:8000/user/register/";
        url = @"http://115.159.219.141:8000/user/register/";
//        url = @"http://115.159.219.141:80/api/users";
//        url = @"http://52.69.162.241:8888/register/";
    }
    else
    {
        url = @"http://127.0.0.1:8000/api/users";
    }
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
        if (self.enableNameEmail)
        {
            usrname = self.name.text;
            email = self.email.text;
            phone = self.phone.text;
            
        }
        else
        {
            usrname = @"Slr4";
            email = @"15528290768@163.com";
        }
        passwd = @"1234567";
        school = @"UESTC";
        studentNo = @"201422010535";
        gender = @"1";

    }
    NSDictionary *register_data = [[NSDictionary alloc] initWithObjectsAndKeys:usrname, @"name",passwd,@"passwd",phone,@"phone",school,@"school",studentNo,@"studentNo",email,@"email",gender,@"gender",nil];
    // 使用AFHTTPRequestOperationManager发送POST请求
    [appdele.manager
     POST:url
     parameters:register_data  // 指定请求参数
     // 获取服务器响应成功时激发的代码块
     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSMutableString* login_result = [[NSMutableString alloc] init];
         // 当使用HTTP响应解析器时，服务器响应数据responseObject是一个NSDictionary
         NSArray* keys = [responseObject allKeys];
         // 此处将NSDictionary转换成NSString、并使用UIAlertView显示登录结果
         if ([keys containsObject:@"result"]) {
             [login_result appendString:@"Register success"];
         }
         else
         {
             [login_result appendString:@"Register fail."];
             NSData* data = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
             NSString *err_msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             [login_result appendString:err_msg];
         }
         
         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Register result" message:login_result preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
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
