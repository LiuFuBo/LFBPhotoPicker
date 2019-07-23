//
//  ViewController.m
//  LFBPhotoPicker
//
//  Created by liufubo on 2019/7/23.
//  Copyright © 2019 liufubo. All rights reserved.
//

#import "ViewController.h"
#import "LFBPhotoPickerService.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [[UIButton alloc]init];
    button.bounds = CGRectMake(0, 0, 120, 44);
    button.center = self.view.center;
    button.backgroundColor = [UIColor orangeColor];
    [button setTitle:@"开始" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)clickButton:(UIButton *)sender{
    LFBPhotoPickerService *manager = [LFBPhotoPickerService shareInstance];
    [manager lfb_SetPhotoPickerStyle:LFBPhotoPickerStyleAlbum];
    [manager lfb_GetPicture:nil maxCount:10 callBack:^(NSArray *pics) {
        
    }];
}


@end
