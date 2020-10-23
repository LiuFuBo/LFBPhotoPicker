//
//  LFBImageGroupViewController.h
//  uploadImage
//
//  Created by branon_liu on 2017/9/20.
//  Copyright © 2017年 postop_iosdev. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface LFBImageGroupVC : UIViewController

//显示照片的背景色
@property (nonatomic, strong) UIColor *albumColor;
//显示照片的一行几个
@property (nonatomic, assign) NSInteger listCount;
//最多能拍照片个数
@property (nonatomic, assign) int maxImageCount;

@end
