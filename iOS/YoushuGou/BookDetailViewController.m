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
       BookDetailInfo *detailInfo = self.bookdetailInfo;
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
