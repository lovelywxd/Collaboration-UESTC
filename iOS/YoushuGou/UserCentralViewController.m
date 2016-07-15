//
//  UserCentralViewController.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/2.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "UserCentralViewController.h"
#import "FavouriteViewController.h"
#import "OrderViewController.h"
#import "GroupViewController.h"
#import "newLoginViewController.h"
#import "PhotoOperate.h"
#import "AppDelegate.h"
#import "SettingController.h"
#import "EGOImageView.h"



@interface UserCentralViewController ()<HTTPRequestFinishedDelegate>
{
    BOOL isLogin;
}
@end

@implementation UserCentralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"];
    if (userName) {
        self.UserNameLabel.text = userName;
        [self initHeader];
        isLogin = YES;
    }
    else {
        self.UserNameLabel.text = @"未登录";
        isLogin = NO;
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initHeader {
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"];
//    NSDictionary *oldHeaderDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"headerDic"];
//
//    if (oldHeaderDic) {
////        此前已经有用户头像路径
//        NSString* fileFullPath = oldHeaderDic[username];
//        if (fileFullPath) {
//            NSData* data = [NSData dataWithContentsOfFile:fileFullPath];
//            UIImage* image = [[UIImage alloc] initWithData:data];
//             self.header.image = image;
//        }
//        else {
//            [self downloadPhotoAction];
//        }
//    }
//    else {
//        [self downloadPhotoAction];
//    }@"%@/images/%@",appdele.baseUrl,imgName];
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    NSString *strUrl = [NSString stringWithFormat:@"%@/images/%@.jpg",appdele.baseUrl,username];
    self.egoHeader.imageURL = [NSURL URLWithString:strUrl];
    
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (isLogin) {
        switch (indexPath.section) {
            case 0:
            {
                
            }
                break;
            case 1:
            {
                switch (indexPath.row) {
                    case 0:
                    {
                        
                        GroupViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"GroupViewController"];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                    case 1:
                    {
                        FavouriteViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"FavouriteViewController"];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                    case 2:
                    {
                        OrderViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"OrderViewController"];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                        
                    default:
                        break;
                }
                
            }
                break;
            case 2:
            {
                SettingController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SettingController"];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
    }
    else {
        
        UINavigationController *navVC = [storyboard instantiateViewControllerWithIdentifier:@"navNewLoginViewController"];
        AppDelegate *appdele = [UIApplication sharedApplication].delegate;
        appdele.window.rootViewController = navVC;

//        newLoginViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"newLoginViewController"];
//        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 图片下载
- (void)downloadPhotoAction {
    NSLog(@"downloadPhotoAction");
    //在百度图片上随便找一个图片地址
    //    NSString* photoAddress = @"http://c.hiphotos.baidu.com/image/pic/item/14ce36d3d539b600c8525d44eb50352ac75cb7a1.jpg";
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"];
    NSString *imgName;
    if ([username isEqualToString:@"Slr"]) {
        imgName = @"Slr.jpg";
    }
    else if([username isEqualToString:@"Syr"]) {
        imgName = @"Syr.jpg";
    }
//    NSString* photoAddress = [NSString stringWithFormat:@"%@/images/Slr.jpg",appdele.baseUrl];
    NSString* photoAddress = [NSString stringWithFormat:@"%@/images/%@",appdele.baseUrl,imgName];
 
    NSString *pictureFileName = [NSString stringWithFormat:@"%@.jpg",username];
    NSString* fileFullPath = [[PhotoOperate sharedPhotoOperate] productFileFullPathWithSubDirectory:@"download" fileName:pictureFileName];
    [[PhotoOperate sharedPhotoOperate] downloadPhotoWithURL:photoAddress fileFullPath:fileFullPath target:self];
}

- (void)requestFinished:(NSDictionary *)dictionary tag:(NSInteger)tag{
    NSLog(@"requestFinished");
    NSString* fileFullPath = [dictionary objectForKey:@"photo"];
    
    
    NSData* data = [NSData dataWithContentsOfFile:fileFullPath];
    UIImage* image = [[UIImage alloc] initWithData:data];
    self.header.image = image;
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"];
    NSDictionary *oldHeaderDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"headerDic"];
    NSMutableDictionary *newDic;
    if (oldHeaderDic) {
        newDic = [NSMutableDictionary dictionaryWithDictionary:oldHeaderDic];
        newDic[username] = fileFullPath;
    }
    else {
        
        newDic = [NSMutableDictionary dictionaryWithObject:fileFullPath forKey:username];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[newDic copy] forKey:@"headerDic"];

}



//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
