//
//  PromotionDetailViewController.m
//  MyBookRecycle
//
//  Created by 苏丽荣 on 16/6/26.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "PromotionDetailViewController.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "AFURLRequestSerialization.h"
#import "BookBaseInfo.h"
#import "BookDetailInfo.h"
#import "EGOImageView.h"

@interface PromotionDetailViewController ()
@property (nonatomic,strong) NSMutableArray *BookList;//所有书籍BaseInfo集合
@property (nonatomic,strong) NSMutableDictionary *BookDetailList;//当前活动下书籍DetailInfo集合
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
    
    [self loadPromotionDetail];
}

- (void)fetchMoreBook{
    NSArray *List = [NSArray arrayWithObjects:
                    [[BookBaseInfo alloc] initBook:@"9780698116498" withOriginalPrice:@"30" currentPrice:@"25" inPromotion:@"Gb京东1"],
                    [[BookBaseInfo alloc] initBook:@"9780375827785" withOriginalPrice:@"30" currentPrice:@"25" inPromotion:@"Gb京东1"],
                    [[BookBaseInfo alloc] initBook:@"9780689835681" withOriginalPrice:@"30" currentPrice:@"25" inPromotion:@"Gb京东1"],
                    [[BookBaseInfo alloc] initBook:@"9787500789093" withOriginalPrice:@"30" currentPrice:@"25" inPromotion:@"Gb京东1"],
                    [[BookBaseInfo alloc] initBook:@"9780547238739" withOriginalPrice:@"30" currentPrice:@"25" inPromotion:@"Gb京东1"],
                    [[BookBaseInfo alloc] initBook:@"9780689853494" withOriginalPrice:@"30" currentPrice:@"25" inPromotion:@"Gb京东1"],
                    [[BookBaseInfo alloc] initBook:@"9787539770024" withOriginalPrice:@"30" currentPrice:@"25" inPromotion:@"Gb京东1"],
                    nil];
    [self.BookList addObjectsFromArray:List];
    [self fetchBookDetailInfo:List];
}

-(void)fetchBookDetailInfo:(NSArray*)baseInfoList
{
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    NSString *baseUrl = [NSMutableString stringWithString:@"https://api.douban.com/v2/book/isbn/:"];
    NSMutableDictionary *bookDetailList = [[NSMutableDictionary alloc] init];
    dispatch_group_t group = dispatch_group_create();

    
    for (id book in baseInfoList)
    {
        NSString *isbn = [book valueForKey:@"PromotionBookISBN"];
        NSString *url = [NSString stringWithFormat:@"%@%@",baseUrl,isbn];
        dispatch_group_enter(group);
        [appdele.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             BookDetailInfo *info = [[BookDetailInfo alloc] initBook:book withImages:[responseObject objectForKey:@"images"] title:[responseObject objectForKey:@"title"] publisher:[responseObject objectForKey:@"publisher"] pubdate:[responseObject objectForKey:@"pubdate"] pages:[responseObject objectForKey:@"pages"] author:[responseObject objectForKey:@"author"] summary:[responseObject objectForKey:@"summary"] author_intro:[responseObject objectForKey:@"author_intro"] rating:[responseObject objectForKey:@"rating"] catalog:[responseObject objectForKey:@"catalog"] tags:[responseObject objectForKey:@"tags"] doubanLink:[responseObject objectForKey:@"url"]];
             [bookDetailList setObject:info forKey:isbn];
             NSLog(@"dolown image for %@",info.title);
             dispatch_group_leave(group);
         }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"fail");
             dispatch_group_leave(group);
         }];
    }
    dispatch_group_notify(group,dispatch_get_main_queue(),^{
        // Won't get here until everything has finished
        NSLog(@"group notify");
        // 合并图片
        [self.BookDetailList addEntriesFromDictionary:bookDetailList];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    });
    

}

- (void)loadMoreData
{
    [self fetchMoreBook];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --内部函数
- (void) prepareProperty
{
    self.BookDetailList = [[NSMutableDictionary alloc] init];
    self.BookList = [[NSMutableArray alloc] init];
}

- (void) loadPromotionDetail
{
    self.BookList = [NSMutableArray arrayWithObjects:
                     [[BookBaseInfo alloc] initBook:@"9780316201643" withOriginalPrice:@"30" currentPrice:@"25" inPromotion:@"Gb京东1"],
                     [[BookBaseInfo alloc] initBook:@"9787543697485" withOriginalPrice:@"30" currentPrice:@"25" inPromotion:@"Gb京东1"],
                     [[BookBaseInfo alloc] initBook:@"9787506078221" withOriginalPrice:@"30" currentPrice:@"25" inPromotion:@"Gb京东1"],
                     [[BookBaseInfo alloc] initBook:@"9781409570202" withOriginalPrice:@"30" currentPrice:@"25" inPromotion:@"Gb京东1"],
                     [[BookBaseInfo alloc] initBook:@"9780375865312" withOriginalPrice:@"30" currentPrice:@"25" inPromotion:@"Gb京东1"],
                     [[BookBaseInfo alloc] initBook:@"9787500791362" withOriginalPrice:@"30" currentPrice:@"25" inPromotion:@"Gb京东1"],
                     [[BookBaseInfo alloc] initBook:@"9787533675950" withOriginalPrice:@"30" currentPrice:@"25" inPromotion:@"Gb京东1"],
                     nil];
    [self fetchBookDetailInfo:self.BookList];
}
- (void) LoadBookDetail
{
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    NSString *baseUrl = [NSMutableString stringWithString:@"https://api.douban.com/v2/book/isbn/:"];
    for (id book in self.BookList)
    {
        NSString *isbn = [book valueForKey:@"PromotionBookISBN"];
        NSString *url = [NSString stringWithFormat:@"%@%@",baseUrl,isbn];
        [appdele.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"seccess");
             
             BookDetailInfo *info = [[BookDetailInfo alloc] initBook:book withImages:[responseObject objectForKey:@"images"] title:[responseObject objectForKey:@"title"] publisher:[responseObject objectForKey:@"publisher"] pubdate:[responseObject objectForKey:@"pubdate"] pages:[responseObject objectForKey:@"pages"] author:[responseObject objectForKey:@"author"] summary:[responseObject objectForKey:@"summary"] author_intro:[responseObject objectForKey:@"author_intro"] rating:[responseObject objectForKey:@"rating"] catalog:[responseObject objectForKey:@"catalog"] tags:[responseObject objectForKey:@"tags"] doubanLink:[responseObject objectForKey:@"url"]];
             [self.BookDetailList setObject:info forKey:isbn];
             [self.tableView reloadData];
             
         }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"fail");
//             [self.tableView.mj_footer endRefreshing];
         }];
    }
   

    

}
#pragma mark -- talbeView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.BookDetailList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
(NSIndexPath *)indexPath
{
}



-(UITableViewCell *)tableView:tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *CellId = @"Cell1";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    
    static NSString *CellId = @"PromotionDetailCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellId];
    }
    
    NSString *isbn = [[self.BookList objectAtIndex:indexPath.row] valueForKey:@"PromotionBookISBN"];
    BookDetailInfo *info = [self.BookDetailList objectForKey:isbn];
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