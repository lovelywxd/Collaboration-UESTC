//
//  BookDetailViewController.m
//  MyBookRecycle
//
//  Created by 苏丽荣 on 16/6/27.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "BookDetailViewController.h"
#import "BookDetailCell.h"
#import "AppDelegate.h"

@interface BookDetailViewController ()<EGOImageButtonDelegate>
@property (nonatomic ,copy) BookDetailInfo *bookDetailInfo;
@end

@implementation BookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBookDetailInfo:self.bookBaseInfo];
}

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
    self.originalPrice.text = self.bookDetailInfo.baseInfo.PromotionBookPrice;
    self.currentPrice.text = self.bookDetailInfo.baseInfo.PromotionBookCurrentPrice;
    self.discount.text = @"75";
    self.summaryText.superview.backgroundColor = [UIColor yellowColor];
    
    self.summaryText.superview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bookDetailTvBg"]];
    
    //    bookDetailTvBg@2x
    self.summaryText.text = self.bookDetailInfo.summary;
}

- (void)imageButtonLoadedImage:(EGOImageButton*)imageButton
{
    NSLog(@"imageButtonLoadedImage");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
         [self fillContent];
//         [self.view ]
     }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"fetch bookdetail fail");
     }];

//    [self.tableView.mj_footer endRefreshing];
}

- (void)formBookDetailInfo:(NSDictionary*)detailInfoDic {
    BookBaseInfo *book = self.bookBaseInfo;
    BookDetailInfo *info = [[BookDetailInfo alloc] initBook:book withImages:[detailInfoDic objectForKey:@"images"] title:[detailInfoDic objectForKey:@"title"] publisher:[detailInfoDic objectForKey:@"publisher"] pubdate:[detailInfoDic objectForKey:@"pubdate"] pages:[detailInfoDic objectForKey:@"pages"] author:[detailInfoDic objectForKey:@"author"] summary:[detailInfoDic objectForKey:@"summary"] author_intro:[detailInfoDic objectForKey:@"author_intro"] rating:[detailInfoDic objectForKey:@"rating"] catalog:[detailInfoDic objectForKey:@"catalog"] tags:[detailInfoDic objectForKey:@"tags"] doubanLink:[detailInfoDic objectForKey:@"url"]];
    self.bookDetailInfo = info;
}


- (IBAction)GoDouBan:(id)sender {
    NSLog(@"clcked");
}
- (IBAction)getPriceComparison:(id)sender {
}
- (IBAction)seeDouBanComment:(id)sender {
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
@end
