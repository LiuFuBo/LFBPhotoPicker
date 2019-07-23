//
//  LFBShowImageViewController.h
//  uploadImage
//
//  Created by branon_liu on 2017/9/20.
//  Copyright © 2017年 postop_iosdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface LFBShowImageVC : UIViewController

//获得相册组
@property (nonatomic, strong) PHAssetCollection *group;
//相册的背景色(默认黑色)
@property(nonatomic,strong) UIColor *color;
//一行能显示几张图片,默认四个
@property (nonatomic, assign) NSInteger listCount;
//最多能够添加照片张数
@property (nonatomic, assign) NSInteger maxImageCount;


@end
