//
//  PhotoModel.m
//  LFBPhotoPicker
//
//  Created by liufubo on 2019/7/25.
//  Copyright © 2019 liufubo. All rights reserved.
//

#import "PhotoModel.h"

@implementation PhotoModel

- (id)copyWithZone:(NSZone *)zone {
    PhotoModel *photo = [PhotoModel new];
    photo.isImage = self.isImage;
    photo.image = self.image;
    photo.addImg = self.addImg;
    return photo;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    PhotoModel *photo = [PhotoModel new];
    photo.isImage = self.isImage;
    photo.image = self.image;
    photo.addImg = self.addImg;
    return photo;
}

@end
