//
//  PromotionDetailViewController.m
//  MyBookRecycle
//
//  Created by 苏丽荣 on 16/6/26.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "PromotionDetailViewController.h"
#import "BookDetailViewController.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "AFURLRequestSerialization.h"
#import "BookBaseInfo.h"
#import "BookDetailInfo.h"
#import "EGOImageView.h"

#define ITEM_AMOUT_PER_PAGE 20

@interface PromotionDetailViewController ()
@property (nonatomic ,strong) NSMutableArray *BookDataBase;//json  格式的 Array。包含所有书的基本信息
@property (nonatomic ,strong) NSMutableDictionary *BookDetailDB;//json格式的bookDetailList,本地测试使用，［key 为 isbn，值为json数组（包含豆瓣网上返回的所有信息），本地测试使用］
@property (nonatomic ,assign) NSInteger totalPage;//指示当前已经获取的promotionList的页数（每页显示8本书）
@property (nonatomic ,strong) NSString* promotionID;
@property (nonatomic,strong) NSMutableArray *BookList;//所有书籍BaseInfo集合
@property (nonatomic ,strong) NSMutableSet *localAllBookIsbns;
@property (nonatomic,strong) NSMutableDictionary *BookDetailInfoDic;//当前活动下书籍DetailInfo集合
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
    [self loadPromotionDetailLocally];
    
//    [self loadPromotionDetail];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --从服务器获取信息
- (void) loadPromotionDetail
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
         NSArray *bookNeedLoadDetailInfo = [self formPromotionDetailWithJsonList:JsonArr];
         [self fetchBookDetailInfo:bookNeedLoadDetailInfo];
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"get promotion detail sucess fail");
     }];
}

-(void)fetchBookDetailInfo:(NSArray*)baseInfoList
{
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    NSString *baseUrl = [NSMutableString stringWithString:@"https://api.douban.com/v2/book/isbn/:"];
    dispatch_group_t group = dispatch_group_create();
    for (id book in baseInfoList)
    {
        NSString *isbn = [book valueForKey:@"PromotionBookISBN"];
        NSLog(@"%@",isbn);
        NSString *url = [NSString stringWithFormat:@"%@%@",baseUrl,isbn];
        dispatch_group_enter(group);
        [appdele.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             [self formBookDetailInfo:responseObject];
             dispatch_group_leave(group);
         }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"fetch bookdetail fail");
             dispatch_group_leave(group);
         }];
    }
    dispatch_group_notify(group,dispatch_get_main_queue(),^{
        // Won't get here until everything has finished
        [self.tableView.mj_footer endRefreshing];
    });
}

#pragma mark --从本地文件更新PromotionDetail
- (NSArray*) arrayFromSet:(NSSet*)aSet {

        NSEnumerator *enumerator = [aSet objectEnumerator];
        id value;
    
        NSMutableArray* tempArr = [[NSMutableArray alloc] init];
        while ((value = [enumerator nextObject])) {
            [tempArr addObject:value];
        }
    return [tempArr copy];
}

