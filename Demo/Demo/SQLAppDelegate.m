//
//  SQLAppDelegate.m
//  Demo
//
//  Created by jiajun on 3/18/13.
//  Copyright (c) 2013 com.gaosboy.sqlight.demo. All rights reserved.
//

#import "SQLAppDelegate.h"

#import "Sqlite.h"

@implementation SQLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    static SqlightAdapter *sqlight = nil;
    if (nil == sqlight) {
        NSString *tbName = @"DemoTb";
        sqlight = [[SqlightAdapter alloc] initWithDatabase:@"DemoDb" AndTable:tbName];
        if (nil == sqlight) {
            sqlight = [[SqlightAdapter alloc] initWithDatabase:@"DemoDb"];
            
            [sqlight createTable:tbName Info:[NSMutableArray arrayWithObjects:
                                              @"id INTEGER PRIMARY KEY ASC",
                                              @"type INTEGER",
                                              @"style INTEGER",
                                              @"content",
                                              @"created INTEGER",
                                              nil]];
            
            sqlight.tableName = tbName;
        }
    }
    
    SqlightResult *result = [sqlight insertData:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 @"1",                  @"type",
                                                 @"2",                  @"style",
                                                 @"This is a Demo.",    @"content",
                                                 nil]];
    
    NSLog(@"Insert Result msg:%@ code:%d data:%@", result.msg, result.code, result.data);
    
    SqlightResult *queryResult = [sqlight selectFields:[NSArray arrayWithObjects:@"id", @"type", @"style", @"content", nil]
                                           ByCondition:@""
                                                  Bind:nil];
    
    NSLog(@"Query Result msg:%@ code:%d data:%@", queryResult.msg, queryResult.code, queryResult.data);
    
    SqlightResult *updateResult = [sqlight updateData:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       @"1",                  @"type",
                                                       @"20",                 @"style",
                                                       @"This is a Demo.",    @"content",
                                                       nil]
                                          ByCondition:@"type=?"
                                                 Bind:[NSArray arrayWithObjects:@"1", nil]];
    
    NSLog(@"Update Result msg:%@ code:%d data:%@", updateResult.msg, updateResult.code, updateResult.data);
    
    queryResult = [sqlight selectFields:[NSArray arrayWithObjects:@"id", @"type", @"style", @"content", nil]
                                           ByCondition:@""
                                                  Bind:nil];
    
    NSLog(@"Query Result msg:%@ code:%d data:%@", queryResult.msg, queryResult.code, queryResult.data);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
