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
#import "Promotion.h"
#import "AppDelegate.h"
#import "PromotionCell.h"
#import "WebViewController.h"
#import "Promotion.h"
//#import "JSONKit.h"
//#import "PromotionCell.h"
@interface PromotionViewController ()<UISearchResultsUpdating,UITableViewDataSource,UITableViewDelegate>

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
//    [self GetPromotrion];
    [self GetPromotrionFromLocal];

    [self initSearchBar];
    [self initSegmentCtl];
    self.table.delegate = self;
    self.table.dataSource = self;
    
    
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [self.table reloadData];
//}
#pragma mark -- 初始化相关子视图

- (void)initSegmentCtl{
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:self.shopWithActivity];
//    [segmentedControl insertSegmentWithTitle:@"全部“" atIndex:0 animated:NO];
    segmentedControl.frame = CGRectMake(10.0, 74.0, 355, 20.0);
    NSInteger defaultSeletedIndex = [self.shopWithActivity indexOfObject:@"全部"];
    segmentedControl.selectedSegmentIndex = defaultSeletedIndex;//设置默认选择项索引
    self.currentShop = [self.shopWithActivity objectAtIndex:segmentedControl.selectedSegmentIndex];//同时设置对应的表格数据
    [segmentedControl addTarget:self action:@selector(selectShop:)  forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
}

- (void)initSearchBar{
    UINavigationController* searchResultVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"TableSearchResultsNavController"];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultVC];
    self.searchController.searchResultsUpdater = self;
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    //    self.definesPresentationContext = YES;
    CGRect frame = [self.view frame];
    self.searchController.searchBar.frame = CGRectMake(0,200,frame.size.width, 44.0);
    self.searchController.searchBar.placeholder = @"搜索促销活动或者书籍";
    self.definesPresentationContext = YES;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.navigationItem.titleView = self.searchController.searchBar;
}
#pragma mark -- UISegmentedControl响应函数
-(void)selectShop:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    self.currentShop = [self.shopWithActivity objectAtIndex:Index];
    [self.table reloadData];
}
#pragma mark -- talbeView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.shopActivitys objectForKey:self.currentShop] count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(PromotionCell *)tableView:tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    // 为表格行定义一个静态字符串作为标示符
    static NSString* cellId = @"cellId";
    PromotionCell* cell = [tableView
                             dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[PromotionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSArray* promotions = [self.shopActivitys objectForKey:self.currentShop];
    cell.promotion = [promotions objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"Amazon"];
    cell.textLabel.text = [cell.promotion valueForKey:@"promotionName"];
    cell.detailTextLabel.text = @"我听过空境的回忆，雨水浇绿孤山岭，听过被没听过你；我抓住散落的欲望，缱绻的馥郁让我紧张，我抓住时间的假想，没抓住你";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
(NSIndexPath *)indexPath
{
    PromotionCell *cell= (PromotionCell*)[tableView cellForRowAtIndexPath:indexPath];
    PromotionType type = cell.promotion.promotionType;
    
    
    switch (type) {
        case GroupBuy:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            PromotionDetailViewController* detailVC = [storyboard instantiateViewControllerWithIdentifier:@"PromotionDetailViewController"];
            detailVC.promotion = cell.promotion;
            [self.navigationController pushViewController:detailVC animated:NO];
        }
            break;
//        case PartDiscout:
//            break;
        default:
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

#pragma mark - UISearchControllerDelegate & UISearchResultsDelegate

// Called when the search bar becomes first responder
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    // Set searchString equal to what's typed into the searchbar
    NSString *searchString = self.searchController.searchBar.text;
    // If searchResultsController
    if (self.searchController.searchResultsController) {
        
        UINavigationController *navController = (UINavigationController *)self.searchController.searchResultsController;
        
        // Present SearchResultsTableViewController as the topViewController
        searchResultTableViewController* vc = (searchResultTableViewController *)navController.topViewController;
        // Update searchResults
        [self filteredContentBySubString:searchString];
        vc.searchResults = self.searchResults;
        vc.searchStr = searchString;
        
        // And reload the tableView with the new data
        [vc.tableView reloadData];
    }
}
//- (void)searchBar:(UISearchBar *)searchBar
//    textDidChange:(NSString *)searchText
//{
//    NSLog(@"text change");
//}




#pragma mark -- 内部函数
//- (NSArray*)getActivityName
//{
//    return [NSArray arrayWithObjects:@"全部", @"京东", @"当当", nil];
//}

- (void)PrepareProperty
{
    self.shopActivitys = [[NSMutableDictionary alloc] init];
    self.searchResults = [[NSMutableArray alloc] init];
    self.promotionList = [[NSMutableArray alloc] init];
    self.allShop = [[NSMutableSet alloc] init];
}

- (void)GetProMotionListFormJsonArray:(NSArray*)Lists
{
    for (id promotion in Lists) {

        Promotion *pro = [[Promotion alloc] initPromotion:[promotion objectForKey:@"promotionID"] withName:[promotion objectForKey:@"promotionName"] urlString:[promotion objectForKey:@"promotionLink"] company:[promotion objectForKey:@"promotionCompany"] deadLine:[promotion objectForKey:@"promotionDeadline"] type:GroupBuy];
        [self.promotionList addObject:pro];
    }
    [self classifyActivity];
    
}

- (void)GetPromotrionFromLocal
{
    // 获取JSON文件所在的路径
    NSString* jsonPath = [[NSBundle mainBundle] pathForResource:@"promotionList"
                                                         ofType:@"json"];
    // 读取jsonPath对应文件的数据
    NSData* data = [NSData dataWithContentsOfFile:jsonPath];
    // 调用JSONKit为NSData扩展的objectFromJSONData方法解析JSON数据
    
    NSArray *parseResult = [NSJSONSerialization JSONObjectWithData:data
                                                           options:0 error:nil];
    [self GetProMotionListFormJsonArray:parseResult];
}

- (void)GetPromotrion
{
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
//    NSString *baseUrl = [NSMutableString stringWithString:@"https://api.douban.com/v2/book/isbn/:"];
 
    
    NSString *url = @"http://115.159.219.141:8000/promotion/list/";
    [appdele.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"seccess");
         
         //here returns NSArray/
         [self GetProMotionListFormJsonArray:responseObject];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         NSLog(@"fail in fetch promotion List");
     }];
}

