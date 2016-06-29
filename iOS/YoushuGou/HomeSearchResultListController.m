//
//  HomeSearchResultListController.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/6/29.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "HomeSearchResultListController.h"
#import "HomeSearchDetailController.h"
#import "HomeSearchListItem.h"
#import "EGOImageView.h"
@interface HomeSearchResultListController ()
@property (nonatomic ,strong) NSMutableArray *searchItemList;
@end

@implementation HomeSearchResultListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"找到的\"%@\"",self.searchBookName];
    [self prepareProperty];
    [self searInHome];
    
    
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

    return self.searchItemList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellId = @"HomeSearchResultListControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellId];
    }
    HomeSearchListItem *item = [self.searchItemList objectAtIndex:indexPath.row];
      if (item) {
        EGOImageView *imgView = (EGOImageView*)[cell viewWithTag:1];
        NSString *bookImgUrl = item.bookImageLink;
        imgView.imageURL = [NSURL URLWithString:bookImgUrl];
        
        UILabel *label;
        label = (UILabel*)[cell viewWithTag:2];
        label.text = item.bookName;
        
        label = (UILabel*)[cell viewWithTag:3];
        label.text = item.bookDetail;
        
        label = (UILabel*)[cell viewWithTag:4];
        label.text = item.bookLowestPrice;
        
        UIButton *btn = (UIButton*)[cell viewWithTag:5];
        [btn addTarget:self action:@selector(GoDouBan:) forControlEvents:UIControlEventTouchUpInside];
        
      }
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
(NSIndexPath *)indexPath
{
    HomeSearchListItem *item = [self.searchItemList objectAtIndex:indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController *navVC = [storyboard instantiateViewControllerWithIdentifier:@"NavHomeSearchDetailController"];
//    HomeSearchDetailController *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"HomeSearchDetailController"];
    HomeSearchDetailController *detailVC = (HomeSearchDetailController*)navVC.topViewController;
    detailVC.targetItem = item;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - 在主页搜索
- (void) searInHome {
    NSArray *JsonData = [self fetHomeSearchResultLocaly];
    [self fetchSearchItemList:JsonData];
    
}

#pragma mark - 根据本地文件更新数据
// 模拟网络请求，返回的是Home搜索后得到的json Array
- (NSArray*)fetHomeSearchResultLocaly {
    NSString* jsonPath = [[NSBundle mainBundle] pathForResource:@"homeSearchList"
                                                         ofType:@"json"];
    // 读取jsonPath对应文件的数据
    NSData* data = [NSData dataWithContentsOfFile:jsonPath];
    // 调用JSONKit为NSData扩展的objectFromJSONData方法解析JSON数据
    
    NSArray *parseResult = [NSJSONSerialization JSONObjectWithData:data
                                                           options:0 error:nil];
    return parseResult;
}

#pragma mark - 根据Json数据生成HomeSearchListItem
- (void)fetchSearchItemList:(NSArray*)arr {
    for (id obj in arr) {
        HomeSearchListItem *item = [[HomeSearchListItem alloc] initBook:[obj objectForKey:@"bookName"] doubanLink:[obj objectForKey:@"booSubject"] imgLink:[obj objectForKey:@"bookImageLink"] detail:[obj objectForKey:@"bookDetail"] lowestPrice:[obj objectForKey:@"bookLowestPrice"]];
        [self.searchItemList addObject:item];
    }
}
#pragma mark - 响应事件
- (void)GoDouBan:(id)sender {
    NSLog(@"clicked GoDouBan Btn");
}


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

#pragma mark --内部函数
- (void) prepareProperty {
    self.searchItemList = [[NSMutableArray alloc] init];
}
- (IBAction)GoHomePage:(id)sender {
}
@end
