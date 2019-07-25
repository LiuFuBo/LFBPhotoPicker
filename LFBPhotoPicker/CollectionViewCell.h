//
//  CollectionViewCell.h
//  LFBPhotoPicker
//
//  Created by liufubo on 2019/7/25.
//  Copyright © 2019 liufubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoModel.h"


@interface CollectionViewCell : UICollectionViewCell

- (void)photoModel:(PhotoModel *)model;

- (void)photoCloseHandler:(void(^)(PhotoModel *model))handler;

@end


