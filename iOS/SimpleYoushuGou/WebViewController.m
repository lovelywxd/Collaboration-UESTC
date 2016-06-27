//
//  WebViewController.m
//  MyBookRecycle
//
//  Created by 苏丽荣 on 16/6/25.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "WebViewController.h"
#import "MBProgressHUD.h"
@interface WebViewController()<UIWebViewDelegate>
{
    UIActivityIndicatorView *activityIndicator;
    MBProgressHUD *hud;
}

@end

@implementation WebViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
//     self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [ self.webView setDelegate:self];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    [self.view addSubview:  self.webView];
    [ self.webView loadRequest:request];
    NSLog(@"at webView,url:%@",self.urlStr);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (void)  webViewDidStartLoad:(UIWebView *) webView
{
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.contentColor = [UIColor colorWithRed:0.f green:0.6f blue:0.7f alpha:1.f];
    
    // Set the label text.
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
}
- (void)  webViewDidFinishLoad:(UIWebView *) webView
{
    [hud hideAnimated:YES];
}
- (void)  webView:(UIWebView *) webView didFailLoadWithError:(NSError *)error
{
    [activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
    NSLog(@"didFailLoadWithError:%@", error);
}
@end
