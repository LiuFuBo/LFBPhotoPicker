//
//  LFBNaviServer.m
//  LFBNovel
//
//  Created by liufubo on 2019/6/3.
//  Copyright © 2019 liufubo. All rights reserved.
//

#import "LFBNaviServer.h"

@implementation LFBNaviServer

+ (void)pushWithViewController:(UIViewController *)controller{
    [[self getNavigation].navigationController pushViewController:controller animated:YES];
}

+ (void)popToViewController{
    [[self getNavigation] popViewControllerAnimated:YES];
}

+ (void)popToRootViewController{
    [[self getNavigation] popToRootViewControllerAnimated:YES];
}

+ (void)popToTargetViewController:(Class)classVC{
    for (UIViewController *vc in [self getNavigation].viewControllers) {
        if ([vc isKindOfClass:classVC]) {
            [[self getNavigation] popToViewController:vc animated:YES];
        }
    }
}

+ (void)presentWithViewController:(UIViewController *)controller{
    [[self topViewController] presentViewController:controller animated:YES completion:nil];
}

+ (void)dismissViewController:(UIViewController *)controller{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

+ (UINavigationController *)getNavigation{
    UITabBarController *tabBarController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *navigation = (UINavigationController *)tabBarController.selectedViewController;
    return navigation;
}

+ (UIViewController *)naviServer {
    return [LFBNaviServer topViewController];
}

#pragma mark - 获取顶层Vc
+ (UIViewController *)topViewController{
    UIViewController *rootViewController =[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    return  [self topViewControllerWithRootViewController:rootViewController];
}

+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if (rootViewController.presentedViewController) {
        
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else {
        return rootViewController;
    }
}


@end
