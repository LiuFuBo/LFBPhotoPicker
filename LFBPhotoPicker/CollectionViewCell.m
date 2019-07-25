//
//  CollectionViewCell.m
//  LFBPhotoPicker
//
//  Created by liufubo on 2019/7/25.
//  Copyright © 2019 liufubo. All rights reserved.
//

#import "CollectionViewCell.h"

@interface CollectionViewCell ()
@property (nonatomic, strong) UIView *viewCover;
@property (nonatomic, strong) UIImageView *imageViewAdd;
@property (nonatomic, strong) UIImageView *imageViewPic;
@property (nonatomic, strong) UIButton *buttonClose;
@property (nonatomic, strong) PhotoModel *photo;
@end

@implementation CollectionViewCell{
    void(^_photoHandler)(PhotoModel *model);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    //背景圆角
    _viewCover = [[UIView alloc]init];
    _viewCover.frame = self.contentView.bounds;
    _viewCover.layer.cornerRadius = 10;
    _viewCover.layer.masksToBounds = YES;
    _viewCover.backgroundColor = [UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
    [self.contentView addSubview:_viewCover];
    
    //添加图片占位图标
    _imageViewAdd = [[UIImageView alloc]init];
    _imageViewAdd.bounds = CGRectMake(0, 0, 35, 35);
    _imageViewAdd.center = _viewCover.center;
    _imageViewAdd.contentMode = UIViewContentModeScaleAspectFill;
    _imageViewAdd.clipsToBounds = YES;
    [self.contentView addSubview:_imageViewAdd];
    
    //系统相册图片
    _imageViewPic = [[UIImageView alloc]init];
    _imageViewPic.frame = self.viewCover.bounds;
    _imageViewPic.layer.cornerRadius = 10;
    _imageViewPic.layer.masksToBounds = YES;
    _imageViewPic.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_imageViewPic];
    
    //删除图片按钮
    _buttonClose = [[UIButton alloc]init];
    [_buttonClose setImage:[UIImage imageNamed:@"btn_pic_closess"] forState:UIControlStateNormal];
    [_buttonClose addTarget:self action:@selector(buttonClose:) forControlEvents:UIControlEventTouchDown];
    CGFloat originX = CGRectGetMaxX(self.viewCover.frame) - 35;
    _buttonClose.frame = CGRectMake(originX, 10, 25, 25);
    [self.contentView addSubview:_buttonClose];
}

- (void)buttonClose:(UIButton *)sender {
    if (_photoHandler) {
        _photoHandler(_photo);
    }
}

- (void)photoCloseHandler:(void (^)(PhotoModel *))handler {
    _photoHandler = [handler copy];
}

- (void)photoModel:(PhotoModel *)model {
    if (model.isImage) {
        [self.buttonClose setHidden:NO];
        [self.imageViewAdd setHidden:YES];
        [self.imageViewPic setHidden:NO];
        [self.imageViewPic setImage:model.image];
    }else{
        [self.buttonClose setHidden:YES];
        [self.imageViewAdd setHidden:NO];
        [self.imageViewPic setHidden:YES];
        [self.imageViewAdd setImage:model.addImg];
    }
    [self setPhoto:model];
}

@end
