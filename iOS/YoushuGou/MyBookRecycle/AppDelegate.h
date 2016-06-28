//
//  AppDelegate.h
//  MyBookRecycle
//
//  Created by 苏丽荣 on 16/5/9.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AFHTTPRequestOperationManager.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) AFHTTPRequestOperationManager* manager;
@property (nonatomic,assign) BOOL OnLineTest;
@property (nonatomic,copy) NSDictionary* shopList;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

