//
//  SettingController.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/10.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "SettingController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "QQViewController.h"

@interface SettingController ()
{
    
}

@end

@implementation SettingController

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

- (IBAction)logOut:(id)sender {
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    NSString *url = [NSString stringWithFormat:@"%@/user/logout/",appdele.baseUrl];
    [appdele.manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *status = [responseObject objectForKey:@"status"];
         if ([status isEqualToString:@"0"]) {

            //只是退出登录的话，不从本地用户列表中删除该用户；只是改变当前活跃账号和当前在线账号
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"currentUser"];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"currentOnLineUser"];
             

//             UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//             UINavigationController *vc = [storyboard instantiateViewControllerWithIdentifier:@"navNewLoginViewController"];
             AppDelegate *appdele = [UIApplication sharedApplication].delegate;
             
             QQViewController *loginVc = [[QQViewController alloc] initWithNibName:@"QQViewController" bundle:nil];

             
             appdele.window.rootViewController = loginVc;
             
         }
         else {
             NSString *msg = [responseObject objectForKey:@"data"];
             UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"退出失败" message:msg preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
             [alert addAction:defaultAction];
             [self presentViewController:alert animated:YES completion:nil];

            
         }
     }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"服务器无响应" message:@"注销失败" preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
         [alert addAction:defaultAction];
         [self presentViewController:alert animated:YES completion:nil];
     }];

    
    
    
    
    
    
}
@end
