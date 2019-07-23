//
//  LFBPhotoPickerService.m
//  uploadImage
//
//  Created by branon_liu on 2017/9/21.
//  Copyright © 2017年 postop_iosdev. All rights reserved.
//
#import "LFBPhotoPickerService.h"
#import "PHAssetLibrary.h"
#import "LFBNaviServer.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "LFBImageGroupVC.h"
#import <objc/runtime.h>
#import "LFBPhotoPickerPrivate.h"


@interface LFBPhotoPickerService ()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, assign) int maxCount;
@property (nonatomic, copy) LFBPhotoPickerCallback callback;
@property (nonatomic, weak) UIViewController *currentViewController;
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
    self.currentViewController = [LFBNaviServer naviServer];
    self.maxCount = maxCount;
    self.callback = callback;
    switch (self.isSelectedPhotoAlbum) {
        case LFBPhotoPickerStyleCamera:
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄", nil];
            [actionSheet setTag:LFBPhotoPickerStyleCamera];
            [actionSheet showInView:self.currentViewController.view];
        }
            break;
        case LFBPhotoPickerStyleAlbum:
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册中选择", nil];
            [actionSheet setTag:LFBPhotoPickerStyleAlbum];
            [actionSheet showInView:self.currentViewController.view];
        }
            break;
        case LFBPhotoPickerStyleAllDevice:
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄",@"从相册中选择", nil];
            [actionSheet setTag:LFBPhotoPickerStyleAllDevice];
            [actionSheet showInView:self.currentViewController.view];
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


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == LFBPhotoPickerStyleAllDevice) {
        if (buttonIndex == 0) {
         [self pickerServiceAccessPhotoWithCamera];
        [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
        }else if (buttonIndex == 1){
            [self pickerServiceAccessPhotoWithAlbum];
        }
    }else if (actionSheet.tag == LFBPhotoPickerStyleCamera){
        if (buttonIndex == 0) {
            [self pickerServiceAccessPhotoWithCamera];
            [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
        }
    }else if (actionSheet.tag == LFBPhotoPickerStyleAlbum){
        if (buttonIndex == 0) {
            [self pickerServiceAccessPhotoWithAlbum];
            [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
        }
    }
}

- (void)pickerServiceAccessPhotoWithCamera{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"相机不能打开" message:@"请在设置-隐私-相机里面把相机权限打开" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
            [self.currentViewController presentViewController:alert animated:YES completion:nil];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"相机不能打开" message:@"请在设置-隐私-相机里面把相机权限打开" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self p_showWithType:UIImagePickerControllerSourceTypeCamera viewController:self.currentViewController allowsEditing:NO finishedBlock:self.callback];
    });
}

- (void)pickerServiceAccessPhotoWithAlbum{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == PHAuthorizationStatusRestricted || status ==PHAuthorizationStatusDenied)
            {
                if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"相册不能打开" message:@"请在设置-隐私-相册里面把相机权限打开" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
                    [self.currentViewController presentViewController:alert animated:YES completion:nil];
                }else{
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"相册不能打开" message:@"请在设置-隐私-相册里面把相机权限打开" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                }
                return;
            }
            LFBImageGroupVC *groupVc = [[LFBImageGroupVC alloc]init];
            groupVc.albumColor = [UIColor whiteColor];
            groupVc.listCount = 4;
            groupVc.maxImageCount = self.maxCount;
            UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:groupVc];
            [self.currentViewController presentViewController:Nav animated:YES completion:nil];
        });
    }];
}

- (void)pickerServiceAccessPhotoFail {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"获取拍摄图片失败" message:@"请在设置-隐私-相册里面把相机权限打开" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
            [[LFBNaviServer naviServer] presentViewController:alert animated:YES completion:nil];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"获取拍摄图片失败" message:@"请在设置-隐私-相册里面把相机权限打开" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    });
}

- (void)imagePickerControllerDidFinishPickingmediaWithInfo:(NSNotification *)info{
    
    NSArray *array = [NSArray arrayWithArray:info.userInfo[@"picture"]];
    self.callback(array);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self.currentViewController dismissViewControllerAnimated:YES completion:nil];
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
    @weakify(self);
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == PHAuthorizationStatusRestricted || status ==PHAuthorizationStatusDenied){
                [self pickerServiceAccessPhotoFail];
            }{
                //获取操作的图片
                PHAssetLibrary *libray = [[PHAssetLibrary alloc]init];
                [libray lfb_afterCameraAsset:^(PHAsset *asset) {
                    @strongify(self);
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
- (void)p_showWithType:(UIImagePickerControllerSourceType)type viewController:(nonnull UIViewController *)vc allowsEditing:(BOOL)allowsEditing finishedBlock:(nonnull void(^)(NSArray * _Nonnull pics))block{
    
    UIImagePickerController *imageVc = [[UIImagePickerController alloc]init];
    imageVc.sourceType = type;
    
    LFBPhotoPickerService *manager = [LFBPhotoPickerService new];
    manager->_callback = [block copy];
    //retain self
    objc_setAssociatedObject(manager, (__bridge void *)manager, manager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    imageVc.delegate = manager;
    imageVc.allowsEditing = allowsEditing;
    imageVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [vc presentViewController:imageVc animated:YES completion:nil];
}



@end
