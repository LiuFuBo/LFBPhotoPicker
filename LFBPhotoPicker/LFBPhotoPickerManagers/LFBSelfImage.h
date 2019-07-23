//
//  LFBSelfImage.h
//  uploadImage
//
//  Created by branon_liu on 2017/9/20.
//  Copyright © 2017年 postop_iosdev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHAsset;
@interface LFBSelfImage : UIImage

//可能需要的图片信息
@property (nonatomic, strong) PHAsset *asset;
//当前数据下标
@property (nonatomic, assign) NSInteger currentIndexs;

@end
