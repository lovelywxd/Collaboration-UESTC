//
//  WebViewController.m
//  MyBookRecycle
//
//  Created by 苏丽荣 on 16/6/25.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "WebViewController.h"
@interface WebViewController()<UIWebViewDelegate>
{
    UIActivityIndicatorView *activityIndicator;
}

@end

@implementation WebViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
     self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [ self.webView setDelegate:self];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    [self.view addSubview:  self.webView];
    [ self.webView loadRequest:request];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (void)  webViewDidStartLoad:(UIWebView *) webView
{
    //创建UIActivityIndicatorView背底半透明View
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [view setTag:108];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.5];
    [self.view addSubview:view];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [activityIndicator setCenter:view.center];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [view addSubview:activityIndicator];
    
    [activityIndicator startAnimating];
    NSLog(@" self.webViewDidStartLoad");
}
- (void)  webViewDidFinishLoad:(UIWebView *) webView
{
    [activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
    NSLog(@" self.webViewDidFinishLoad");
    
}
- (void)  webView:(UIWebView *) webView didFailLoadWithError:(NSError *)error
{
    [activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
    NSLog(@"didFailLoadWithError:%@", error);
}
@end
