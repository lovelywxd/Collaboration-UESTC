//
//  BookDetailViewController.m
//  MyBookRecycle
//
//  Created by 苏丽荣 on 16/6/27.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "BookDetailViewController.h"
#import "BookDetailCell.h"

@interface BookDetailViewController ()<EGOImageButtonDelegate>

@end

@implementation BookDetailViewController
BookDetailInfo *detailInfoInBookDetailViewController;
- (void)viewDidLoad {
    [super viewDidLoad];
    BookBaseInfo* baseInfo = [[BookBaseInfo alloc] initBook:@"9780316201643" withOriginalPrice:@"30" currentPrice:@"25" inPromotion:@"Gb京东1"];
    NSDictionary *images = [NSDictionary dictionaryWithObjectsAndKeys:
    @"https://img3.doubanio.com/lpic/s27110875.jpg",@"large",
    @"https://img3.doubanio.com/mpic/s27110875.jpg",@"medium",
                            @"https://https://img3.doubanio.com/spic/s27110875.jpg",@"small",nil];
    NSArray *authors = [NSArray arrayWithObjects:@"Doug Dorst",@"J.J. Abrams", nil];
    NSDictionary *rate = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"9.4",@"max",
                            @"9.4",@"min",
                            @"537",@"numRaters",nil];
