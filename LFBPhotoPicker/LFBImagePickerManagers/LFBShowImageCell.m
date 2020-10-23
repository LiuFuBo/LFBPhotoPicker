//
//  LFBShowImageCell.m
//  uploadImage
//
//  Created by branon_liu on 2017/9/20.
//  Copyright © 2017年 postop_iosdev. All rights reserved.
//

#import "LFBShowImageCell.h"
#import "LFBNavigator.h"

@interface LFBShowImageCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageViewTick;

@end

@implementation LFBShowImageCell{

    void (^_addClickBlock)(UIButton *sender);
}

-(void)dealloc{


}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateImage:(BOOL)isSelected{
    if (isSelected) {
        [self.imageViewTick setImage:[UIImage imageNamed:@"ic_photo_hook_p"]];
    }else{
        [self.imageViewTick setImage:[UIImage imageNamed:@"ic_photo_hook"]];
    }
}

- (void)p_clickButtonWithBlock:(void (^)(UIButton *))block{

    _addClickBlock = [block copy];
}

- (IBAction)clickBtn:(UIButton *)sender {
    !_addClickBlock ? : _addClickBlock(sender);  
}

- (void)p_showAlertMessages:(NSString *)message{

    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [LFBNavigator presentWithViewController:alert];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}




@end
