//
//  PromotionDetailViewController.m
//  MyBookRecycle
//
//  Created by 苏丽荣 on 16/6/26.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "PromotionDetailViewController.h"
#import "SearchInPromotionIndicageViewController.h"
#import "BookDetailViewController.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "AFURLRequestSerialization.h"
#import "BookBaseInfo.h"
#import "BookDetailInfo.h"
#import "EGOImageView.h"
#import "MBProgressHUD.h"

#define ITEM_AMOUT_PER_PAGE 20

@interface PromotionDetailViewController ()<UISearchResultsUpdating>
{
    MBProgressHUD *hud;
}
@property (nonatomic,strong) UISearchController *searchController;
@property (nonatomic, strong) NSArray *searchResults;
@property (nonatomic ,strong) NSMutableArray *BookDataBase;//json  格式的 Array。包含所有书的基本信息

@property (nonatomic ,assign) NSInteger totalPage;//指示当前已经获取的promotionList的页数（每页显示8本书）
@property (nonatomic ,strong) NSString* promotionID;
@property (nonatomic,strong) NSMutableArray *BookList;//所有书籍BaseInfo集合
@property (nonatomic,strong) NSMutableDictionary *BookBaseInfoDic;//当前活动下书籍base集合

@end

@implementation PromotionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareProperty];
    // Do any additional setup after loading the view, typically from a nib.
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    [self initSearchBar];
    [self loadPromotionDetail];
}

- (void) prepareProperty {
    self.BookDataBase = [[NSMutableArray alloc] init];
    self.totalPage = 0;
    self.BookBaseInfoDic = [[NSMutableDictionary alloc] init];
    self.BookList = [[NSMutableArray alloc] init];

}

#pragma mark - PromotionDetail相关
- (void) loadPromotionDetail {
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.contentColor = [UIColor colorWithRed:0.f green:0.6f blue:0.7f alpha:1.f];
    
    // Set the label text.
    hud.label.text = NSLocalizedString(@"加载书籍列表...", @"HUD loading title");
    
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    if (appdele.OnLineTest) {
        [self getPromotionDetail];
    }
    else {
        [self getPromotionDetailLocally];
    }

}

#pragma mark --从服务器获取PromotionDetail
- (void) getPromotionDetail
{
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    NSString *url = [NSString stringWithFormat:@"%@/promotion/detail/",appdele.baseUrl];

//    NSString *promotionKey = @"4081/";
    NSString* promotionKey = self.promotion.promotionID;
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:promotionKey,@"promotionID",nil];
    [appdele.manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"get promotion detail sucess");
         NSArray* JsonArr = [responseObject objectForKey:@"book"];
         [self formPromotionDetail:JsonArr];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"get promotion detail sucess fail");
     }];
}

#pragma mark --从本地文件更新PromotionDetail
- (void) getPromotionDetailLocally {
    [self initBookDataBase];
    NSArray* JsonArr = [self FetchBookListForPageLocally:self.totalPage];
    [self formPromotionDetail:JsonArr];
}

- (void) initBookDataBase {
    // 获取JSON文件所在的路径
    NSString* jsonPath = [[NSBundle mainBundle] pathForResource:@"promotionDetail"
                                                         ofType:@"json"];
    // 读取jsonPath对应文件的数据
    NSData* data = [NSData dataWithContentsOfFile:jsonPath];
    // 调用JSONKit为NSData扩展的objectFromJSONData方法解析JSON数据
    
    NSDictionary *parseResult = [NSJSONSerialization JSONObjectWithData:data
                                                                options:0 error:nil];
    self.promotionID = [parseResult objectForKey:@"promotionID"];
    NSArray* rawBookArray = [parseResult valueForKey:@"book"];
    NSSet *BookSet = [NSSet setWithArray:rawBookArray];
    NSArray *arr = [self arrayFromSet:BookSet];
    [self.BookDataBase addObjectsFromArray:arr];//存储最原始的Json形式的书籍列表数组。
}

- (NSArray*)FetchBookListForPageLocally:(NSInteger)page
{
    //每一页装20条数据。page的标号从0开始
    //测试时从数据库获取，联网时请求获得
    //返回的是Json形式的Array（Array中每个元素是用Json dictionary来表示
    NSLog(@"fetch list for page:%ld",page);
    NSMutableArray* result = [[NSMutableArray alloc] init];
    NSInteger start_index = page * ITEM_AMOUT_PER_PAGE;
    NSInteger end_index = start_index + ITEM_AMOUT_PER_PAGE;
    if (start_index >= self.BookDataBase.count) {
        return nil;
    }
    else if (end_index > self.BookDataBase.count)
    {
        end_index = self.BookDataBase.count;
    }
    for (NSInteger i = start_index; i < end_index; ++ i) {
        [result addObject:self.BookDataBase[i]];
    }
    self.totalPage ++;
    return [result copy];
}

#pragma mark --数据解析共有部分
- (void)formPromotionDetail:(NSArray*)arr {
    NSArray *bookBaseInfos = [self formPromotionDetailWithJsonList:arr];
    [self.BookList addObjectsFromArray:bookBaseInfos];
    [hud hideAnimated:YES];
    [self.tableView reloadData];

}

