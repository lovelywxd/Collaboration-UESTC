//
//  HomeSearchDetailController.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/6/30.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "HomeSearchDetailController.h"
#import "EGOImageView.h"
#import "WebViewController.h"
#import "AppDelegate.h"

@interface HomeSearchDetailController ()
@property (nonatomic ,strong) NSMutableArray *PriceList;
@end

@implementation HomeSearchDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareProperty];
    NSArray *detailData = [self fetHomeSearchDetailLoacally];
    [self formPriceList:detailData];
    self.priceTable.delegate = self;
    self.priceTable.dataSource = self;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareProperty {
    self.PriceList = [[NSMutableArray alloc] init];
}
#pragma mark - 从本地获取数据并处理
- (NSArray*)fetHomeSearchDetailLoacally {
    NSString* jsonPath = [[NSBundle mainBundle] pathForResource:@"homeSearchDetail" ofType:@"json"];
    // 读取jsonPath对应文件的数据
    NSData* data = [NSData dataWithContentsOfFile:jsonPath];
    // 调用JSONKit为NSData扩展的objectFromJSONData方法解析JSON数据
    
    NSArray *parseResult = [NSJSONSerialization JSONObjectWithData:data
                                                           options:0 error:nil];
    return parseResult;
}

- (void)formPriceList:(NSArray*)arr {
    for (id item in arr) {
        NSString *tempName = [item objectForKey:@"bookSaler"];
        NSRange range = [tempName rangeOfString:@"."];//获取$file/的位置
        NSString *saler = [tempName substringToIndex:range.location];//开始截取
        
        [self.PriceList addObject:[NSDictionary dictionaryWithObjectsAndKeys:saler,@"bookSaler",[item objectForKey:@"bookCurrentPrice"],@"bookCurrentPrice", nil]];
    }
}

#pragma mark - 从服务器获取数据
- (void)loadHomeSearchDetail {
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    NSString *url = [NSString stringWithFormat:@"%@/search/home/list/",appdele.baseUrl];
    
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.targetItem.booSubject, @"booSubject",nil];
    [appdele.manager
     POST:url
     parameters:param  // 指定请求参数
     // 获取服务器响应成功时激发的代码块
     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self formPriceList:responseObject];
         [self.tableView reloadData];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"fail search in homepage");
     }];

}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 123;
            break;
            
        default:
            return 49;
            break;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        default:
            return self.PriceList.count;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case 0:
        {
            static NSString *CellId = @"BaseCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellId forIndexPath:indexPath];
            EGOImageView *imgView = (EGOImageView*)[cell viewWithTag:1];
            NSString *bookImgUrl = self.targetItem.bookImageLink;
            imgView.imageURL = [NSURL URLWithString:bookImgUrl];
            UILabel *label;
            label = (UILabel*)[cell viewWithTag:2];
            label.text = self.targetItem.bookName;
            label = (UILabel*)[cell viewWithTag:3];
            label.text = self.targetItem.bookDetail;
            UIButton *btn = (UIButton*)[cell viewWithTag:4];
            [btn addTarget:self action:@selector(GoDouBan:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
            
        default:
        {
            static NSString *CellId = @"PriceCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellId forIndexPath:indexPath];
            UIImageView *imgView = (UIImageView*)[cell viewWithTag:1];
            NSString *name = [[self.PriceList objectAtIndex:indexPath.row] objectForKey:@"bookSaler"];
            imgView.image = [UIImage imageNamed:name];
            UILabel *label = (UILabel*)[cell viewWithTag:2];
            label.text = [[self.PriceList objectAtIndex:indexPath.row] objectForKey:@"bookCurrentPrice"];

        }
            break;
    }
    return cell;
}

#pragma mark - 响应事件
- (void)GoDouBan:(id)sender {
    NSString *url = self.targetItem.booSubject;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WebViewController* webVC = [storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    webVC.urlStr = url;
    webVC.title = self.targetItem.bookName;
    [self.navigationController pushViewController:webVC animated:NO];
    NSLog(@"clicked GoDouBan Btn");
}


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
