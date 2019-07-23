//
//  LFBNaviServer.h
//  LFBNovel
//
//  Created by liufubo on 2019/6/3.
//  Copyright © 2019 liufubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface LFBNaviServer : NSObject

/** 返回上一页 */
+ (void)popToViewController;
/** 返回根页面 */
+ (void)popToRootViewController;
/** 返回指定目标页面 */
+ (void)popToTargetViewController:(Class)classVC;
/**  跳转目标页面 */
+ (void)pushWithViewController:(UIViewController *)controller;
/**  跳转目标页面 */
+ (void)presentWithViewController:(UIViewController *)controller;
/** 返回上一页*/
+ (void)dismissViewController:(UIViewController *)controller;
/** 获取顶部视图 */
+ (UIViewController *)naviServer;

@end


