//
//  newLoginViewController.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/6/29.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "newLoginViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface newLoginViewController ()
{
    MBProgressHUD *hud;
    MBProgressHUD *removeHud;
    NSString* username;
    NSString* passwd;

}
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
    return 5;
}

- (IBAction)Login:(id)sender {
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    NSString *url = [NSString stringWithFormat:@"%@/user/login/",appdele.baseUrl];

    if (self.enableInput.on) {
        username = self.usrname.text;
        passwd = self.password.text;
    }
    else
    {
        username = @"Slr";
       // username = @"Syr";
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
         [[NSUserDefaults standardUserDefaults] setObject:[[NSHTTPCookie requestHeaderFieldsWithCookies:cookies] objectForKey:@"Cookie"] forKey:@"userCookie"];
         
//         NSMutableSet *userSet = [[NSUserDefaults standardUserDefaults] objectForKey:@"userSet"];
//         if (userSet) {
//             [userSet addObject:username];
//             [newUserList setValue:userSet forKey:username];
//             [[NSUserDefaults standardUserDefaults] setObject:[newUserList copy] forKey:@"userList"];
//         }
//         else {
//             //这个本设备上的第一个用户
//             userList = [NSDictionary dictionaryWithObject:passwd forKey:username];
//             [[NSUserDefaults standardUserDefaults] setObject:userList forKey:@"userList"];
//         }

         
          NSDictionary *oldUserList = [[NSUserDefaults standardUserDefaults] objectForKey:@"userList"];
         
       
         NSMutableDictionary *newUserList;
         if (oldUserList) {
             newUserList = [NSMutableDictionary dictionaryWithDictionary:oldUserList];
             if (newUserList[username]) {
                 //此前已经有了该用户的信息
                 
             }
             else {
                 newUserList[username] = passwd;
             }
            
         }
         else {
             //这个本设备上的第一个用户
             newUserList = [NSMutableDictionary dictionaryWithObject:passwd forKey:username];
         }
          [[NSUserDefaults standardUserDefaults] setObject:[newUserList copy] forKey:@"userList"];
         //纪录当前在线用户；
          [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"currentUser"];
         [[NSUserDefaults standardUserDefaults] synchronize];
         
         NSString *loginStatus = [responseObject objectForKey:@"status"];
         if ([loginStatus isEqualToString:@"0"]) {
             UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Login result" message:@"Login success" preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                 
                 NSString *imgName;
                 NSString *subfix;
                 NSString *type;
                 if ([username isEqualToString:@"Slr"]) {
                     imgName = @"Slr.png";
                     subfix = @".png";
                     type = @"image/png";
                 }
                 else if([username isEqualToString:@"Syr"]) {
                     imgName = @"Syr.jpg";
                     subfix = @".jpg";
                     type = @"image/jpg";
                 }
                 [self upLoadhead:imgName subfix:subfix type:type];
                 UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                 UIViewController *homeVC = [storyboard instantiateViewControllerWithIdentifier:@"homeVC"];
                 appdele.window.rootViewController = homeVC;
                 
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
         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"服务器无响应" message:@"登录失败" preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
         [alert addAction:defaultAction];
         [self presentViewController:alert animated:YES completion:nil];
     }];
}

- (void)upLoadhead:(NSString*)iamgeName subfix:(NSString*)subfixStr type:(NSString*)type {
    
    
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    [appdele.manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"userCookie"] forHTTPHeaderField:@"Cookie"];
    
    NSString *url = [NSString stringWithFormat:@"%@/user/image/upload/",appdele.baseUrl];
    
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"];
    if (userName) {

        if ([userName isEqualToString:@"Slr"]) {
//            //        imgName = @"Slr.png";
//            //        subfix = @".png";
//            //        type = @"image/png";
//            [appdele.manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//                //01.21 测试
//                UIImage *image = [UIImage imageNamed:@"boy.png"];
//                NSData *data = UIImagePNGRepresentation(image);
//                
//                //这里注意UIImageJPEGRepresentation 详情看下图格式
//                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//                formatter.dateFormat = @"yyyyMMddHHmmss";
//                NSString *str = [formatter stringFromDate:[NSDate date]];
//                NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
//                
//                //name 为服务器规定的图片字段 mimeType 为图片类型
//                [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/png"];
//                
//            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                //成功后处理
//                NSLog(@"Success: %@", responseObject);
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                NSLog(@"Error: %@", error);
//            }];
            [appdele.manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                //01.21 测试
                UIImage *image = [UIImage imageNamed:@"heart"];
                NSData *data = UIImageJPEGRepresentation(image,0.7);
                //这里注意UIImageJPEGRepresentation 详情看下图格式
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                //                NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
                NSString *fileName = @"Syr.jpg";
                
                //name 为服务器规定的图片字段 mimeType 为图片类型
                [formData appendPartWithFileData:data name:@"image" fileName:fileName mimeType:@"image/jpg"];
                //         image/jpeg
                //        image/png
                
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //成功后处理
                NSLog(@"Success: %@", responseObject);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
            
        }

        else if([userName isEqualToString:@"Syr"]) {
            //        imgName = @"Syr.jpg";
            //        subfix = @".jpg";
            //        type = @"image/jpg";
            
            [appdele.manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                //01.21 测试
                UIImage *image = [UIImage imageNamed:@"girl"];
                NSData *data = UIImageJPEGRepresentation(image,0.7);
                //这里注意UIImageJPEGRepresentation 详情看下图格式
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
//                NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
                NSString *fileName = @"Syr.jpg";
                
                //name 为服务器规定的图片字段 mimeType 为图片类型
                [formData appendPartWithFileData:data name:@"image" fileName:fileName mimeType:@"image/jpg"];
                //         image/jpeg
                //        image/png
                
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //成功后处理
                NSLog(@"Success: %@", responseObject);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
            
        }

    }
    
}
@end
