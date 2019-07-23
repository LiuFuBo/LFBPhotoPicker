//
//  LFBShowImageCell.h
//  uploadImage
//
//  Created by branon_liu on 2017/9/20.
//  Copyright © 2017年 postop_iosdev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFBShowImageCell : UICollectionViewCell
//图片
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
//按钮
@property (strong, nonatomic) IBOutlet UIButton *selectBtn;
//按钮选定
@property(nonatomic,copy)void(^selectedBlock)(NSInteger index);
//取消选定
@property(nonatomic,copy)void(^cancelBlock)(NSInteger index);
//按钮事件
- (IBAction)clickBtn:(UIButton *)sender;
//更新按钮状态
- (void)updateImage:(BOOL)isSelected;


- (void)p_clickButtonWithBlock:(void(^)(UIButton *sender))block;

- (void)p_showAlertMessages:(NSString *)message;

@end
