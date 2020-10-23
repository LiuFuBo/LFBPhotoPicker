//
//  LFBNavigator.h
//  LFBPhotoPicker
//
//  Created by liufubo on 2020/10/23.
//  Copyright © 2020 liufubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface LFBNavigator : NSObject

+ (void)pushWithViewController:(UIViewController *)controller;

+ (void)presentWithViewController:(UIViewController *)controller;

+ (void)presentWithNaviController:(UINavigationController *)naviController;

+ (void)dismissViewControllerAnimated:(BOOL)Animated;


+ (UIViewController *)getTopVC;

@end


