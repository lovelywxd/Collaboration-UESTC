//
//  groupBuyViewController.m
//  MyBookRecycle
//
//  Created by 苏丽荣 on 16/6/17.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "groupBuyViewController.h"
#import "AppDelegate.h"
#import "AFURLRequestSerialization.h"
#import "AppDelegate.h"
#import "EGOImageView.h"
@interface groupBuyViewController ()

@end

@implementation groupBuyViewController
NSArray *usrStrs;
EGOImageView *egoImgView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   egoImgView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"home"]];
    egoImgView.frame = CGRectMake(50,100, 100, 80);
     usrStrs  = [NSArray arrayWithObjects:@"https://img3.doubanio.com\/lpic\/s27110875.jpg",@"https://img3.doubanio.com\/lpic\/s27401075.jpg",@"https://img1.doubanio.com\/lpic\/s28691087.jpg", nil];
    //egoImgView.contentMode = UIViewContentModeScaleAspectFill;
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

- (IBAction)SearchBook:(id)sender {
    
    NSString* url = @"https://api.douban.com/v2/book/isbn/:9787302255659";
    //    [appdele.manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"userCookie"] forHTTPHeaderField:@"Cookie"];
    AppDelegate* appdele;
    appdele = [UIApplication sharedApplication].delegate;
    [appdele.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"seccess");
         // 当使用HTTP响应解析器时，服务器响应数据responseObject是一个NSDictionary
         NSArray* keys = [responseObject allKeys];
         for (id key in keys) {
             NSLog(@"key:%@,value:%@",key,[responseObject valueForKey:key]);
         }
         
     }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"fail");
     }];
    

}

- (IBAction)loadImg:(id)sender {
//    NSInteger index = [self.imgIndex.text integerValue];
//    egoImgView.imageURL = [NSURL URLWithString:[usrStrs objectAtIndex:index]];
//    [self.view addSubview:egoImgView];
}

- (IBAction)addFavorite:(id)sender {
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    NSString *url = @"http://115.159.219.141:8000/promotion/list/";
    [appdele.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"success in search in addFavorite");
         
     }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         NSLog(@"fail in search in addFavorite");
     }];

}
- (IBAction)removeFavorite:(id)sender {
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    NSString *url = @"http://115.159.219.141:8000/promotion/list/";
    [appdele.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"success in search in removeFavorite");
         
     }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         NSLog(@"fail in search in removeFavorite");
     }];

}

- (IBAction)getAllFavorite:(id)sender {
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    NSString *url = @"http://115.159.219.141:8000/promotion/list/";
    [appdele.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"success in search in getAllFavorite");
         
     }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         NSLog(@"fail in search in getAllFavorite");
     }];

}
@end
