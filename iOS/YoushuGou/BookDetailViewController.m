//
//  BookDetailViewController.m
//  MyBookRecycle
//
//  Created by 苏丽荣 on 16/6/27.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "BookDetailViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "PriceComparisonItem.h"
#import "PriceComparisonViewController.h"


@interface BookDetailViewController ()<EGOImageButtonDelegate>
{
//    MBProgressHUD *hud;
    MBProgressHUD *addToCarthud;
//    MBProgressHUD *getPriceListHud;
}
@property (nonatomic ,copy) BookDetailInfo *bookDetailInfo;
@end

@implementation BookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self LoadBookDetail];
}

- (void)imageButtonLoadedImage:(EGOImageButton*)imageButton
{
    NSLog(@"imageButtonLoadedImage");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BookDetail相关
- (void)LoadBookDetail {
//    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//    hud.contentColor = [UIColor colorWithRed:0.f green:0.6f blue:0.7f alpha:1.f];
//    
//    // Set the label text.
//    hud.label.text = NSLocalizedString(@"加载书籍列表...", @"HUD loading title");
    
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    if (appdele.OnLineTest) {
        [self loadBookDetailInfo:self.bookBaseInfo];
    }
    else {
        [self loadBookDetailInfoLocally:self.bookBaseInfo];
    }

}
#pragma mark --从本地文件获取BookDetailInfoList
//返回NSDictionary表示的书籍所有详细信息列表
-(void)loadBookDetailInfoLocally:(BookBaseInfo*)baseInfo {
    NSString* jsonPath = [[NSBundle mainBundle] pathForResource:@"bookDetail2"
                                                         ofType:@"json"];
    // 读取jsonPath对应文件的数据
    NSData* data = [NSData dataWithContentsOfFile:jsonPath];
    // 调用JSONKit为NSData扩展的objectFromJSONData方法解析JSON数据
    NSDictionary *parseResult = [NSJSONSerialization JSONObjectWithData:data
                                                                options:0 error:nil];
    [self formBookDetailInfo:parseResult];
    
}

#pragma mark --从服务器获取BookDetail
-(void)loadBookDetailInfo:(BookBaseInfo*)baseInfo
{
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    NSString *baseUrl = [NSMutableString stringWithString:@"https://api.douban.com/v2/book/isbn/:"];
    NSString *isbn = baseInfo.PromotionBookISBN;
    NSString *url = [NSString stringWithFormat:@"%@%@",baseUrl,isbn];
    [appdele.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self formBookDetailInfo:responseObject];

     }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"fetch bookdetail fail");
         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"服务器5⃣️响应" message:@"获取书籍失败" preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
         [alert addAction:defaultAction];
         [self presentViewController:alert animated:YES completion:nil];
     }];
}
#pragma mark --公用解析函数，根据dictionary，解析声称BookDetailInfo并赋给self.bookDetailInfo
- (void)formBookDetailInfo:(NSDictionary*)detailInfoDic {
    BookBaseInfo *book = self.bookBaseInfo;
    BookDetailInfo *info = [[BookDetailInfo alloc] initBook:book withImages:[detailInfoDic objectForKey:@"images"] title:[detailInfoDic objectForKey:@"title"] publisher:[detailInfoDic objectForKey:@"publisher"] pubdate:[detailInfoDic objectForKey:@"pubdate"] pages:[detailInfoDic objectForKey:@"pages"] author:[detailInfoDic objectForKey:@"author"] summary:[detailInfoDic objectForKey:@"summary"] author_intro:[detailInfoDic objectForKey:@"author_intro"] rating:[detailInfoDic objectForKey:@"rating"] catalog:[detailInfoDic objectForKey:@"catalog"] tags:[detailInfoDic objectForKey:@"tags"] doubanLink:[detailInfoDic objectForKey:@"url"]];
    self.bookDetailInfo = info;
//    [hud hideAnimated:YES];
    [self fillContent];
}
#pragma mark - 按钮响应

- (IBAction)GoDouBan:(id)sender {
    NSLog(@"clcked");
}

- (IBAction)getPriceComparison:(id)sender {
    
//    getPriceListHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//    getPriceListHud.contentColor = [UIColor colorWithRed:0.f green:0.6f blue:0.7f alpha:1.f];
//    getPriceListHud.label.text = NSLocalizedString(@"获取价格表", @"HUD loading title");
    
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    if (appdele.OnLineTest) {
        [self getPriceComparisonList];
    }
    else {
        [self getPriceComparisonListLocally];
    }
}

