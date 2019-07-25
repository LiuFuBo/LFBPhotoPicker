//
//  ViewController.m
//  LFBPhotoPicker
//
//  Created by liufubo on 2019/7/23.
//  Copyright © 2019 liufubo. All rights reserved.
//

#import "ViewController.h"
#import "PhotoModel.h"
#import "CollectionViewCell.h"
#import "LFBPhotoPickerService.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<PhotoModel *> *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
}

- (void)clickButton:(UIButton *)sender{

}
#pragma mark - UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = ([UIScreen mainScreen].bounds.size.width - 4*15)/3.0f;
    CGFloat itemHeight = itemWidth;
    return CGSizeMake(itemWidth, itemHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 15, 0, 15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CollectionViewCell class]) forIndexPath:indexPath];
    [cell photoModel:self.dataSource[indexPath.row]];
    typeof(self) __weak weakSelf = self;
    [cell photoCloseHandler:^(PhotoModel *model) {
        if ([weakSelf.dataSource containsObject:model]) {
            [weakSelf.dataSource removeObject:model];
            [weakSelf.collectionView reloadData];
        }
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
        LFBPhotoPickerService *manager = [LFBPhotoPickerService shareInstance];
        [manager lfb_SetPhotoPickerStyle:LFBPhotoPickerStyleAllDevice];
    if (indexPath.row < [self.dataSource count] -1) {
        typeof(self) __weak weakSelf = self;
        [manager lfb_GetPicture:^(NSArray *pics) {
            PhotoModel *photoReplace = [self.dataSource objectAtIndex:indexPath.row];
            photoReplace.image = [pics lastObject];
             [weakSelf.collectionView reloadData];
        }];
    }else{
        typeof(self) __weak weakSelf = self;
        [manager lfb_GetPicture:nil maxCount:10 callBack:^(NSArray *pics) {
            PhotoModel *addPhoto = [[self.dataSource lastObject] copy];
            [weakSelf.dataSource removeLastObject];
            [pics enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL * _Nonnull stop) {
                PhotoModel *photo = [PhotoModel new];
                photo.isImage = YES;
                photo.image = image;
                [weakSelf.dataSource addObject:photo];
            }];
            [weakSelf.dataSource addObject:addPhoto];
             [weakSelf.collectionView reloadData];
        }];
    }
}

#pragma mark - Getter & Setter
- (UICollectionView *)collectionView {
    return _collectionView?:({
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([CollectionViewCell class])];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        [_collectionView setShowsVerticalScrollIndicator:NO];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
        _collectionView;
    });
}

- (NSMutableArray<PhotoModel *> *)dataSource {
    return _dataSource?:({
        _dataSource = [NSMutableArray array];
        {
            PhotoModel *photo = [PhotoModel new];
            photo.addImg = [UIImage imageNamed:@"ic_upload_add"];
            [_dataSource addObject:photo];
        }
        _dataSource;
    });
}

@end