- (void) loadPromotionDetailLocally {
    [self initBookDataBase];
    [self initLocalBookDetailDataBase];
    NSArray* JsonArr = [self FetchBookListForPageLocally:self.totalPage];
    NSArray *bookNeedLoadDetailInfo = [self formPromotionDetailWithJsonList:JsonArr];
    [self fetchBookDetailInfoLocaly:bookNeedLoadDetailInfo];
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
    [self GetAllIsbnLocally];
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

#pragma mark --从本地文件获取BookDetailInfoList
- (void) initLocalBookDetailDataBase {
    // 获取JSON文件所在的路径
    NSString* jsonPath = [[NSBundle mainBundle] pathForResource:@"bookDetail"
                                                         ofType:@"json"];
    // 读取jsonPath对应文件的数据
    NSData* data = [NSData dataWithContentsOfFile:jsonPath];
    // 调用JSONKit为NSData扩展的objectFromJSONData方法解析JSON数据
    NSDictionary *parseResult = [NSJSONSerialization JSONObjectWithData:data
                                                        options:0 error:nil];
    for (id JsonInfo in parseResult) {
        //键值对，键为ISBN，值为Json数组形式的书籍信息（最原始的）
        [self.BookDetailDB setObject:JsonInfo forKey:[JsonInfo objectForKey:@"isbn13"]];
        }
}

-(void)fetchBookDetailInfoLocaly:(NSArray*)baseInfoList{
    
    [self.BookList addObjectsFromArray:baseInfoList];
    for (id book in baseInfoList)
    {
        NSString *isbn = [book valueForKey:@"PromotionBookISBN"];
        NSDictionary *detailInfo = [self GetBookDetailInfoLocaly:isbn];
        [self formBookDetailInfo:detailInfo];
    }
    [self.tableView.mj_footer endRefreshing];
}
 //返回NSDictionary表示的书籍所有详细信息列表
- (NSDictionary *)GetBookDetailInfoLocaly:(NSString*)bookISBN {
    return [self.BookDetailDB objectForKey:bookISBN];
}


- (void)GetAllIsbnLocally
{
    for (id obj in self.BookDataBase) {
        [self.localAllBookIsbns addObject:[obj objectForKey:@"promotionBookISBN"]];
    }
    //    NSEnumerator *enumerator = [self.localAllBookIsbns objectEnumerator];
    //    id value;
    //    while ((value = [enumerator nextObject])) {
    //        NSLog(@",%@",value);
    //    }
    
}

#pragma mark --数据解析共有部分
//输入包含若干本书的NSArray，其中每本书的表示形式为Dictionary格式
//返回值：需要载入detail infomation的BookbaseInfo array
- (NSArray*)formPromotionDetailWithJsonList:(NSArray*)arr {
    NSMutableArray *BookNeedLoadDetail = [[NSMutableArray alloc] init];
    NSArray *currentBookISBN = [self.BookBaseInfoDic allKeys];

    for (id book in arr)
    {
        NSString* bookISBN = [book objectForKey:@"promotionBookISBN"];
        if (![currentBookISBN containsObject:bookISBN]) {
            BookBaseInfo *info = [[BookBaseInfo alloc] initBook:bookISBN withOriginalPrice:[book objectForKey:@"promotionBookPrice"] currentPrice:[book objectForKey:@"promotionBookCurrentPrice"] searchLink:[book objectForKey:@"promotionBookSearchLink"]];
            [BookNeedLoadDetail addObject:info];
            [self.BookBaseInfoDic setObject:info forKey:bookISBN];
        }
    }
    return BookNeedLoadDetail;
}

- (void)formBookDetailInfo:(NSDictionary*)detailInfoDic {
    NSString *isbn = [detailInfoDic objectForKey:@"isbn13"];
    BookBaseInfo *book = [self.BookBaseInfoDic objectForKey:isbn];
    BookDetailInfo *info = [[BookDetailInfo alloc] initBook:book withImages:[detailInfoDic objectForKey:@"images"] title:[detailInfoDic objectForKey:@"title"] publisher:[detailInfoDic objectForKey:@"publisher"] pubdate:[detailInfoDic objectForKey:@"pubdate"] pages:[detailInfoDic objectForKey:@"pages"] author:[detailInfoDic objectForKey:@"author"] summary:[detailInfoDic objectForKey:@"summary"] author_intro:[detailInfoDic objectForKey:@"author_intro"] rating:[detailInfoDic objectForKey:@"rating"] catalog:[detailInfoDic objectForKey:@"catalog"] tags:[detailInfoDic objectForKey:@"tags"] doubanLink:[detailInfoDic objectForKey:@"url"]];
    [self.BookDetailInfoDic setObject:info forKey:isbn];
    [self.tableView reloadData];
}


#pragma mark --上拉加载更多
- (void)loadMoreData
{
    NSArray* JsonArr = [self FetchBookListForPageLocally:self.totalPage];
    NSArray *bookNeedLoadDetailInfo = [self formPromotionDetailWithJsonList:JsonArr];
    [self fetchBookDetailInfoLocaly:bookNeedLoadDetailInfo];
}

#pragma mark --内部函数
- (void) prepareProperty
{
    self.BookDataBase = [[NSMutableArray alloc] init];
    self.totalPage = 0;
    self.BookDetailInfoDic = [[NSMutableDictionary alloc] init];
    self.BookBaseInfoDic = [[NSMutableDictionary alloc] init];
    self.BookList = [[NSMutableArray alloc] init];
    self.localAllBookIsbns = [[NSMutableSet alloc] init];
    self.BookDetailDB = [[NSMutableDictionary alloc] init];
}


#pragma mark -- talbeView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.BookDetailInfoDic.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BookDetailViewController* bookDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"BookDetailViewController"];
    if (self.promotion.promotionType == GroupBuy) {
        bookDetailVC.IsGroupBuy = YES;
    }
    else bookDetailVC.IsGroupBuy = NO;
    NSString *isbn = [[self.BookList objectAtIndex:indexPath.row] valueForKey:@"PromotionBookISBN"];
    BookDetailInfo *info = [self.BookDetailInfoDic objectForKey:isbn];
    bookDetailVC.bookdetailInfo = info;
    [self.navigationController pushViewController:bookDetailVC animated:NO];
}



-(UITableViewCell *)tableView:tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellId = @"PromotionDetailCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellId];
    }
    
    NSString *isbn = [[self.BookList objectAtIndex:indexPath.row] valueForKey:@"PromotionBookISBN"];
    BookDetailInfo *info = [self.BookDetailInfoDic objectForKey:isbn];
    if (info) {
        EGOImageView *imgView = (EGOImageView*)[cell viewWithTag:1];
        NSString *bookImgUrl = [info.images objectForKey:@"large"];
        imgView.imageURL = [NSURL URLWithString:bookImgUrl];
        
        UILabel *label;
        label = (UILabel*)[cell viewWithTag:2];
        label.text = [info valueForKey:@"title"];
        
        label = (UILabel*)[cell viewWithTag:3];
        label.text = info.baseInfo.PromotionBookCurrentPrice;
        
        label = (UILabel*)[cell viewWithTag:4];
        NSArray * author_array = [info valueForKey:@"author"];
        NSMutableString *authors;
        if (author_array.count) {
            authors = [[NSMutableString alloc] initWithString:[author_array objectAtIndex:0]];
            for (int i = 1; i < author_array.count; ++ i) {
                [authors appendString:[NSString stringWithFormat:@",%@",[author_array objectAtIndex:i]]];
            }
       
        }
        label.text = authors;
        
        label = (UILabel*)[cell viewWithTag:5];
        label.text = [info.rating objectForKey:@"average"];
    }
    
    return cell;
}


@end