- (IBAction)changeTextContent:(id)sender {
    switch ([sender selectedSegmentIndex]) {
        case 0:
            self.summaryText.text = self.bookDetailInfo.summary;
            break;
        case 1:
            self.summaryText.text = self.bookDetailInfo.author_intro;
            break;
        case 2:
            self.summaryText.text = self.bookDetailInfo.catalog;
            break;
    }
}

- (IBAction)collect:(id)sender {

    
//    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//    hud.contentColor = [UIColor colorWithRed:0.f green:0.6f blue:0.7f alpha:1.f];
//    hud.label.text = NSLocalizedString(@"收藏中", @"HUD loading title");
    
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    NSString *url = [NSString stringWithFormat:@"%@/favourite/add/",appdele.baseUrl];
    
    [appdele.manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"userCookie"] forHTTPHeaderField:@"Cookie"];
    NSString *isbn = self.bookBaseInfo.PromotionBookISBN;
    NSString *bookName = self.bookBaseInfo.promotionBookName;
    NSString *bookImageLink = self.bookBaseInfo.promotionBookImageLink;
    
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.bookName,@"bookName",self.bookIsbn,@"bookISBN",self.bookImageLink,@"bookImageLink",self.bookLowestPrice,@"bookLowestPrice",nil];
    
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:bookName,@"bookName",isbn,@"ISBN",bookImageLink,@"bookImageLink",nil];
 
    [appdele.manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
//         [hud hideAnimated:YES];
         NSString *status = [responseObject objectForKey:@"status"];
         if ([status isEqualToString:@"0"]) {
             UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"收藏" message:@"收藏成功" preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
             }];
             [alert addAction:defaultAction];
             [self presentViewController:alert animated:YES completion:nil];
             
         }
         else {
             NSString *result = [NSString stringWithFormat:@"收藏失败.info:%@",[responseObject objectForKey:@"data"]];
             UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"收藏" message:result preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
             }];
             [alert addAction:defaultAction];
             [self presentViewController:alert animated:YES completion:nil];
         }
     }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
//         [hud hideAnimated:YES];
         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"服务器无响应" message:@"收藏失败" preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
         [alert addAction:defaultAction];
         [self presentViewController:alert animated:YES completion:nil];
         
     }];
}


- (IBAction)addToCart:(id)sender {
    
    addToCarthud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    addToCarthud.contentColor = [UIColor colorWithRed:0.f green:0.6f blue:0.7f alpha:1.f];
    addToCarthud.label.text = NSLocalizedString(@"添加到购物车", @"HUD loading title");
    
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    NSString *url = [NSString stringWithFormat:@"%@/shopping/add/",appdele.baseUrl];
    [appdele.manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"userCookie"] forHTTPHeaderField:@"Cookie"];
    NSString *promotionID = self.promotionID;
    NSString *bookISBN = self.bookBaseInfo.PromotionBookISBN;
//    NSString *bookAmount = @"1";
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:promotionID,@"promotionID",bookISBN,@"bookISBN",nil];
// NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:promotionID,@"promotionID",bookISBN,@"bookISBN",bookAmount,@"bookAmount",nil];
    [appdele.manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [addToCarthud hideAnimated:YES];
         NSString *status = [responseObject objectForKey:@"status"];
         if ([status isEqualToString:@"0"]) {
             UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"添加到购物车" message:@"添加成功" preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
             }];
             [alert addAction:defaultAction];
             [self presentViewController:alert animated:YES completion:nil];
             
         }
         else {
             NSString *result = [NSString stringWithFormat:@"添加失败.info:%@",[responseObject objectForKey:@"data"]];
             UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"添加到购物车" message:result preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
             }];
             [alert addAction:defaultAction];
             [self presentViewController:alert animated:YES completion:nil];
         }
     }
      failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         [addToCarthud hideAnimated:YES];
         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"服务器无响应" message:@"添加到购物车失败" preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
         [alert addAction:defaultAction];
         [self presentViewController:alert animated:YES completion:nil];
         
     }];
}

