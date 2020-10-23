//
//  LFBShowImageViewController.m
//  uploadImage
//
//  Created by branon_liu on 2017/9/20.
//  Copyright © 2017年 postop_iosdev. All rights reserved.
//

#import "LFBShowImageVC.h"
#import "LFBShowImageCell.h"
#import "LFBSelfImage.h"
#import "LFBAsset.h"
#import "PHAssetLibrary.h"
#import "LFBPhotoPicker.h"


static NSString *const LFBShowImageCellIdentifier = @"LFBShowImageCellIdentifier";
@interface LFBShowImageVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView *collectionView;
//所有需要显示的图片
@property(nonatomic,strong)NSMutableArray<LFBAsset *> *dataSource;
//选中的图片
@property(nonatomic,strong)NSMutableArray<LFBAsset *> *selectedArray;


@end

@implementation LFBShowImageVC{

    UIButton *_returnBtn;
    BOOL _startLoad;//是否是第一次没有开始滚动时加载
    CGFloat _contentOffsetY;//上次的offset
    CGFloat _contentOffsetSpeed;//与上次的滚动差，用于判断速度
}

- (void)dealloc{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSubViews];
    [self bindingData];
    [self addRightItemBtn];
}

- (void)initConfig{
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)addSubViews{
    self.navigationController.navigationBar.translucent = NO;
    [self.view addSubview:self.collectionView];
}

- (void)bindingData{
      self.title = @"相册";
    _startLoad = YES;
    //获取照片
    PHAssetLibrary *libray = [[PHAssetLibrary alloc]init];
    @l_weakify(self);
    [libray lfb_callAllPhoto:_group result:^(NSArray<LFBAsset *> *assets) {
        @l_strongify(self);
        [self.dataSource addObjectsFromArray:assets];
        [self.collectionView reloadData];
    }];
}

