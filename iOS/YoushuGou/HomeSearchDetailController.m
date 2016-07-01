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
    [self searInHomeDetail];
    self.title = self.targetItem.bookName;
}

- (void) searInHomeDetail {
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    if (appdele.OnLineTest) {
        [self loadHomeSearchDetail];
    }
    else {
        NSArray *detailData = [self loadHomeSearchDetailLocally];
        [self formPriceList:detailData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareProperty {
    self.PriceList = [[NSMutableArray alloc] init];
}
#pragma mark - 从本地获取数据并处理
- (NSArray*)loadHomeSearchDetailLocally {
    NSString* jsonPath = [[NSBundle mainBundle] pathForResource:@"homeSearchDetail" ofType:@"json"];
    // 读取jsonPath对应文件的数据
    NSData* data = [NSData dataWithContentsOfFile:jsonPath];
    // 调用JSONKit为NSData扩展的objectFromJSONData方法解析JSON数据
    
    NSArray *parseResult = [NSJSONSerialization JSONObjectWithData:data
                                                           options:0 error:nil];
    return parseResult;
}

#pragma mark - 网络请求，从服务器获取数据
- (void)loadHomeSearchDetail {
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    NSString *url = [NSString stringWithFormat:@"%@/search/home/detail/",appdele.baseUrl];
    
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.targetItem.booSubject, @"booSubject",nil];
    [appdele.manager
     GET:url
     parameters:param  // 指定请求参数
     // 获取服务器响应成功时激发的代码块
     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self formPriceList:responseObject];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"fail search detail in homepage");
     }];

}

#pragma mark -－公用解析函数
- (void)formPriceList:(NSArray*)arr {
    for (id item in arr) {
        NSString *tempName = [item objectForKey:@"bookSaler"];
        NSRange range = [tempName rangeOfString:@"."];//获取$file/的位置
        NSString *saler = [tempName substringToIndex:range.location];//开始截取
        
        [self.PriceList addObject:[NSDictionary dictionaryWithObjectsAndKeys:saler,@"bookSaler",[item objectForKey:@"bookCurrentPrice"],@"bookCurrentPrice", nil]];
        [self.tableView reloadData];
    }
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
    NSString *vcTitle = [NSString stringWithFormat:@"《%@》",self.targetItem.bookName];
    webVC.title = vcTitle;
    [self.navigationController pushViewController:webVC animated:NO];
    NSLog(@"clicked GoDouBan Btn");
}



@end
