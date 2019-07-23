//
//  LFBImageGroupViewController.m
//  uploadImage
//
//  Created by branon_liu on 2017/9/20.
//  Copyright © 2017年 postop_iosdev. All rights reserved.
//

#import "LFBImageGroupVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "LFBPhotoPickerService.h"
#import "LFBShowImageVC.h"
#import "PHAssetLibrary.h"
#import "LFBPhotoPickerPrivate.h"
#import "YXYTGroupImageCell.h"



static NSString *const LFBImageGroupVCCellIdentifier = @"LFBImageGroupVCCellIdentifier";
@interface LFBImageGroupVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *imageArray;

@end

@implementation LFBImageGroupVC

- (void)dealloc{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfig];
    [self addSubViews];
    [self bindingData];
    [self bindingEvents];
    [self addLeftItemBtn];
}

- (void)initConfig{
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)addSubViews{
    self.navigationController.navigationBar.translucent = NO;
    [self.view addSubview:self.tableView];
}

- (void)bindingData{
    _imageArray = [NSMutableArray array];
    //获取相册个数
    @weakify(self);
    PHAssetLibrary *library = [[PHAssetLibrary alloc]init];
    [library lfb_countOfAlbumGroup:^(NSArray<PHCollection *> *collections) {
        @strongify(self);
        [self.imageArray addObjectsFromArray:collections];
        [self.tableView reloadData];
    }];
}

- (void)bindingEvents{
    self.title = @"相 册";
}

#pragma mark 返回按钮设置事件
- (void)addLeftItemBtn{

    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [returnBtn setTitle:@"取 消" forState:UIControlStateNormal];
    returnBtn.frame = CGRectMake(0, 0, 40, 30);
    [returnBtn addTarget:self action:@selector(clickReturnBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemBtn = [[UIBarButtonItem alloc]initWithCustomView:returnBtn];
    self.navigationItem.leftBarButtonItem = itemBtn;
}

//返回按钮
- (void)clickReturnBtn{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - tableview delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.imageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    YXYTGroupImageCell *cell = [tableView dequeueReusableCellWithIdentifier:LFBImageGroupVCCellIdentifier];
    if (!cell) {
        cell = [[YXYTGroupImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LFBImageGroupVCCellIdentifier];
    }
    PHAssetCollection *group = (PHAssetCollection *)[_imageArray objectAtIndex:indexPath.row];
    PHFetchOptions *option = [[PHFetchOptions alloc]init];
    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:group options:option];
    if (group) {
        //获取相册第一张图片作为封面图片
        [[[PHAssetLibrary alloc]init] lfb_firstImageWithCollection:group result:^(LFBSelfImage *image) {
            if (image) {
                [cell setImage: (UIImage *)image];
            }
        }];
        //相册名字
        NSString *groupName = group.localizedTitle;
        if ([groupName isEqualToString:@"Camera Roll"]) {
            groupName = @"我的相册";
        }
        [cell setText:[NSString stringWithFormat:@"%@(%ld)",groupName,(long)fetchResult.count]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //跳转
    LFBShowImageVC *show = [[LFBShowImageVC alloc]init];
    PHAssetCollection *group = (PHAssetCollection *)[_imageArray objectAtIndex:indexPath.row];
    show.group = group;
    show.listCount = self.listCount;
    show.color = self.albumColor;
    show.maxImageCount = self.maxImageCount;
    [self.navigationController pushViewController:show animated:YES];
}

- (UITableView *)tableView{
    return _tableView?:({
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        [_tableView registerClass:[YXYTGroupImageCell class] forCellReuseIdentifier:LFBImageGroupVCCellIdentifier];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        [_tableView setEstimatedSectionHeaderHeight:0];
        [_tableView setEstimatedSectionFooterHeight:0];
        [_tableView setEstimatedRowHeight:0];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView;
    });
}



@end