#pragma mark 返回按钮设置事件
- (void)addRightItemBtn{
    
    _returnBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_returnBtn setTitle:@"完成" forState:UIControlStateNormal];
    _returnBtn.frame = CGRectMake(0, 0, 40, 30);
    [_returnBtn addTarget:self action:@selector(clickCompleteBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemBtn = [[UIBarButtonItem alloc]initWithCustomView:_returnBtn];
    self.navigationItem.rightBarButtonItem = itemBtn;
}

- (void)clickCompleteBtn{
    //把选择的图片传送回去
    NSMutableArray *images = [NSMutableArray array];
    for (LFBAsset *asset in self.selectedArray) {
        if (asset.image) {
             [images addObject:asset.image];
        }
    }
    if (images.count == 0 && self.selectedArray.count != 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"正在从iCloud上下载图片，请稍候..." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:alert animated:YES completion:nil];
    }else if (images.count == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还未选择图片" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        NSDictionary *dicImg = @{@"picture":images};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"PicturesNotification" object:nil userInfo:dicImg];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - collectionView delegate methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    LFBShowImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LFBShowImageCellIdentifier forIndexPath:indexPath];
    @l_weakify(self);
    [cell p_clickButtonWithBlock:^(UIButton *sender) {
      @l_strongify(self);
            if(!sender.selected){
                if (self.selectedArray.count == self.maxImageCount) {
                    //不能选择了，所以要把已经改变了选择状态的变回来
                    [cell p_showAlertMessages:[NSString stringWithFormat:@"您最多能选择:%ld张",(long)self.maxImageCount]];
                    sender.selected = !sender.selected;
                }else{
                    [cell updateImage:YES];
                    if (cell.selectedBlock) {
                        !cell.selectedBlock ? : cell.selectedBlock(sender.tag);
                    }
                }
            }else{
                [cell updateImage:NO];
                if (cell.cancelBlock) {
                    !cell.cancelBlock ? : cell.cancelBlock(sender.tag);
                }
            }
         sender.selected = !sender.selected;
    }]; 
    
    //按钮选中块
    cell.selectedBlock = ^(NSInteger index){
        @l_strongify(self);
        //把选中的图片放倒一个数组里面
        LFBAsset *asset = [self.dataSource objectAtIndex:index];
        asset.index = index;
        [PHAssetLibrary lfb_imageWithAsset:asset.asset size:CGSizeMake(800, 800) result:^(LFBSelfImage *image) {
            asset.image = image;
        }];
         [self.selectedArray addObject:asset];
    };
    //取消选定
    cell.cancelBlock = ^(NSInteger index){
        @l_strongify(self);
        //找出取消的cell
        for (int assetIndex=0; assetIndex<self.selectedArray.count; assetIndex++) {
            LFBAsset *asset = [self.selectedArray objectAtIndex:assetIndex];
            if (asset.index == index) {
                //移除本地记录
                [self.selectedArray removeObject:asset];
                //如果后台暂时没有获取到该图片，还在从icloud加载图片，则取消请求
                if (!asset.image) {
                    [PHAssetLibrary lfb_cancelAssetImageLoadWithRequestId:(PHImageRequestID)asset.requestId.intValue];
                }
            }
        }
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(LFBShowImageCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource.count > 0 && _startLoad) {
        [self loadImageForCell:cell atIndexPath:indexPath];
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _startLoad = NO;
    _contentOffsetSpeed = fabs(scrollView.contentOffset.y - _contentOffsetY);
    if (_contentOffsetSpeed < 10.0) {
     [self loadImageForVisibleCells];
    }
    _contentOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _startLoad = NO;
    _contentOffsetSpeed = 0.0f;
    [self loadImageForVisibleCells];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
     _startLoad = NO;
    _contentOffsetSpeed = 0.0f;
    [self loadImageForVisibleCells];
}

- (void)loadImageForVisibleCells{
    NSArray *visibleCells = [self.collectionView visibleCells];
    for (UICollectionViewCell *cell in visibleCells) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        [self loadImageForCell:(LFBShowImageCell *)cell atIndexPath:indexPath];
    }
}

- (void)loadImageForCell:(LFBShowImageCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    //数据
    NSInteger cellIndex = indexPath.row;
    cell.selectBtn.tag = cellIndex;
    LFBAsset *asset = [_dataSource objectAtIndex:cellIndex];
    if (asset.isLoaded) {
        [self setCacheImageWithAsset:asset atCell:cell];
    }else{
        [self loadLibraryImageWithAsset:asset atCell:cell];
    }
}

- (void)loadLibraryImageWithAsset:(LFBAsset *)asset atCell:(LFBShowImageCell *)cell {
    if (!asset.requestId) {
        //当快速来回滑动时，可能相同id的图片还没加载回来，通过判断是否已经在加载，或者加载完成来去重
        PHImageRequestID requestId = [PHAssetLibrary lfb_imageWithAsset:asset.asset size:CGSizeMake(self.view.frame.size.width, self.view.frame.size.width) result:^(LFBSelfImage *image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [asset setIsLoaded:YES];
                [asset setImage:image];
                [cell.imageView setImage:image];
                [cell.imageView performSelector:@selector(setImage:) withObject:image afterDelay:0 inModes:@[NSRunLoopCommonModes]];
            });
        }];
        asset.requestId = @(requestId);
    }
}

- (void)setCacheImageWithAsset:(LFBAsset *)asset atCell:(LFBShowImageCell *)cell {
    [cell.imageView setImage:asset.image];
    [cell.imageView performSelector:@selector(setImage:) withObject:asset.image afterDelay:0 inModes:@[NSRunLoopCommonModes]];
}

/**
 *  格式
 *
 *  @return flowlayout
 */
- (UICollectionViewFlowLayout *)setFlowOut{
    
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc]init];
    NSInteger rowCount = 4;
    if (_listCount && _listCount > 0) {
        rowCount = _listCount;
    }
    layOut.itemSize = CGSizeMake(self.view.frame.size.width / rowCount, self.view.frame.size.width / rowCount);
    layOut.minimumLineSpacing = 0;
    layOut.minimumInteritemSpacing = 0;
    return layOut;
}


- (UICollectionView *)collectionView{

    return _collectionView?:({
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - ([UIApplication sharedApplication].statusBarFrame.size.height + 44)) collectionViewLayout:[self setFlowOut]];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        if (_color) {
            _collectionView.backgroundColor = _color;
        }
        [_collectionView registerNib:[UINib nibWithNibName:@"LFBShowImageCell" bundle:nil] forCellWithReuseIdentifier:LFBShowImageCellIdentifier];
        _collectionView;
    });
}

- (NSMutableArray<LFBAsset *> *)dataSource{
    return _dataSource?:({
        _dataSource = [NSMutableArray array];
        _dataSource;
    });
}

- (NSMutableArray<LFBAsset *> *)selectedArray{
    return _selectedArray?:({
        _selectedArray = [NSMutableArray array];
        _selectedArray;
    });
}




@end
