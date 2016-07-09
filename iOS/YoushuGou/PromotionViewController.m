//
//  PromotionViewController.m
//  MyBookRecycle
//
//  Created by 苏丽荣 on 16/6/25.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "PromotionViewController.h"
#import "searchResultTableViewController.h"
#import "PromotionDetailViewController.h"
#import "welcomeViewController.h"
#import "Promotion.h"
#import "AppDelegate.h"
#import "PromotionCell.h"
#import "WebViewController.h"
#import "Promotion.h"
#import "MBProgressHUD.h"
@interface PromotionViewController ()<UISearchResultsUpdating,UITableViewDataSource,UITableViewDelegate,NavigateToPromotion>
{
    MBProgressHUD *hud;
}

@property (nonatomic,strong) UISegmentedControl *ShopsSegment;
@property (nonatomic,strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic,strong) NSMutableArray *promotionList;//所有促销活动集合
@property (nonatomic, strong) NSMutableDictionary *shopActivitys;//根据shop对促销活动进行了分类的集合
@property (nonatomic, strong) NSMutableSet *allShop;//根据shop对促销活动进行了分类的集合
@property (nonatomic,strong) NSArray *promotionIds;//所有促销活动ID集合
@property (nonatomic,strong) NSArray *shopWithActivity;//所有包含有促销活动的商店名
@property (nonatomic,copy) NSString *currentShop;//当前展示的商店
@end

@implementation PromotionViewController

- (void)viewDidLoad {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    [self PrepareProperty];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self loadPromotionList];
}

- (void)PrepareProperty
{
    self.shopWithActivity = [[NSMutableArray alloc] init];
    self.shopActivitys = [[NSMutableDictionary alloc] init];
    self.searchResults = [[NSMutableArray alloc] init];
    self.promotionList = [[NSMutableArray alloc] init];
    self.allShop = [[NSMutableSet alloc] init];
}

#pragma mark - promotionList相关
- (void) loadPromotionList {
    
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.contentColor = [UIColor colorWithRed:0.f green:0.6f blue:0.7f alpha:1.f];
    hud.label.text = NSLocalizedString(@"加载活动列表...", @"HUD loading title");
    
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    if (appdele.OnLineTest) {
        [self getPromotrion];
    }
    else {
        [self getPromotrionLocally];
    }

}

- (void)getPromotrionLocally
{
    // 获取JSON文件所在的路径
    NSString* jsonPath = [[NSBundle mainBundle] pathForResource:@"promotionList"
                                                         ofType:@"json"];
    // 读取jsonPath对应文件的数据
    NSData* data = [NSData dataWithContentsOfFile:jsonPath];
    // 调用JSONKit为NSData扩展的objectFromJSONData方法解析JSON数据
    
    NSArray *parseResult = [NSJSONSerialization JSONObjectWithData:data
                                                           options:0 error:nil];
    [self formMotionListFormJsonArray:parseResult];
}

- (void)getPromotrion
{
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    NSString *url = [NSString stringWithFormat:@"%@/promotion/list/",appdele.baseUrl];
    [appdele.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"seccess in PromotionViewController,GetPromotrion");
         
         //here returns NSArray/
         [self formMotionListFormJsonArray:responseObject];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         [hud hideAnimated:NO];
         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"服务器无响应" message:@"获取活动列表失败" preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
         [alert addAction:defaultAction];
         [self presentViewController:alert animated:YES completion:nil];
     }];
}

#pragma mark -- 公用解析函数
- (void)formMotionListFormJsonArray:(NSArray*)Lists
{
    for (id promotion in Lists) {
         PromotionType type;
        if ([[promotion objectForKey:@"promotionSearchLink"] isEqualToString:@""]) {
            type = Other;
        }
        else {
            NSString *proName = [promotion objectForKey:@"promotionName"];
            type = [self getTypeOfPromotion:proName];
        }
        Promotion *pro = [[Promotion alloc] initPromotion:[promotion objectForKey:@"promotionID"] withName:[promotion objectForKey:@"promotionName"] urlString:[promotion objectForKey:@"promotionLink"] company:[promotion objectForKey:@"promotionCompany"] deadLine:[promotion objectForKey:@"promotionDeadline"] type:type];
        [self.promotionList addObject:pro];
    }
    [hud hideAnimated:YES];
    [self classifyActivity];
    [self initSearchBar];
    [self initSegmentCtl];
    [self.table reloadData];
    
}
- (void)classifyActivity{
    for (id pro in self.promotionList)
    {
        NSString *shopname = [pro valueForKey:@"promotionCompany"];
        [self.shopActivitys setObject:self.promotionList forKey:@"全部"];
        NSMutableArray *promotionOfAShop = [self.shopActivitys objectForKey:shopname];
        if (promotionOfAShop) {
            [promotionOfAShop addObject:pro];
        }
        else {
            [self.shopActivitys setObject:[[NSMutableArray alloc] initWithObjects:pro, nil] forKey:shopname];
        }
    }
    
    self.shopWithActivity = [self.shopActivitys allKeys];
    NSInteger index = [self.shopWithActivity indexOfObject:@"全部"];
    NSMutableArray *tempArr = [[NSMutableArray alloc] initWithArray:self.shopWithActivity];
    [tempArr exchangeObjectAtIndex:0 withObjectAtIndex:index];
    self.shopWithActivity = tempArr;
}
#pragma mark - 视图相关
#pragma mark -- 初始化相关子视图