#pragma mark -view相关
- (void)fillContent {
    self.bookNameLabel.text = self.bookDetailInfo.title;
    NSArray * author_array = self.bookDetailInfo.author;
    NSMutableString *bookAuthors;
    if (author_array.count) {
        bookAuthors = [[NSMutableString alloc] initWithString:[author_array objectAtIndex:0]];
        for (int i = 1; i < author_array.count; ++ i) {
            [bookAuthors appendString:[NSString stringWithFormat:@",%@",[author_array objectAtIndex:i]]];
        }
        
    }
    self.bookAuthorLabel.text = bookAuthors;
    self.publisherLabel.text = self.bookDetailInfo.publisher;
    self.pubDateLabel.text = self.bookDetailInfo.pubdate;
    self.rateLabel.text = [NSString stringWithFormat:@"%@",[self.bookDetailInfo.rating objectForKey:@"average"]];
    NSNumber *aver_score = [self.bookDetailInfo.rating objectForKey:@"numRaters"];
    NSMutableString* numRaters = [NSMutableString stringWithFormat:@"%@人评价",aver_score];
    self.numRatersLabel.text = numRaters;
    [self.bookCoverBtn setPlaceholderImage:[UIImage imageNamed:@"home"]];
    NSString *tmpURl = [self.bookDetailInfo.images valueForKey:@"large"];
    [self.bookCoverBtn setImageURL:[NSURL URLWithString:tmpURl]];
    [self imageButtonLoadedImage:self.bookCoverBtn];
    self.originalPrice.text = self.bookDetailInfo.baseInfo.PromotionBookCurrentPrice;
//    self.currentPrice.text = self.bookDetailInfo.baseInfo.PromotionBookCurrentPrice;
    self.discount.text = @"75";
    
    
    if (!self.IsGroupBuy) {
        self.addToCartBtn.hidden = YES;
    }
    
    self.summaryText.text = self.bookDetailInfo.summary;
}

#pragma mark - 获取PriceComparisonList 相关
- (void)getPriceComparisonList {
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    NSString *url = [NSString stringWithFormat:@"%@/book/price/list/",appdele.baseUrl];
    NSString *isbn = self.bookBaseInfo.PromotionBookISBN;
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:isbn,@"ISBN",nil];
    
    [appdele.manager GET:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSArray *priceList = [responseObject objectForKey:@"priceList"];
         if (priceList.count) {
             [self formPriceList:priceList];
         }
         else {
             UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"糟了" message:@"暂时没有相关价格表" preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
             [alert addAction:defaultAction];
             [self presentViewController:alert animated:YES completion:nil];
//             NSLog(@"No data");
         }
         
         
     }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
//         [getPriceListHud hideAnimated:YES];
         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"服务器无响应" message:@"无法获取价格表" preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
         [alert addAction:defaultAction];
         [self presentViewController:alert animated:YES completion:nil];
         
     }];

}

- (void)getPriceComparisonListLocally {
    NSString* jsonPath = [[NSBundle mainBundle] pathForResource:@"promotionSearchDetail"
                                                         ofType:@"json"];
    // 读取jsonPath对应文件的数据
    NSData* data = [NSData dataWithContentsOfFile:jsonPath];
    // 调用JSONKit为NSData扩展的objectFromJSONData方法解析JSON数据
    NSArray *parseResult = [NSJSONSerialization JSONObjectWithData:data
                                                           options:0 error:nil];
    [self formPriceList:parseResult];
}

- (void)formPriceList:(NSArray*)arr {
//    [getPriceListHud hideAnimated:YES];
    NSMutableArray *priceList = [[NSMutableArray alloc] init];
    for (id item in arr) {
        PriceComparisonItem *priceitem = [[PriceComparisonItem alloc] initSaler:[item objectForKey:@"bookSaler"] withPrice:[item objectForKey:@"bookCurrentPrice"] link:[item objectForKey:@"bookLink"]];
        [priceList addObject:priceitem];
        
    }
    //数据加载完以后切换页面
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    PriceComparisonViewController *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"PriceComparisonViewController"];
    detailVC.PriceList = [priceList copy];
    detailVC.bookIsbn = self.bookIsbn;
    detailVC.bookImageLink = self.bookBaseInfo.promotionBookImageLink;
    detailVC.bookName = self.bookBaseInfo.promotionBookName;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}


@end
