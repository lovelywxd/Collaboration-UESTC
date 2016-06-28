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
NSDictionary* requestFields;
NSMutableData* totalData;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//   [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"loginbackground.png"]]];
    self.headview.image = [UIImage imageNamed:@"head_background.png"];
    appdele = [UIApplication sharedApplication].delegate;
    
//    self.table.dataSource = self;
//    self.table.delegate = self;
//    self.table.backgroundColor = [UIColor clearColor];
    CGRect frame = self.view.frame;
    UITableView *tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(30, 80, frame.size.width-60,80)style:UITableViewStylePlain];
    tableView1.dataSource = self;
    tableView1.delegate = self;
    tableView1.scrollEnabled = NO;
    [tableView1 setBackgroundColor:[UIColor blueColor]];
    [tableView1 setBackgroundView:nil];
    tableView1.layer.cornerRadius=12;
    tableView1.clipsToBounds=YES;
    tableView1.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView1.separatorColor = [UIColor redColor];
    [self.view addSubview:tableView1];
    
//    //单击空白处隐藏键
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.username resignFirstResponder];
    [self.passwd resignFirstResponder];
}

- (UITableViewCell *)tableView:(UITableView *)tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.username = [[UITextField alloc]initWithFrame:CGRectMake(120, 5, 140, 30)];
    [self.username setBorderStyle:UITextBorderStyleNone];
    [self.username setPlaceholder:@"请输入用户名"];
    [self.username setTextColor:[UIColor brownColor]];
    [self.username setFont:[UIFont fontWithName:@"Arial" size:14]];
    [self.username setBackgroundColor:[UIColor redColor]];
    [self.username setReturnKeyType:UIReturnKeyDone];
    [self.username addTarget:self action:@selector(textchanged:) forControlEvents:UIControlEventEditingChanged];
 
//    self.username.keyboardType =  UIKeyboardTypeURL;
    
    self.passwd = [[UITextField alloc]initWithFrame:CGRectMake(120, 5, 140, 30)];
    [self.passwd setBorderStyle:UITextBorderStyleNone];
    [self.passwd setPlaceholder:@"请输入密码"];
    [self.passwd setTextColor:[UIColor brownColor]];
    [self.passwd setFont:[UIFont fontWithName:@"Arial" size:14]];
    [self.passwd setSecureTextEntry:YES];
    [self.passwd setReturnKeyType:UIReturnKeyDone];
    //cell.selectionStyle = UITableViewStyleGrouped;
    self.passwd.keyboardType = UIKeyboardTypeNumberPad;
    
    //    [self.username addTarget:self action:@selector(finishInput:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    static NSString *identifier = @"_QiShiCELL";
    UITableViewCell *cell =(UITableViewCell *) [tableview dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            
            [cell.textLabel setTextColor:[UIColor blackColor]];
            [cell.textLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
            [cell.textLabel setText: @"用户名:"];
            
            [cell addSubview:self.username];
        }else if(indexPath.row == 1)
        {
            
            [cell.textLabel setTextColor:[UIColor blackColor]];
            [cell.textLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
            [cell.textLabel setText:  @"密   码:"];
            [cell addSubview:self.passwd];
        }
        
    }
    return cell;
}

//- (void)finishInput:(id)sender
//{
////    [self.username resignFirstResponder];
//    [self.passwd becomeFirstResponder];
//    NSLog(@"%@",((UITextField*)sender).text);
//}

- (void)textchanged:(id)sender
{
    NSLog(@"%@",((UITextField*)sender).text);
}

- (CGFloat)tableView:(UITableView *)tableview heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableview numberOfRowsInSection:(NSInteger)section{
    return 2;
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
        url = @"http://115.159.219.141:8000/user/login/";
//        url = @"http://192.168.1.100:8000/user/login/";
//        url = @"http://115.159.219.141:80/api/authenticate";
//        url = @"http://52.69.162.241:8888/login";
    }
    else
    {
        url = @"http://127.0.0.1:8000/api/authenticate";
    }
    NSString* username;
    NSString* passwd;
    if (self.enableInput.on) {
        username = self.username.text;
        passwd = self.passwd.text;
    }
    else
    {
        username = @"Syr";
        passwd = @"1234567";
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
         requestFields=[NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
         [[NSUserDefaults standardUserDefaults] setObject:[requestFields objectForKey:@"Cookie"] forKey:@"userCookie"];
         [[NSUserDefaults standardUserDefaults] synchronize];

         NSMutableString* login_result = [[NSMutableString alloc] init];
         // 当使用HTTP响应解析器时，服务器响应数据responseObject是一个NSDictionary
         NSArray* keys = [responseObject allKeys];
         // 此处将NSDictionary转换成NSString、并使用UIAlertView显示登录结果
         if ([keys containsObject:@"result"]) {
             [login_result appendString:@"Login success"];
             UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Login result" message:login_result preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//                 // 获取指定的Storyboard，name填写Storyboard的文件名
                 UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                 // 从Storyboard上按照identifier获取指定的界面（VC），identifier必须是唯一的
                 
//                 homeViewController* homeVC = [storyboard instantiateViewControllerWithIdentifier:@"homeVC"];
////
//                 [self.navigationController pushViewController:homeVC animated:YES];
                [appdele.manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"userCookie"] forHTTPHeaderField:@"Cookie"];

                  NSString* tempUrl = @"http://115.159.219.141:80/api/users";
                 [appdele.manager GET:tempUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
                  {
                      NSLog(@"seccess");
                  }
                failure:^(AFHTTPRequestOperation *operation, NSError *error)
                  {
                      NSLog(@"fail");
                  }];
             }];
             [alert addAction:defaultAction];
             [self presentViewController:alert animated:YES completion:nil];
         }
         else
         {
             [login_result appendString:@"Login fail."];
             NSData* data = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
             NSString *err_msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             [login_result appendString:err_msg];
             UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Login result" message:login_result preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