- (void)initSegmentCtl{
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:self.shopWithActivity];
    segmentedControl.frame = CGRectMake(10.0, 74.0, 355, 30.0);
    NSInteger defaultSeletedIndex = [self.shopWithActivity indexOfObject:@"全部"];
    segmentedControl.selectedSegmentIndex = defaultSeletedIndex;//设置默认选择项索引
    self.currentShop = [self.shopWithActivity objectAtIndex:segmentedControl.selectedSegmentIndex];//同时设置对应的表格数据
    [segmentedControl addTarget:self action:@selector(selectShop:)  forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    //    self.navigationItem.titleView = segmentedControl;
}

- (void)initSearchBar {
    UINavigationController* navSearchResultVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"navSearchResultTableViewController"];
    searchResultTableViewController *searchResultVC = (searchResultTableViewController*)navSearchResultVC.topViewController;
    searchResultVC.promotionDelegate = self;
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:navSearchResultVC];
    self.searchController.searchResultsUpdater = self;
    CGRect frame = [self.view frame];
    self.searchController.searchBar.frame = CGRectMake(0,200,frame.size.width, 44.0);
    self.searchController.searchBar.placeholder = @"搜索促销活动或者书籍";
    self.definesPresentationContext = YES;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    //    self.table.tableHeaderView = self.searchController.searchBar;
    self.navigationItem.titleView = self.searchController.searchBar;
}


#pragma mark -- UISegmentedControl响应函数
-(void)selectShop:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    self.currentShop = [self.shopWithActivity objectAtIndex:Index];
    [self.table reloadData];
}
#pragma mark - talbeView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.shopActivitys objectForKey:self.currentShop] count];
}

-(PromotionCell *)tableView:tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 为表格行定义一个静态字符串作为标示符
    static NSString* cellId = @"PromotionCell";
    PromotionCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[PromotionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSArray* promotions = [self.shopActivitys objectForKey:self.currentShop];
    cell.promotion = [promotions objectAtIndex:indexPath.row];
    UIImageView *imgView = (UIImageView*)[cell viewWithTag:1];
    imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",cell.promotion.promotionCompany]];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *label = (UILabel*)[cell viewWithTag:2];
    label.text = cell.promotion.promotionName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
(NSIndexPath *)indexPath
{
    PromotionCell *cell= (PromotionCell*)[tableView cellForRowAtIndexPath:indexPath];
    PromotionType type = cell.promotion.promotionType;
    
    
    switch (type) {
        case PartDiscout:
        case GroupBuy:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            PromotionDetailViewController* detailVC = [storyboard instantiateViewControllerWithIdentifier:@"PromotionDetailViewController"];
            detailVC.promotion = cell.promotion;
            [self.navigationController pushViewController:detailVC animated:NO];
        }
            break;
        case Other:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            WebViewController* webVC = [storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
            webVC.urlStr = cell.promotion.promotionLink;
            webVC.title = cell.promotion.promotionName;
            [self.navigationController pushViewController:webVC animated:NO];
        }
            break;
    }
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
        searchResultTableViewController* vc = (searchResultTableViewController *)navController.topViewController;
        [self filteredContentBySubString:searchString];
        vc.searchResults = self.searchResults;
        vc.searchStr = searchString;
        
        // And reload the tableView with the new data
        [vc.tableView reloadData];
        
    }
}

- (void)filteredContentBySubString:(NSString *)subStr
{
    
        if ([subStr  isEqual: @""]) {
    
            // If empty the search results are the same as the original data
            self.searchResults = [self.promotionList mutableCopy];
        } else {
            NSPredicate* pred = [NSPredicate predicateWithFormat:
                                 @"%K CONTAINS %@" ,@"promotionName",subStr];
            NSArray *tempArr = [[self.promotionList copy] filteredArrayUsingPredicate:pred];
            self.searchResults = [NSMutableArray arrayWithArray:tempArr];
        }
}


#pragma mark - 活动分类
- (PromotionType)getTypeOfPromotion:(NSString*)proName {
    if ([proName containsString:@"满"] && [proName containsString:@"减"]) {
        return GroupBuy;
    }
    else return PartDiscout;
}





- (IBAction)goWelCome:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    welcomeViewController *homeVC = [storyboard instantiateViewControllerWithIdentifier:@"NavWelcomeViewController"];
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    appdele.window.rootViewController = homeVC;
}

#pragma mark - NavigateToPromotion协议
- (void)navigateToPromotion:(Promotion *)pro {
    PromotionType type = pro.promotionType;
    
    switch (type) {
        case PartDiscout:
        case GroupBuy:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            PromotionDetailViewController* detailVC = [storyboard instantiateViewControllerWithIdentifier:@"PromotionDetailViewController"];
            detailVC.promotion = pro;
            [self.navigationController pushViewController:detailVC animated:NO];
        }
            break;
        case Other:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            WebViewController* webVC = [storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
            webVC.urlStr = pro.promotionLink;
            webVC.title = pro.promotionName;
            [self.navigationController pushViewController:webVC animated:NO];
        }
            break;
    }
}

@end
