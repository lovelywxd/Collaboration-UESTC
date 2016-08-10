//
//  welcomeViewController.m
//  MyBookRecycle
//
//  Created by 苏丽荣 on 16/6/17.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "welcomeViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "AppDelegate.h"
#import "PhotoOperate.h"

@interface welcomeViewController ()<HTTPRequestFinishedDelegate>

@end

@implementation welcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.navigationController  setToolbarHidden:NO animated:YES];
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

- (IBAction)goHomePage:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *homeVC = [storyboard instantiateViewControllerWithIdentifier:@"homeVC"];
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    appdele.window.rootViewController = homeVC;
}

//- (BOOL) downloadPhotoWithURL:(NSString *) url fileFullPath:(NSString *) fileFullPath target:(id<HTTPRequestFinishedDelegate>) target{
//    NSURL* nsurl = [NSURL URLWithString:url];
//    NSURLRequest* request = [NSURLRequest requestWithURL:nsurl];
//    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    //    [operation setInputStream:[NSInputStream inputStreamWithURL:nsurl]];
//    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:fileFullPath append:NO]];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary* dicionary = [NSDictionary dictionaryWithObject:fileFullPath forKey:@"photo"];
//        [target requestFinished:dicionary tag:1];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Failure");
//    }];
//    [operation start];
//    return YES;
//    
//}

- (void)downloadPhotoAction {
    NSLog(@"downloadPhotoAction");
    //在百度图片上随便找一个图片地址
//    NSString* photoAddress = @"http://c.hiphotos.baidu.com/image/pic/item/14ce36d3d539b600c8525d44eb50352ac75cb7a1.jpg";
     AppDelegate *appdele = [UIApplication sharedApplication].delegate;
     NSString* photoAddress = [NSString stringWithFormat:@"%@/images/Slr.jpg",appdele.baseUrl];
//        NSString* photoAddress = @"%@/images/Slr.jpg";
    NSString* fileFullPath = [[PhotoOperate sharedPhotoOperate] productFileFullPathWithSubDirectory:@"download" fileName:@"photo.jpg"];
    //    [[PhotoOperate sharedPhotoOperate] downloadPhotoWithDomain:@"http://c.hiphotos.baidu.com" URI:@"/image/pic/item/902397dda144ad34fbf27bd8d2a20cf431ad8524.jpg" fileFullPath:fileFullPath target:self];
    [[PhotoOperate sharedPhotoOperate] downloadPhotoWithURL:photoAddress fileFullPath:fileFullPath target:self];
    
}

- (void)requestFinished:(NSDictionary *)dictionary tag:(NSInteger)tag{
    NSLog(@"requestFinished");
    NSString* fileFullPath = [dictionary objectForKey:@"photo"];
    NSData* data = [NSData dataWithContentsOfFile:fileFullPath];
    UIImage* image = [[UIImage alloc] initWithData:data];
    
//    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
//    [imageView setFrame:CGRectMake(50, 50, 300, 400)];
//    [self.view addSubview:imageView];
    self.head.image = image;

}

- (void)getError:(NSError* __autoreleasing *)error {
    error = nil;
}
- (void)callGetError {
    NSError *error = nil;
    [self getError:&error];

}


- (IBAction)downImage:(id)sender {
//      UIImage *image = [UIImage imageNamed:@"头像.jpg"];
//    self.head.image = image;
    [self downloadPhotoAction];
   
}

- (IBAction)testReciveHtml:(id)sender {
    
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    NSString *url = [NSString stringWithFormat:@"http://www.firefoxchina.cn/?ntab"];
    [appdele.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"seccess in PromotionViewController,GetPromotrion");
         
        
     }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"服务器无响应" message:@"获取活动列表失败" preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
         [alert addAction:defaultAction];
         [self presentViewController:alert animated:YES completion:nil];
     }];

}

- (IBAction)testImage:(id)sender {
 
     AppDelegate *appdele = [UIApplication sharedApplication].delegate;
        [appdele.manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"userCookie"] forHTTPHeaderField:@"Cookie"];
    
    NSString *url = [NSString stringWithFormat:@"%@/user/image/upload/",appdele.baseUrl];
    [appdele.manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //01.21 测试
        UIImage *image = [UIImage imageNamed:@"头像.jpg"];
        NSData *data = UIImageJPEGRepresentation(image,0.7);
        //这里注意UIImageJPEGRepresentation 详情看下图格式
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
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
@end
