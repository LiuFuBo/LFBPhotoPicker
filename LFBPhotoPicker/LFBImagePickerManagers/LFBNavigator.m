//
//  LFBNavigator.m
//  LFBPhotoPicker
//
//  Created by liufubo on 2020/10/23.
//  Copyright © 2020 liufubo. All rights reserved.
//

#import "LFBNavigator.h"


@implementation LFBNavigator

+ (void)pushWithViewController:(UIViewController *)controller {
    [[LFBNavigator getNavigation] pushViewController:controller animated:YES];
}

+ (void)presentWithViewController:(UIViewController *)controller {
     controller.modalPresentationStyle = UIModalPresentationFullScreen;
    [[LFBNavigator getTopVC] presentViewController:controller animated:YES completion:nil];
}

+ (void)presentWithNaviController:(UINavigationController *)naviController {
    naviController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [[LFBNavigator getTopVC] presentViewController:naviController animated:YES completion:nil];
}

+ (void)dismissViewControllerAnimated:(BOOL)Animated {
    [[LFBNavigator getTopVC] dismissViewControllerAnimated:Animated completion:nil];
}

+ (UINavigationController *)getNavigation{
    UITabBarController *tabBarController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *navigation = (UINavigationController *)tabBarController.selectedViewController;
    return navigation;
}

+ (UIViewController *)getTopVC {
    
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
