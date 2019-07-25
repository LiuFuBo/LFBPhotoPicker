
** iOS 相册图片选择器，使用简单，易扩展，滑动流畅性优化和内存控制，让你的程序运行更稳健。**


# 使用要求
* iOS8.0及以上系统


# 预览

![](https://github.com/LiuFuBo/LFBPhotoPicker/blob/master/LFBPhotoPicker/photo.gif)

# 功能目录


- 支持 拍照、相册选择两种方式获取图片
- 用户可自定义最多获取图片张数




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
 