//输入包含若干本书的NSArray，其中每本书的表示形式为Dictionary格式
//返回值：需要BookbaseInfo array
- (NSArray*)formPromotionDetailWithJsonList:(NSArray*)arr {
    NSSet *tempSet = [NSSet setWithArray:arr];
    NSMutableArray *BookNeedLoadDetail = [[NSMutableArray alloc] init];
    NSArray *currentBookISBN = [self.BookBaseInfoDic allKeys];
    
    NSEnumerator *enumerator = [tempSet objectEnumerator];
    id book;
    while ((book = [enumerator nextObject])) {
        NSString* bookISBN = [book objectForKey:@"promotionBookISBN"];
        if (![currentBookISBN containsObject:bookISBN]) {
            BookBaseInfo *info = [[BookBaseInfo alloc] initBook:bookISBN name:[book objectForKey:@"promotionBookName"] currentPrice:[book objectForKey:@"promotionBookPrice"] imageLink:[book objectForKey:@"promotionBookImageLink"]];
            
            [BookNeedLoadDetail addObject:info];
            [self.BookBaseInfoDic setObject:info forKey:bookISBN];
        }
    }
    return BookNeedLoadDetail;
}
- (NSArray*) arrayFromSet:(NSSet*)aSet {
    
    NSEnumerator *enumerator = [aSet objectEnumerator];
    id value;
    
    NSMutableArray* tempArr = [[NSMutableArray alloc] init];
    while ((value = [enumerator nextObject])) {
        [tempArr addObject:value];
    }
    return [tempArr copy];
}

#pragma mark --上拉加载更多
- (void)loadMoreData
{
    NSArray* JsonArr = [self FetchBookListForPageLocally:self.totalPage];
    NSArray *bookBaseInfos = [self formPromotionDetailWithJsonList:JsonArr];
    [self.BookList addObjectsFromArray:bookBaseInfos];
    [self.tableView reloadData];
}

#pragma mark - 搜索相关
#pragma mark -- UISearchControllerDelegate & UISearchResultsDelegate

// Called when the search bar becomes first responder
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
    // Set searchString equal to what's typed into the searchbar
    NSString *searchString = self.searchController.searchBar.text;
    if (self.searchController.searchResultsController) {
        UINavigationController *navController = (UINavigationController *)self.searchController.searchResultsController;
        
        // Present SearchResultsTableViewController as the topViewController
        SearchInPromotionIndicageViewController* vc = (SearchInPromotionIndicageViewController *)navController.topViewController;
        [self filteredContentBySubString:searchString];
        vc.searchResults = self.searchResults;
        vc.searchStr = searchString;
        vc.promotionID = self.promotion.promotionID;
        // And reload the tableView with the new data
        [vc.tableView reloadData];
        
    }
}

- (void)filteredContentBySubString:(NSString *)subStr
{
//    self.searchResults = [NSMutableArray arrayWithObjects:@"1",@"2'", nil];

    if ([subStr  isEqual: @""]) {
        
        // If empty the search results are the same as the original data
        self.searchResults = [self.BookList copy];
    } else {
        NSPredicate* pred = [NSPredicate predicateWithFormat:
                             @"%K CONTAINS %@" ,@"promotionBookName",subStr];
        self.searchResults = [[self.BookList copy] filteredArrayUsingPredicate:pred];
        
    }
}

#pragma mark - talbeView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.BookList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BookDetailViewController* bookDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"BookDetailViewController"];
    if (self.promotion.promotionType == GroupBuy) {
        bookDetailVC.IsGroupBuy = YES;
    }
    else bookDetailVC.IsGroupBuy = NO;
    bookDetailVC.bookBaseInfo = [self.BookList objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:bookDetailVC animated:NO];
}



-(UITableViewCell *)tableView:tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellId = @"PromotionDetailCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellId];
    }
    
    BookBaseInfo *baseInfo = [self.BookList objectAtIndex:indexPath.row];
    EGOImageView *imgView = (EGOImageView*)[cell viewWithTag:1];
    imgView.imageURL = [NSURL URLWithString:baseInfo.promotionBookImageLink];
    UILabel *label;
    label = (UILabel*)[cell viewWithTag:2];
    label.text = baseInfo.promotionBookName;
    label = (UILabel*)[cell viewWithTag:3];
    label.text = baseInfo.PromotionBookISBN;
    label = (UILabel*)[cell viewWithTag:4];
    label.text = baseInfo.PromotionBookCurrentPrice;
    return cell;
}

#pragma mark - 其他
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initSearchBar {
    UINavigationController* searchResultVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"NavSearchInPromotionIndicageViewController"];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultVC];
    self.searchController.searchResultsUpdater = self;
    CGRect frame = [self.view frame];
    self.searchController.searchBar.frame = CGRectMake(0,200,frame.size.width, 44.0);
    self.searchController.searchBar.placeholder = @"搜索书籍";
    self.definesPresentationContext = YES;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.tableView.tableHeaderView = self.searchController.searchBar;
}

@end