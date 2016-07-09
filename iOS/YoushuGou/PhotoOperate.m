//
//  PhotoOperate.m
//  UploadPhotoDemo
//
//  Created by crab on 15-3-20.
//  Copyright (c) 2015年 shawn. All rights reserved.
//
#import "PhotoOperate.h"
#import <UIKit/UIKit.h>
#import <CoreGraphics/CGImage.h>
#import "AFHTTPRequestOperation.h"

static PhotoOperate* mPhotoOperate = nil;
@implementation PhotoOperate
/*
 *  单例模式
 */
+ (id) sharedPhotoOperate{
    @synchronized(self){
        if(nil == mPhotoOperate){
            mPhotoOperate = [[self alloc] init];
        }
    }
    return mPhotoOperate;
}
/*
 *  截图并且保存
 */
- (BOOL) screenshotAndSavePath:(NSString *) fileFullPath{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(640, 960), YES, 0);
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContext(window.frame.size);
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRef imageRef = viewImage.CGImage;
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
    //保存为png格式
    //    NSData *imageViewData = UIImagePNGRepresentation(sendImage);
    //保存为jpeg格式(此种格式可以压缩)
    NSData *imageViewData = UIImageJPEGRepresentation(sendImage,1.0);
    //保存截图文件到/Document/CrabScreenshot目录,文件名用时间，避免覆盖
    BOOL ret = [imageViewData writeToFile:fileFullPath atomically:YES];
    CGImageRelease(imageRefRect);
    return ret;
}

/*
 *  上传图片到服务器
 */
//- (BOOL) uploadPhotoWithDomain:(NSString *) domain URI:(NSString *) uri fileFullPath:(NSString *) fileFullPath target:(id<HTTPRequestFinishedDelegate>) target{
//    
//    UIImage* image = [UIImage imageWithContentsOfFile:fileFullPath];
//    NSData* data = UIImageJPEGRepresentation(image, 1.0);
//    
//    NSURL *nsurl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",domain]];
//    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:nsurl];
//    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:uri parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:data name:@"screenshot" fileName:@"screenshot.jpg" mimeType:@"image/jpeg"];
//    }];
//    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Success!");
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"failure!");
//    }];
//    [operation start];
//    return YES;
//}

/*
 *  从服务器下载图片并存入指定路径
 */
//- (BOOL) downloadPhotoWithDomain:(NSString *) domain URI:(NSString *) uri fileFullPath:(NSString *) fileFullPath target:(id<HTTPRequestFinishedDelegate>) target{
//    NSURL* baseURL = [NSURL URLWithString:domain];
////    NSURL* nsurl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",domain,uri]];
////    NSURLRequest* request = [NSURLRequest requestWithURL:nsurl];
//    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
//    NSMutableURLRequest* request = [httpClient multipartFormRequestWithMethod:@"GET" path:uri parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//    }];
//    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
////    [operation setInputStream:[NSInputStream inputStreamWithURL:nsurl]];
//    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:fileFullPath append:NO]];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary* dicionary = [NSDictionary dictionaryWithObject:fileFullPath forKey:@"photo"];
//        [target requestFinished:dicionary tag:1];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Failure");
//    }];
//    [operation start];
//    return YES;
//}
/*
 *  从服务器下载图片并存入指定路径(URL方式)
 */
- (BOOL) downloadPhotoWithURL:(NSString *) url fileFullPath:(NSString *) fileFullPath target:(id<HTTPRequestFinishedDelegate>) target{
    NSURL* nsurl = [NSURL URLWithString:url];
    NSURLRequest* request = [NSURLRequest requestWithURL:nsurl];
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    [operation setInputStream:[NSInputStream inputStreamWithURL:nsurl]];
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:fileFullPath append:NO]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dicionary = [NSDictionary dictionaryWithObject:fileFullPath forKey:@"photo"];
        [target requestFinished:dicionary tag:1];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure,error:%@",error);
    }];
    [operation start];
    return YES;

}

/*
 *  在Document目录下创建一个子目录,创建成功则返回目录的路径，失败返回nil
 */
- (NSString *) createDirectoryOnDocumentWithSubDirectory:(NSString *)subDir{
    //在~/Document目录下创建一个子目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *screenshotDirectory = [documentsDirectory stringByAppendingPathComponent:subDir];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    if (![fm createDirectoryAtPath: screenshotDirectory withIntermediateDirectories: YES attributes:nil error: &error]) {
        //如果创建目录失败则直接returns
        return nil;
    }
    return screenshotDirectory;
}

/*
 *  传入子目录名字和文件名，生成一个文件的全路径,成功返回全路径，失败则返回nil
 */
- (NSString *)productFileFullPathWithSubDirectory:(NSString *)subDir fileName:(NSString *) fileName{
    NSString* screenshotDirectory = [self createDirectoryOnDocumentWithSubDirectory:subDir];
    if (nil == screenshotDirectory) {
        return nil;
    }
    NSString *fileFullPath = [screenshotDirectory stringByAppendingPathComponent:fileName];
    return fileFullPath;
}

@end
