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
#import "YouShuGou-Swift.h"
#import "EGOImageView.h"
#import "Header.h"


@interface HomeSearchDetailController ()<FaveButtonDelegate>
@property (nonatomic ,strong) NSMutableArray *PriceList;
@property (nonatomic, copy) NSString* bookISBN;
@property (nonatomic, copy) NSString* bookLowestPrice;
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
         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"服务器无响应" message:@"获取书籍信息失败" preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
         [alert addAction:defaultAction];
         [self presentViewController:alert animated:YES completion:nil];
     }];

}

#pragma mark -－公用解析函数
- (void)formPriceList:(NSArray*)arr {
    self.bookISBN = [arr[0] objectForKey:@"bookISBN"];
    if (arr.count) {
        CGFloat lowestPrice = [[arr[0] objectForKey:@"bookCurrentPrice"] floatValue];
        for (id item in arr) {
            
            NSString *tempName = [item objectForKey:@"bookSaler"];
//            NSRange range = [tempName rangeOfString:@"."];//获取$file/的位置
//            NSString *saler = [tempName substringToIndex:range.location];//开始截取
            NSString *price = [item objectForKey:@"bookCurrentPrice"];
            [self.PriceList addObject:[NSDictionary dictionaryWithObjectsAndKeys:tempName,@"bookSaler",price,@"bookCurrentPrice", nil]];
            CGFloat fPrice = [price floatValue];
            if (fPrice < lowestPrice) {
                lowestPrice = fPrice;
            }
            self.bookLowestPrice = [NSString stringWithFormat:@"%f",lowestPrice];
            [self.tableView reloadData];
        }
        
        
    }
    else {
        self.bookLowestPrice = @"";
    }
   
    
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 176;
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
            

            UIView *view = (UIView*)[cell viewWithTag:5];
            CGRect rect = view.frame;
            rect.size.width = rect.size.width - 3;
            rect.size.height = rect.size.height - 2;
            FaveButton *btn1 = [[FaveButton alloc] initWithFrame:rect faveIconNormal:[UIImage imageNamed:@"love"]];
            btn1.delegate = self;
            [self.view addSubview:btn1];
        }
            break;
            
        default:
        {
            static NSString *CellId = @"PriceCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellId forIndexPath:indexPath];
//            UIImageView *imgView = (UIImageView*)[cell viewWithTag:1];
            EGOImageView  *iView = (EGOImageView*)[cell viewWithTag:1];
            NSString *urlstr =  [[self.PriceList objectAtIndex:indexPath.row] objectForKey:@"bookSaler"];
            iView.imageURL = [NSURL URLWithString:urlstr];
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



- (void)collectBook {
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    NSString *url = [NSString stringWithFormat:@"%@/favourite/add/",appdele.baseUrl];
    
    [appdele.manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"userCookie"] forHTTPHeaderField:@"Cookie"];
    
   
    NSString *bookName = self.targetItem.bookName;
    NSString *bookImageLink = self.targetItem.bookImageLink;

    
    NSDictionary *oldDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"collectionDic"];
    NSMutableDictionary *newDic;
    if (oldDic) {
        newDic = [NSMutableDictionary dictionaryWithDictionary:oldDic];
        newDic[self.bookISBN] = bookImageLink;
    }
    else newDic= [NSMutableDictionary dictionaryWithObject:bookImageLink forKey:self.bookISBN];
    [[NSUserDefaults standardUserDefaults] setObject:newDic forKey:@"collectionDic"];
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:bookName,@"bookName",self.bookISBN,@"bookISBN",bookImageLink,@"bookImageLink",self.bookLowestPrice,@"bookLowestPrice",nil];
    
    [appdele.manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //         [hud hideAnimated:YES];
         NSString *status = [responseObject objectForKey:@"status"];
         if ([status isEqualToString:@"0"]) {
//             UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"收藏" message:@"收藏成功" preferredStyle:UIAlertControllerStyleAlert];
//             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//             }];
//             [alert addAction:defaultAction];
//             [self presentViewController:alert animated:YES completion:nil];
             
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


#pragma mark - FaveButtonDelegate
- (void)faveButton:(FaveButton *)faveButton didSelected:(BOOL)selected {
    if (faveButton.isSelected) {
        [self collectBook];
    }
    else
        NSLog(@"deSelect");
    
}

- (NSArray*)objc_faveButtonDotColors:(FaveButton *)faveButton {
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    
    UIColor *first_color = getColor(0x7DC2F4);
    UIColor *second_color = getColor(0xE2264D);
    [colors addObject:[NSArray arrayWithObjects:first_color,second_color, nil]];
    
    first_color = getColor(0xF8CC61);
    second_color = getColor(0x9BDFBA);
    [colors addObject:[NSArray arrayWithObjects:first_color,second_color, nil]];
    
    first_color = getColor(0xAF90F4);
    second_color = getColor(0x90D1F9);
    [colors addObject:[NSArray arrayWithObjects:first_color,second_color, nil]];
    
    first_color = getColor(0xE9A966);
    second_color = getColor(0xF8C852);
    [colors addObject:[NSArray arrayWithObjects:first_color,second_color, nil]];
    
    first_color = getColor(0xF68FA7);
    second_color = getColor(0xF6A2B8);
    [colors addObject:[NSArray arrayWithObjects:first_color,second_color, nil]];
    
    if (1) {
        return colors;
    }
    return nil;
}


@end
