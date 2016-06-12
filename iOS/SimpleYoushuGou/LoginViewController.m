//
//  LoginViewController.m
//  newBook
//
//  Created by 苏丽荣 on 16/4/15.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "AFURLRequestSerialization.h"

@interface LoginViewController ()
{
    AppDelegate* appdele;
}
@end



@implementation LoginViewController

NSMutableData* totalData;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"loginbackground.png"]]];
    self.headview.image = [UIImage imageNamed:@"head_background.png"];
    appdele = [UIApplication sharedApplication].delegate;
}
  
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)Login:(id)sender {
    appdele = [UIApplication sharedApplication].delegate;
//    appdele.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
//    appdele.manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    NSLog(@"%@", appdele.manager.responseSerializer.acceptableContentTypes);
    NSString* url;
    
    if (appdele.OnLineTest) {
        url = @"http://115.159.219.141:80/api/authenticate";
    }
    else
    {
        url = @"http://127.0.0.1:8000/api/authenticate";
    }
    NSString* username;
    NSString* passwd;
    if (self.enableInput.on) {
        username = self.userName.text;
        passwd = self.password.text;
    }
    else
    {
        username = @"Slr";
        passwd = @"1234567";
    }
    NSDictionary *logindata = [[NSDictionary alloc] initWithObjectsAndKeys:username, @"name",passwd,@"passwd",nil];
    
        [appdele.manager
     POST:url
     parameters:logindata  // 指定请求参数
     // 获取服务器响应成功时激发的代码块
     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSMutableString* login_result = [[NSMutableString alloc] init];
         // 当使用HTTP响应解析器时，服务器响应数据responseObject是一个NSDictionary
         NSArray* keys = [responseObject allKeys];
         // 此处将NSDictionary转换成NSString、并使用UIAlertView显示登录结果
         if ([keys containsObject:@"result"]) {
             [login_result appendString:@"Login success"];
         }
         else
         {
             [login_result appendString:@"Login fail."];
             NSData* data = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
             NSString *err_msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             [login_result appendString:err_msg];
         }
         
         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Login result" message:login_result preferredStyle:UIAlertControllerStyleAlert];
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

- (IBAction)LoginBySina:(id)sender {
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
