//
//  AppDelegate.m
//  tipcalculator
//
//  Created by Helen Kuo on 12/30/14.
//  Copyright (c) 2014 Helen Kuo. All rights reserved.
//

#import "AppDelegate.h"
#import "TipViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    TipViewController *vc = [[TipViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nvc;
    return YES;
}

@end