//    BookDetailInfo *detailInfo = [[BookDetailInfo alloc] initBook:baseInfo withImages:images title:@"S." publisher:@"Mulholland Books" pubdate:@"2013-10-29" pages:@"472" author:authors summary:@"One book. Two readers. A world of mystery, menace, and desire.A young woman picks up a book left behind by a stranger. Inside it are his margin notes, which reveal a reader entranced by the story and by its mysterious author. She responds with notes of her own, leaving the book for the stranger, and so begins an unlikely conversation that plunges them both into the unknown.The book: Ship of Theseus, the final novel by a prolific but enigmatic writer named V.M. Straka, in which a man with no past is shanghaied onto a strange ship with a monstrous crew and launched onto a disorienting and perilous journey.The writer: Straka, the incendiary and secretive subject of one of the world's greatest mysteries, a revolutionary about whom the world knows nothing apart from the words he wrote and the rumors that swirl around him.The readers: Jennifer and Eric, a college senior and a disgraced grad student, both facing crucial decisions about who they are, who they might become, and how much they're willing to trust another person with their passions, hurts, and fears.S., conceived by filmmaker J. J. Abrams and written by award-winning novelist Doug Dorst, is the chronicle of two readers finding each other in the margins of a book and enmeshing themselves in a deadly struggle between forces they don't understand, and it is also Abrams and Dorst's love letter to the written word." author_intro:@"J.J. Abrams is the multiple Emmy Award-winning producer, writer, and director of Lost, Star Trek, Alias, The Fringe, Cloverfield, Armageddon, Super 8, and more. This is his debut novel.Doug Dorst teaches creative writing at Texas State University-San Marcos. His work has appeared in McSweeney's, Ploughshares, Epoch, and other journals, as well as in the anthology Politically Inspired. He is also a former Jeopardy champion." rating:rate catalog:@"" tags:nil doubanLink:@"https://api.douban.com/v2/book/24538213"];
    
    BookDetailInfo *detailInfo = [[BookDetailInfo alloc] initBook:baseInfo withImages:images title:@"S." publisher:@"Mulholland Books" pubdate:@"2013-10-29" pages:@"472" author:authors summary:@"One book. Two readers. A world of mystery, menace, and desire.A young woman picks up a book left behind by a stranger. Inside it are his margin notes, which reveal a reader entranced by the story and by its mysterious author. She responds with notes of her own, leaving the book for the stranger, and so begins an unlikely conversation that plunges them both into the unknown.The book: Ship of Theseus, the final novel by a prolific but enigmatic writer named V.M. Straka, in which a man with no past is shanghaied onto a strange ship with a monstrous crew and launched onto a disorienting and perilous journey.The writer: Straka, the incendiary and secretive subject of one of the world's greatest mysteries, a revolutionary about whom the world knows nothing apart from the words he wrote and the rumors that swirl around him.The readers: Jennifer and Eric, a college senior and a disgraced grad student, both facing crucial decisions about who they are, who they might become, and how much they're willing to trust another person with their passions, hurts, and fears.S., conceived by filmmaker J. J. Abrams and written by award-winning novelist Doug Dorst, is the chronicle of two readers finding each other in the margins of a book and enmeshing themselves in a deadly struggle between forces they don't understand, and it is also Abrams and Dorst's love letter to the written word." author_intro:@"J.J. Abrams is the multiple Emmy Award-winning producer, writer, and director of Lost, Star Trek, Alias, The Fringe, Cloverfield, Armageddon, Super 8, and more. This is his debut novel.Doug Dorst teaches creative writing at Texas State University-San Marcos. His work has appeared in McSweeney's, Ploughshares, Epoch, and other journals, as well as in the anthology Politically Inspired. He is also a former Jeopardy champion." rating:rate catalog:@"天\n神\n鬼\n日\n旦\n早\n旭\n暮\n明\n月\n星\n云\n雷\n电\n气\n风\n晕\n水\n雨\n霖\n雪\n冰\n寒\n泉\n永\n派\n汁\n泡\n火\n赤\n烟\n焦\n灰\n焚\n灾\n山\n石\n沙\n土\n尘\n玉\n贝\n川\n州\n谷\n崖\n峡\n岛\n穴\n白\n黑\n青\n黄\n丹\n春\n夏\n秋\n冬\n东\n西\n南\n北\n中国文字的演变" tags:nil doubanLink:@"https://api.douban.com/v2/book/24538213"];
    detailInfo = self.bookdetailInfo;
    detailInfoInBookDetailViewController = detailInfo;
    self.bookNameLabel.text = detailInfo.title;
    NSArray * author_array = detailInfo.author;
    NSMutableString *bookAuthors;
    if (author_array.count) {
        bookAuthors = [[NSMutableString alloc] initWithString:[author_array objectAtIndex:0]];
        for (int i = 1; i < author_array.count; ++ i) {
            [bookAuthors appendString:[NSString stringWithFormat:@",%@",[author_array objectAtIndex:i]]];
        }
        
    }
    self.bookAuthorLabel.text = bookAuthors;
    self.publisherLabel.text = detailInfo.publisher;
    self.pubDateLabel.text = detailInfo.pubdate;
    self.rateLabel.text = [NSString stringWithFormat:@"%@",[detailInfo.rating objectForKey:@"average"]];
    NSNumber *aver_score = [detailInfo.rating objectForKey:@"numRaters"];
     NSMutableString* numRaters = [NSMutableString stringWithFormat:@"%@人评价",aver_score];
    self.numRatersLabel.text = numRaters;
    [self.bookCoverBtn setPlaceholderImage:[UIImage imageNamed:@"home"]];
    NSString *tmpURl = [detailInfo.images valueForKey:@"large"];
    [self.bookCoverBtn setImageURL:[NSURL URLWithString:tmpURl]];
    [self imageButtonLoadedImage:self.bookCoverBtn];
    self.originalPrice.text = detailInfo.baseInfo.PromotionBookPrice;
    self.currentPrice.text = detailInfo.baseInfo.PromotionBookCurrentPrice;
    self.discount.text = @"75";
//    self.tableView.backgroundColor = [UIColor yellowColor];
    self.summaryText.superview.backgroundColor = [UIColor yellowColor];

    self.summaryText.superview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bookDetailTvBg"]];
    
//    bookDetailTvBg@2x
    self.summaryText.text = detailInfo.summary;
}
- (void)imageButtonLoadedImage:(EGOImageButton*)imageButton
{
    NSLog(@"imageButtonLoadedImage");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 6;
//}


//- (BookDetailCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//        BOOL nibsRegistered=NO;
//    static NSString *cellID = @"BookDetailCell";
//        if (!nibsRegistered) {
//            UINib *nib=[UINib nibWithNibName:@"BookDetailCell" bundle:nil];
//            [tableView registerNib:nib forCellReuseIdentifier:cellID];
//            nibsRegistered=YES;
//        }
//    BookDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
//    return cell;
    
//}


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
             self.summaryText.text = detailInfoInBookDetailViewController.summary;
            break;
        case 1:
            self.summaryText.text = detailInfoInBookDetailViewController.author_intro;
            break;
        case 2:
            self.summaryText.text = detailInfoInBookDetailViewController.catalog;
            break;

    }
}
@end
