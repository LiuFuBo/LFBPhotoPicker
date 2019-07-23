//
//  PHAssetLibrary.h
//  YXYT
//
//  Created by liufubo on 2019/3/11.
//  Copyright © 2019 yixingyiting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "LFBAsset.h"

@class LFBSelfImage;
@interface PHAssetLibrary : NSObject

//获取照相后的图片
- (void)lfb_afterCameraAsset:(void(^)(PHAsset *asset))block;

//计算有几个相册
- (void)lfb_countOfAlbumGroup:(void(^)(NSArray <PHCollection *> *collections))block;

//获取一个相册有多少图片
- (void)lfb_callAllPhoto:(PHAssetCollection *)group result:(void(^)(NSArray<LFBAsset *> *assets))block;

//获取相册的第一张图片
- (void)lfb_firstImageWithCollection:(PHAssetCollection *)group result:(void(^)(LFBSelfImage * image))block;

//转换PHAsset为Image
+ (void)lfb_imageWithAsset:(PHAsset *)asset result:(void(^)(LFBSelfImage * image))block;

//根据尺寸获取image
+ (PHImageRequestID)lfb_imageWithAsset:(PHAsset *)asset size:(CGSize)size result:(void(^)(LFBSelfImage * image))block;

//取消正在获取的异步图片请求
+ (void)lfb_cancelAssetImageLoadWithRequestId:(PHImageRequestID)requestId;


@end


