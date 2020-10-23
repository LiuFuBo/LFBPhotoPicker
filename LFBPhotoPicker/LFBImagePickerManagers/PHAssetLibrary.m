//
//  PHAssetLibrary.m
//  YXYT
//
//  Created by liufubo on 2019/3/11.
//  Copyright © 2019 yixingyiting. All rights reserved.
//

#import "PHAssetLibrary.h"
#import "LFBSelfImage.h"

@implementation PHAssetLibrary

- (void)lfb_afterCameraAsset:(void (^)(PHAsset *))block{
    PHFetchOptions *option = [[PHFetchOptions alloc]init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithOptions:option];
    PHAsset *asset = [fetchResult firstObject];
    if (block) {
        block(asset);
    }
}

- (void)lfb_countOfAlbumGroup:(void(^)(NSArray <PHCollection *> *))block{
    PHFetchResult *fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    NSMutableArray *fetchObs = [NSMutableArray array];
    for (int index = 0; index< fetchResult.count; index++) {
        PHCollection *collection = [fetchResult objectAtIndex:index];
        PHFetchOptions *option = [[PHFetchOptions alloc]init];
        option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
        PHFetchResult *fetchCollectionResult = [PHAsset fetchAssetsInAssetCollection:(PHAssetCollection *)collection options:option];
        if (fetchCollectionResult.count > 2) {
          [fetchObs addObject:collection];
        }
    }
    if (block) {
        block(fetchObs);
    }
}

- (void)lfb_callAllPhoto:(PHAssetCollection *)group result:(void (^)(NSArray<LFBAsset *> *))block{
    NSMutableArray *fetchObs = [NSMutableArray array];
    PHFetchOptions *option = [[PHFetchOptions alloc]init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:group options:option];
    for (int index=0; index< fetchResult.count; index++) {
        PHAsset *asset = [fetchResult objectAtIndex:index];
        LFBAsset *dAsset = [[LFBAsset alloc]init];
        dAsset.asset = asset;
        [fetchObs addObject:dAsset];
    }
    if (block) {
        block(fetchObs);
    }
}

- (void)lfb_firstImageWithCollection:(PHAssetCollection *)group result:(void (^)(LFBSelfImage *))block{
    PHFetchOptions *option = [[PHFetchOptions alloc]init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:group options:option];
    PHAsset *asset = [fetchResult firstObject];
    [PHAssetLibrary lfb_imageWithAsset:asset size:CGSizeMake(200, 200) result:^(LFBSelfImage *image) {
        if (block && image) {
            block(image);
        }
    }];
}

+ (void)lfb_imageWithAsset:(PHAsset *)asset result:(void (^)(LFBSelfImage *))block{
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
    option.resizeMode = PHImageRequestOptionsResizeModeNone;
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    option.version = PHImageRequestOptionsVersionCurrent;
    option.networkAccessAllowed = YES;
    option.synchronous = NO;
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        BOOL downloadFinished = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![[info objectForKey:PHImageErrorKey] boolValue] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
        NSData *data = [PHAssetLibrary compressQualityWithMaxLength:100 image:[UIImage imageWithData:imageData]];
        if (block && downloadFinished && data) {
            block((LFBSelfImage *)[UIImage imageWithData:data]);
        }
    }];
}
+ (NSData *)compressQualityWithMaxLength:(NSInteger)maxLength image:(UIImage *)image {
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return data;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    return data;
}

+ (PHImageRequestID)lfb_imageWithAsset:(PHAsset *)asset size:(CGSize)size result:(void (^)(LFBSelfImage *))block{
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
    option.networkAccessAllowed = YES;
    option.synchronous = NO;
    option.version = PHImageRequestOptionsVersionCurrent;
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    PHImageRequestID requestId = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        BOOL downloadFinished = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![[info objectForKey:PHImageErrorKey] boolValue] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
        if (block && downloadFinished && result) {
            block((LFBSelfImage *)result);
        }
    }];
    return requestId;
}

+ (void)lfb_cancelAssetImageLoadWithRequestId:(PHImageRequestID)requestId{
    [[PHImageManager defaultManager] cancelImageRequest:requestId];
}


@end