- (void)classifyActivity{
    for (id pro in self.promotionList)
    {
        NSString *shopname = [pro valueForKey:@"promotionCompany"];
        NSMutableArray *promotionOfAShop = [self.shopActivitys objectForKey:shopname];
        if (promotionOfAShop) {
            [promotionOfAShop addObject:pro];
        }
        else {
            [self.shopActivitys setObject:[[NSMutableArray alloc] initWithObjects:pro, nil] forKey:shopname];
        }
    }
    [self.shopActivitys setObject:self.promotionList forKey:@"全部"];
    self.shopWithActivity = [self.shopActivitys allKeys];
}

- (void)filteredContentBySubString:(NSString *)subStr
{
    
        if ([subStr  isEqual: @""]) {
    
            // If empty the search results are the same as the original data
            self.searchResults = [self.promotionList mutableCopy];
        } else {
//            NSPredicate* pred = [NSPredicate predicateWithFormat:
//                                 @"%K CONTAINS[c] %@" ,@"activityName",subStr];
            NSPredicate* pred = [NSPredicate predicateWithFormat:
                                 @"%K CONTAINS %@" ,@"activityName",subStr];
            // 使用谓词过滤NSArray
            self.searchResults = [NSMutableArray arrayWithArray:[self.promotionList filteredArrayUsingPredicate:pred]];
        }
}








@end
