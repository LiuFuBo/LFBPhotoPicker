//
//  LFBPhotoPickerPrivate.h
//  LFBPhotoPicker
//
//  Created by liufubo on 2019/7/23.
//  Copyright © 2019 liufubo. All rights reserved.
//

#ifndef LFBPhotoPickerPrivate_h
#define LFBPhotoPickerPrivate_h


#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;


#endif /* LFBPhotoPickerPrivate_h */
