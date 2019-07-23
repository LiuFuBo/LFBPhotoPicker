//
//  LFBAsset.h
//  YXYT
//
//  Created by liufubo on 2019/6/11.
//  Copyright © 2019 yixingyiting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface LFBAsset : NSObject
@property (nonatomic, strong) PHAsset *asset;//系统图片存储类
@property (nonatomic, assign) BOOL isLoaded;//是否已经加载完成
@property (nonatomic, strong) UIImage *image;//如果加载完成则，直接对image赋值
@property (nonatomic, strong) NSNumber *requestId;//请求图片id
@property (nonatomic, assign) NSInteger index;//图片下标


@end


