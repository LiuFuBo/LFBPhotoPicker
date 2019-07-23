# LFBPhotoPicker
一款轻量级系统相册图片多选框架，可支持拍照


# 使用要求
* iOS8.0及以上系统


# 安装

* 手动将文件导入项目中
* pod 导入Masonry三方库

# 用法

 1.初始化LFBPhotoPickerService单例
 
 <pre><code>
 LFBPhotoPickerService *manager = [LFBPhotoPickerService shareInstance];
 </code></pre>
 
 2.设置弹框类型
 
 <pre><code>
 [manager lfb_SetPhotoPickerStyle:LFBPhotoPickerStyleAlbum];
 </code></pre>
 
 3.获取相册图片
 
  <pre><code>
  //maxCount 为最多一次性获取多少张图片
  [manager lfb_GetPicture:nil maxCount:10 callBack:^(NSArray *pics) {
        
    }];
 </code></pre>
 
