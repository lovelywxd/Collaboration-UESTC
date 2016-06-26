//
//  assistantViewController.m
//  MyBookRecycle
//
//  Created by 苏丽荣 on 16/6/17.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "assistantViewController.h"
#import "AppDelegate.h"
#import "AFURLRequestSerialization.h"
#import "AppDelegate.h"
@interface assistantViewController ()
{
    AppDelegate* appdele;
}
@end

@implementation assistantViewController

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

- (IBAction)addFavorite:(id)sender {
}

- (IBAction)getFavorite:(id)sender {
}

- (IBAction)deleteFavorite:(id)sender {
}
- (IBAction)PromotionDetail:(id)sender {
}

- (IBAction)HomeSearch:(id)sender {
}

- (IBAction)SearchInPromotion:(id)sender {
}

- (IBAction)getPromotionList:(id)sender {
    appdele = [UIApplication sharedApplication].delegate;

    NSString* url = @"https://api.douban.com/v2/book/isbn/:9787508647357";
//    [appdele.manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"userCookie"] forHTTPHeaderField:@"Cookie"];    
    [appdele.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"seccess");
     }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"fail");
     }];
    

//    [appdele.manager
//     POST:url
//     parameters:logindata  // 指定请求参数
//     // 获取服务器响应成功时激发的代码块
//     success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         NSDictionary *fields= [operation.response allHeaderFields];
//
//         
//         
//     }
//     // 获取服务器响应失败时激发的代码块
//     failure:^(AFHTTPRequestOperation *operation, NSError *error)
//     {
//         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"无法获取服务器响应" preferredStyle:UIAlertControllerStyleAlert];
//         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
//         [alert addAction:defaultAction];
//         [self presentViewController:alert animated:YES completion:nil];
//     }];

}
@end
