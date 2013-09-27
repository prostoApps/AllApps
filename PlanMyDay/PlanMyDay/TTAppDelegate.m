//
//  TTAppDelegate.m
//  PlanMyDay
//
//  Created by Yegor Karpechenkov on 7/3/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import "TTAppDelegate.h"

@implementation TTAppDelegate

@synthesize window = _window;
@synthesize menuController = _menuController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    

    
    TTMainClockViewController *mainController = [[TTMainClockViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainController];
    
    
    DDMenuController * rootController = [[DDMenuController alloc] initWithRootViewController:navController];
    _menuController = rootController;
    
    TTMenuViewController *leftController = [[TTMenuViewController alloc] init];
    rootController.leftViewController = leftController;

    [self.window setRootViewController:_menuController];
    [self.window makeKeyAndVisible];
    
    
  // UINavigationBar
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
    UIImage *portraitImage = [UIImage imageNamed:@"bgUiBar.png"];
    [[UINavigationBar appearance] setBackgroundImage:portraitImage forBarMetrics:UIBarMetricsDefault];
    //[navController.navigationBar setBackgroundColor:[[TTAppDataManager sharedAppDataManager] colorWithHexString:@"ffffff"]];
  //  [[UIApplication sharedApplication] set:YES];
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
