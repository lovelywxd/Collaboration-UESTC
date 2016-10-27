//
//  RegisterViewController.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/15.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "RegisterViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface RegisterViewController ()
{
    MBProgressHUD *hud;
    MBProgressHUD *removeHud;
    NSString* username;
    NSString* passwd;
    
}
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect frame = self.view.frame;
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:frame];
    bgImgView.image = [UIImage imageNamed:@"login_bg.jpg"];
//    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_bg.jpg"]];
    [self.view addSubview:bgImgView];
    [self.view sendSubviewToBack:bgImgView];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg.jpg"]];
//    login_bg.jpg

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

- (IBAction)register:(id)sender {
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    NSString *url = [NSString stringWithFormat:@"%@/user/register/",appdele.baseUrl];
    
    
    NSString* uname = self.name.text;
    NSString* pd = self.passwd.text;
    NSString* phone = self.phone.text;
    NSString* school = self.school.text;
    NSString* studentNo = self.studentNo.text;
    NSString* email = self.email.text;
    NSString* gender = self.gender.text;
    
    
    
    if ([self.name.text isEqualToString:@""] )
        uname = @"Slr5";
    if ([self.passwd.text isEqualToString:@""] )
        pd = @"1234567";
    if ([self.passwd.text isEqualToString:@""] )
        phone = @"15528290765";
    if ([self.passwd.text isEqualToString:@""] )
        school = @"UESTC";
    if ([self.passwd.text isEqualToString:@""] )
        studentNo = @"1234567";
    if ([self.passwd.text isEqualToString:@""] )
        email = [NSString stringWithFormat:@"%@@163.com",phone];
    if ([self.passwd.text isEqualToString:@""] )
        gender = @"1";
    
    NSDictionary *register_data = [[NSDictionary alloc] initWithObjectsAndKeys:uname, @"name",pd,@"passwd",phone,@"phone",school,@"school",studentNo,@"studentNo",email,@"email",gender,@"gender",nil];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.contentColor = [UIColor colorWithRed:0.f green:0.6f blue:0.7f alpha:1.f];
    
    [appdele.manager
     POST:url
     parameters:register_data  // 指定请求参数
     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [hud hideAnimated:NO];
         NSDictionary *fields= [operation.response allHeaderFields];
         NSArray *cookies=[NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:[NSURL URLWithString:url]];
         [[NSUserDefaults standardUserDefaults] setObject:[[NSHTTPCookie requestHeaderFieldsWithCookies:cookies] objectForKey:@"Cookie"] forKey:@"userCookie"];
         [[NSUserDefaults standardUserDefaults] synchronize];
         
         NSString *loginStatus = [responseObject objectForKey:@"status"];
         if ([loginStatus isEqualToString:@"0"]) {
             UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"register result" message:@"register success" preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"注册成功" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//                 [self loginImmediately];
                 [self dismissViewControllerAnimated:YES completion:nil];
                 
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
         [hud hideAnimated:NO];
         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"注册结果" message:@"无法获取服务器响应" preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
         [alert addAction:defaultAction];
         [self presentViewController:alert animated:YES completion:nil];
     }];

}

- (void)loginImmediately {
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    NSString *url = [NSString stringWithFormat:@"%@/user/login/",appdele.baseUrl];
    NSString *uname = self.name.text;
    NSString *pd = self.passwd.text;
    NSDictionary *logindata = [[NSDictionary alloc] initWithObjectsAndKeys:uname, @"name",pd,@"passwd",nil];
    [appdele.manager
     POST:url
     parameters:logindata  // 指定请求参数
     // 获取服务器响应成功时激发的代码块
     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *fields= [operation.response allHeaderFields];
         NSArray *cookies=[NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:[NSURL URLWithString:url]];

         [[NSUserDefaults standardUserDefaults] setObject:[[NSHTTPCookie requestHeaderFieldsWithCookies:cookies] objectForKey:@"Cookie"] forKey:@"userCookie"];
         
         NSString *logingUser = self.name.text;
         
         NSString *loginStatus = [responseObject objectForKey:@"status"];
         if ([loginStatus isEqualToString:@"0"]) {
             
             //设别上存储的所有用户
             NSArray *oldUserList = [[NSUserDefaults standardUserDefaults] objectForKey:@"userList"];
             NSMutableArray *newUserList;
             if (oldUserList) {
                 newUserList = [NSMutableArray arrayWithArray:oldUserList];
                 if (![oldUserList containsObject:logingUser]) {
                     //若此前未存储过该用户信息，存储用户名以及密码
                     [newUserList addObject:logingUser];
                 }
             }
             else {
                 //             设备上没有用户
                 newUserList = [NSMutableArray arrayWithObject:logingUser];
             }
             [[NSUserDefaults standardUserDefaults] setObject:[newUserList copy] forKey:@"userList"];
             [[NSUserDefaults standardUserDefaults] setObject:logingUser forKey:@"currentOnLineUser"];
             [[NSUserDefaults standardUserDefaults] setObject:logingUser forKey:@"currentUser"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
             
             
             UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
             UIViewController *homeVC = [storyboard instantiateViewControllerWithIdentifier:@"homeVC"];
             appdele.window.rootViewController = homeVC;
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
         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"服务器无响应" message:@"登录失败" preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
         [alert addAction:defaultAction];
         [self presentViewController:alert animated:YES completion:nil];
     }];
    
//    dispatch_once_t


}
- (IBAction)goLogin:(id)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}
@end
