//
//  LFBPhotoPickerService.h
//  uploadImage
//
//  Created by branon_liu on 2017/9/21.
//  Copyright © 2017年 postop_iosdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
@import UIKit;

typedef NS_ENUM(NSUInteger, LFBPhotoPickerStyle) {
    LFBPhotoPickerStyleCamera = 0,//相机
    LFBPhotoPickerStyleAlbum,//相册
    LFBPhotoPickerStyleAllDevice//相机和相册
};

typedef void(^LFBPhotoPickerCallback)(NSArray *pics);
@interface LFBPhotoPickerService : NSObject

/**
 实例化对象

 @return 返回当前对象
 */
+ (instancetype)shareInstance;



/**
 设置photo style (默认拍照选择样式)

 @param style 类型
 */
- (void)lfb_SetPhotoPickerStyle:(LFBPhotoPickerStyle)style;

/**
 获取相册/拍摄所得图片

 @param title    设置弹出选择框标题
 @param maxCount 最大上传图片数量
 @param callback 返回装有图片的数组
 */
- (void)lfb_GetPicture:(NSString *)title maxCount:(int)maxCount callBack:(LFBPhotoPickerCallback)callback;

/**
 获取相册/拍摄所得图片

 @param title 设置弹出选择框标题
 @param callback 返回装有图片的数组
 */
- (void)lfb_GetPicture:(NSString *)title callBack:(LFBPhotoPickerCallback)callback;

/**
 获取相册/拍摄所得图片

 @param callback 返回装有图片的数组
 */
- (void)lfb_GetPicture:(LFBPhotoPickerCallback)callback;


@end
