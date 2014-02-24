//
//  AppDelegate.m
//  RightMVVM
//
//  Created by Denis Lebedev on 23.02.14.
//  Copyright (c) 2014 Wargaming. All rights reserved.
//

#import "AppDelegate.h"
#import "FeedViewController.h"
#import "FeedViewModel.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    FeedViewModel *viewModel = [[FeedViewModel alloc] init];
    FeedViewController *feedVC = [[FeedViewController alloc] initWithViewModel:viewModel];

    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:feedVC];
    self.window.rootViewController = navVC;

    [self.window makeKeyAndVisible];
    return YES;
}

@end
