//
//  PhotoModel.h
//  LFBPhotoPicker
//
//  Created by liufubo on 2019/7/25.
//  Copyright © 2019 liufubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PhotoModel : NSObject<NSCopying,NSMutableCopying>
//是否有图
@property (nonatomic, assign) BOOL isImage;
//相册图片
@property (nonatomic, strong) UIImage *image;
//占位图
@property (nonatomic, strong) UIImage *addImg;

@end


