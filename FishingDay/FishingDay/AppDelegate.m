//
//  AppDelegate.m
//  FishingDay
//
//  Created by Hanna Rybakova on 7/13/19.
//  Copyright © 2019 None. All rights reserved.
//

#import "AppDelegate.h"
#import "MapViewController.h"
#import "FishListViewController.h"
#import "MarksListViewController.h"
#import "WheatherViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    // Create your various view controllers
    UIViewController *wheatherVC= [[WheatherViewController alloc] init];
    UIViewController *marksVC = [[MarksListViewController alloc] init];
    UIViewController *mapVC = [[MapViewController alloc] init];
    UIViewController *fishListVC = [[FishListViewController alloc] init];
    
    UINavigationController* wheatherNC = [[UINavigationController alloc] initWithRootViewController:wheatherVC];
    wheatherNC.navigationBar.hidden = YES;
    UINavigationController* marksNC = [[UINavigationController alloc] initWithRootViewController:marksVC];
    marksNC.navigationBar.hidden = YES;
    UINavigationController* mapNC = [[UINavigationController alloc] initWithRootViewController:mapVC];
    mapNC.navigationBar.hidden = YES;
    UINavigationController* fishListNC = [[UINavigationController alloc] initWithRootViewController:fishListVC];
    fishListNC.navigationBar.hidden = YES;
    
    UITabBarItem *itemMarks = [[UITabBarItem alloc] initWithTitle:@"Список мест" image:[UIImage imageNamed:@"fishing_pole"] tag:0];
    UITabBarItem *itemMap = [[UITabBarItem alloc] initWithTitle:@"Места на карте" image:[UIImage imageNamed:@"map"] tag:1];
    UITabBarItem *itemWeather = [[UITabBarItem alloc] initWithTitle:@"Прогноз" image:[UIImage imageNamed:@"rainy_weather"] tag:2];
    UITabBarItem *itemFishList = [[UITabBarItem alloc] initWithTitle:@"Виды рыб" image:[UIImage imageNamed:@"fish_food"] tag:3];
    
    fishListNC.tabBarItem = itemFishList;
    mapNC.tabBarItem = itemMap;
    wheatherNC.tabBarItem = itemWeather;
    marksNC.tabBarItem = itemMarks;
    
   // [UITabBar appearance].tintColor = [UIColor colorWithRed:0/255.0 green:146/255.0 blue:248/255.0 alpha:1.0];
    //[UIView appearance].backgroundColor = [UIColor whiteColor];
    
    NSArray *viewControllers = [NSArray arrayWithObjects: marksNC, mapNC, wheatherNC, fishListNC, nil];
    [tabBarController setViewControllers:viewControllers];
    
    //[mainViewController.view setBackgroundColor:[UIColor whiteColor]];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarController];
    navigationController.navigationBar.hidden = YES;
    [self.window setRootViewController:navigationController];
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
