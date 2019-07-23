//
//  YXYTGroupImageCell.m
//  YXYT
//
//  Created by liufubo on 2019/3/12.
//  Copyright © 2019 yixingyiting. All rights reserved.
//

#import "YXYTGroupImageCell.h"
#import "Masonry.h"

@interface YXYTGroupImageCell ()
@property (nonatomic, strong) UIImageView *imageViewIcon;
@property (nonatomic, strong) UILabel *labelName;
@end

@implementation YXYTGroupImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubViews];
        [self initLayout];
    }
    return self;
}

- (void)addSubViews{
    [self.contentView addSubview:self.imageViewIcon];
    [self.contentView addSubview:self.labelName];
}

- (void)initLayout{
    [self.imageViewIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).with.offset(15);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.height.mas_equalTo(60);
    }];
    [self.labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageViewIcon.mas_right).with.offset(15);
        make.top.mas_equalTo(self.contentView.mas_top).with.offset(20);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).with.offset(-20);
        make.right.mas_equalTo(self.contentView.mas_right);
    }];
}

- (void)setText:(NSString *)text{
    [self.labelName setText:text];
}

- (void)setImage:(UIImage *)image{
    [self.imageViewIcon setImage:image];
}

- (UIImageView *)imageViewIcon{
    return _imageViewIcon?:({
        _imageViewIcon = [[UIImageView alloc]init];
        _imageViewIcon.contentMode = UIViewContentModeScaleAspectFill;
        _imageViewIcon.clipsToBounds = YES;
        _imageViewIcon;
    });
}

- (UILabel *)labelName{
    return _labelName?:({
        _labelName = [[UILabel alloc]init];
        _labelName.font = [UIFont systemFontOfSize:15];
        _labelName.textColor = [UIColor blackColor];
        _labelName.textAlignment = NSTextAlignmentLeft;
        _labelName;
    });
}

@end
