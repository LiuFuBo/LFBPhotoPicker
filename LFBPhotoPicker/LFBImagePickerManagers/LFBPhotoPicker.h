//
//  LFBPhotoPicker.h
//  LFBPhotoPicker
//
//  Created by liufubo on 2020/10/23.
//  Copyright © 2020 liufubo. All rights reserved.
//

#ifndef LFBPhotoPicker_h
#define LFBPhotoPicker_h




#define l_weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#define l_strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;


#endif /* LFBPhotoPicker_h */
