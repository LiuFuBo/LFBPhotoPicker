//
//  LFBPhotoPickerService.m
//  uploadImage
//
//  Created by branon_liu on 2017/9/21.
//  Copyright © 2017年 postop_iosdev. All rights reserved.
//

#import "LFBPhotoPickerService.h"
#import "PHAssetLibrary.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "LFBImageGroupVC.h"
#import <objc/runtime.h>
#import "LFBNavigator.h"
#import "LFBPhotoPicker.h"


@interface LFBPhotoPickerService ()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, assign) int maxCount;
@property (nonatomic, copy) LFBPhotoPickerCallback callback;
@property (nonatomic, assign) LFBPhotoPickerStyle isSelectedPhotoAlbum;
@end

@implementation LFBPhotoPickerService

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(imagePickerControllerDidFinishPickingmediaWithInfo:) name:@"PicturesNotification" object:nil];
    }
    return self;
}

+ (instancetype)shareInstance{

    static LFBPhotoPickerService *shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[LFBPhotoPickerService alloc]init];
    });
    return shareInstance;
}

- (void)lfb_SetPhotoPickerStyle:(LFBPhotoPickerStyle)style{
    self.isSelectedPhotoAlbum = style;
}

- (void)lfb_GetPicture:(NSString *)title maxCount:(int)maxCount callBack:(LFBPhotoPickerCallback)callback{
    self.maxCount = maxCount;
    self.callback = callback;
    switch (self.isSelectedPhotoAlbum) {
        case LFBPhotoPickerStyleCamera:
        {
            UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self pickerServiceAccessPhotoWithCamera];
            }]];
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [LFBNavigator presentWithViewController:actionSheet];;
        }
            break;
        case LFBPhotoPickerStyleAlbum:
        {
            
            UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self pickerServiceAccessPhotoWithAlbum];
            }]];
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [LFBNavigator presentWithViewController:actionSheet];
            
        }
            break;
        case LFBPhotoPickerStyleAllDevice:
        {
            
            UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self pickerServiceAccessPhotoWithCamera];
            }]];
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self pickerServiceAccessPhotoWithAlbum];
            }]];
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [LFBNavigator presentWithViewController:actionSheet];
        }
            break;
        default:
            break;
    }
}

- (void)lfb_GetPicture:(NSString *)title callBack:(LFBPhotoPickerCallback)callback{

    [self lfb_GetPicture:title maxCount:1 callBack:callback];
}

- (void)lfb_GetPicture:(LFBPhotoPickerCallback)callback{

    [self lfb_GetPicture:@"请选择图片" callBack:callback];
}

- (void)pickerServiceAccessPhotoWithCamera{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"相机不能打开" message:@"请在设置-隐私-相机里面把相机权限打开" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
            [LFBNavigator presentWithViewController:alert];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self p_showWithType:UIImagePickerControllerSourceTypeCamera allowsEditing:NO finishedBlock:self.callback];
    });
}

- (void)pickerServiceAccessPhotoWithAlbum{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == PHAuthorizationStatusRestricted || status ==PHAuthorizationStatusDenied)
            {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"相册不能打开" message:@"请在设置-隐私-相册里面把相机权限打开" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
                    [LFBNavigator presentWithViewController:alert];
            }
            LFBImageGroupVC *groupVc = [[LFBImageGroupVC alloc]init];
            groupVc.albumColor = [UIColor whiteColor];
            groupVc.listCount = 3;
            groupVc.maxImageCount = self.maxCount;
            UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:groupVc];
            [LFBNavigator presentWithNaviController:Nav];
        });
    }];
}

- (void)pickerServiceAccessPhotoFail {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"获取拍摄图片失败" message:@"请在设置-隐私-相册里面把相机权限打开" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
            [LFBNavigator presentWithViewController:alert];
    });
}

- (void)imagePickerControllerDidFinishPickingmediaWithInfo:(NSNotification *)info{
    
    NSArray *array = [NSArray arrayWithArray:info.userInfo[@"picture"]];
    self.callback(array);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [LFBNavigator dismissViewControllerAnimated:YES];
    });
}

#pragma mark - image picker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image;
    if (picker.sourceType != UIImagePickerControllerSourceTypePhotoLibrary) {
        [picker dismissViewControllerAnimated:YES completion:nil];
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    //通过判断picker的sourceType，如果是拍照则保存到相册去.非常重要的一步，不然，无法获取照相的图片
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInf{
    @l_weakify(self);
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == PHAuthorizationStatusRestricted || status ==PHAuthorizationStatusDenied){
                [self pickerServiceAccessPhotoFail];
            }{
                //获取操作的图片
                PHAssetLibrary *libray = [[PHAssetLibrary alloc]init];
                [libray lfb_afterCameraAsset:^(PHAsset *asset) {
                    @l_strongify(self);
                    if (!asset) {
                        return;
                    }
                    [PHAssetLibrary lfb_imageWithAsset:asset size:CGSizeMake(800, 800) result:^(LFBSelfImage *image) {
                        NSArray *array = @[image];
                        if (self.callback) {
                            self.callback(array);
                        }
                    }];
                    //dealloc self
                    objc_setAssociatedObject(self, (__bridge void *)self, nil, OBJC_ASSOCIATION_ASSIGN);
                }];
            }
        });
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    //dealloc self
    objc_setAssociatedObject(self, (__bridge void *)self, nil, OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - private
- (void)p_showWithType:(UIImagePickerControllerSourceType)type allowsEditing:(BOOL)allowsEditing finishedBlock:(nonnull void(^)(NSArray * _Nonnull pics))block{
    
    UIImagePickerController *imageVc = [[UIImagePickerController alloc]init];
    imageVc.sourceType = type;
    
    LFBPhotoPickerService *manager = [LFBPhotoPickerService new];
    manager->_callback = [block copy];
    //retain self
    objc_setAssociatedObject(manager, (__bridge void *)manager, manager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    imageVc.delegate = manager;
    imageVc.allowsEditing = allowsEditing;
    [LFBNavigator presentWithViewController:imageVc];
}



@end
