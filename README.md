# FUCallSDKDemo 快速接入文档

FUCallSDKDemo 是集成了 Faceunity 面部跟踪和虚拟道具功能 和 [ILiveSDK](https://github.com/zhaoyang21cn/CallSDK_iOS_Demo)  视频通话功能的 Demo。

本文是 FaceUnity SDK 快速对腾讯视频通话 的导读说明，关于 `FaceUnity SDK` 的详细说明，请参看 [FULiveDemo](https://github.com/Faceunity/FULiveDemo/tree/dev)

**注：本例为示例 demo，仅接入了双人视频通话，如需多人视频通话请客户自行定义。下载后需要先执行Frameworks文件夹下的脚本loadSDK.sh下载ILiveSDK、AVSDK、IMSDK等相关库，详情请参考[ILiveSDK](https://github.com/zhaoyang21cn/CallSDK_iOS_Demo) **

## 快速集成方法

### 一、获取视频数据

在 CallC2CMakeViewController.m 和 CallC2CRecvViewController.m 的 `viewDidLoad` 方法中设置 `ILiveRoomManager ` 的代理，并实现代理方法。

```C
- (void)viewDidLoad{
    // 加入代理方法
    [[ILiveRoomManager getInstance] setLocalVideoDelegate:self];
}

#pragma mark --- QAVLocalVideoDelegate
- (void)OnLocalVideoPreview:(QAVVideoFrame *)frameData
{
}

- (void)OnLocalVideoPreProcess:(QAVVideoFrame *)frameData {
}

- (void)OnLocalVideoRawSampleBuf:(CMSampleBufferRef)buf result:(CMSampleBufferRef *)ret {
}
```



在 `-(void)OnLocalVideoRawSampleBuf:(CMSampleBufferRef)buf result:(CMSampleBufferRef *)ret` 方法中即可获得视频数据回调。

### 二、导入 SDK

将 FaceUnity 文件夹全部拖入工程中，并且添加依赖库 OpenGLES.framework、Accelerate.framework、CoreMedia.framework、AVFoundation.framework、stdc++.tbd

### 三、快速加载道具

在 `viewDidLoad` 中调用快速加载道具函数，该函数会创建一个美颜道具及指定的贴纸道具。

```c
[[FUManager shareManager] loadItems];
```

注：FUManager 的 shareManager 函数中会对 SDK 进行初始化，并设置默认的美颜参数。

### 三、图像处理

在  `-(void)OnLocalVideoRawSampleBuf:(CMSampleBufferRef)buf result:(CMSampleBufferRef *)ret `方法中获取视频数据，并对图像进行处理：

```c
- (void)OnLocalVideoRawSampleBuf:(CMSampleBufferRef)buf result:(CMSampleBufferRef *)ret {
    
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(buf) ;
    [[FUManager shareManager] renderItemsToPixelBuffer:pixelBuffer];
}
```

### 四、切换道具及调整美颜参数

本例中通过添加 FUAPIDemoBar 来实现切换道具及调整美颜参数的具体实现，FUAPIDemoBar 是快速集成用的UI，客户可自定义UI。

1、在 LiveViewController.m 中添加头文件，并创建 demoBar 属性

```C
#import <FUAPIDemoBar/FUAPIDemoBar.h>

@property (nonatomic, strong) FUAPIDemoBar *demoBar ;
```

2、在 demoBar 的 get 方法中对其进行初始化，并遵循代理  FUAPIDemoBarDelegate，实现代理方法 `demoBarDidSelectedItem:` 和 `demoBarBeautyParamChanged`以进一步实现道具的切换及美颜参数的调整。

初始化

```C
// demobar 初始化
-(FUAPIDemoBar *)demoBar {
    if (!_demoBar) {
        
        _demoBar = [[FUAPIDemoBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 164 - 44, self.view.frame.size.width, 164)];
        
        _demoBar.itemsDataSource = [FUManager shareManager].itemsDataSource;
        _demoBar.selectedItem = [FUManager shareManager].selectedItem ;
        
        _demoBar.filtersDataSource = [FUManager shareManager].filtersDataSource ;
        _demoBar.beautyFiltersDataSource = [FUManager shareManager].beautyFiltersDataSource ;
        _demoBar.filtersCHName = [FUManager shareManager].filtersCHName ;
        _demoBar.selectedFilter = [FUManager shareManager].selectedFilter ;
        [_demoBar setFilterLevel:[FUManager shareManager].selectedFilterLevel forFilter:[FUManager shareManager].selectedFilter] ;
        
        _demoBar.skinDetectEnable = [FUManager shareManager].skinDetectEnable;
        _demoBar.blurShape = [FUManager shareManager].blurShape ;
        _demoBar.blurLevel = [FUManager shareManager].blurLevel ;
        _demoBar.whiteLevel = [FUManager shareManager].whiteLevel ;
        _demoBar.redLevel = [FUManager shareManager].redLevel;
        _demoBar.eyelightingLevel = [FUManager shareManager].eyelightingLevel ;
        _demoBar.beautyToothLevel = [FUManager shareManager].beautyToothLevel ;
        _demoBar.faceShape = [FUManager shareManager].faceShape ;
        
        _demoBar.enlargingLevel = [FUManager shareManager].enlargingLevel ;
        _demoBar.thinningLevel = [FUManager shareManager].thinningLevel ;
        _demoBar.enlargingLevel_new = [FUManager shareManager].enlargingLevel ;
        _demoBar.thinningLevel_new = [FUManager shareManager].thinningLevel ;
        _demoBar.jewLevel = [FUManager shareManager].jewLevel ;
        _demoBar.foreheadLevel = [FUManager shareManager].foreheadLevel ;
        _demoBar.noseLevel = [FUManager shareManager].noseLevel ;
        _demoBar.mouthLevel = [FUManager shareManager].mouthLevel ;
        
        _demoBar.delegate = self;
    }
    return _demoBar ;
}
```

切换贴纸代理方法

```C
/**      FUAPIDemoBarDelegate       **/

// 切换贴纸
- (void)demoBarDidSelectedItem:(NSString *)itemName {
    
    [[FUManager shareManager] loadItem:itemName];
}
```

更新美颜参数方法

```C
// 更新美颜参数
- (void)demoBarBeautyParamChanged {
    
    [FUManager shareManager].skinDetectEnable = _demoBar.skinDetectEnable;
    [FUManager shareManager].blurShape = _demoBar.blurShape;
    [FUManager shareManager].blurLevel = _demoBar.blurLevel ;
    [FUManager shareManager].whiteLevel = _demoBar.whiteLevel;
    [FUManager shareManager].redLevel = _demoBar.redLevel;
    [FUManager shareManager].eyelightingLevel = _demoBar.eyelightingLevel;
    [FUManager shareManager].beautyToothLevel = _demoBar.beautyToothLevel;
    [FUManager shareManager].faceShape = _demoBar.faceShape;
    [FUManager shareManager].enlargingLevel = _demoBar.enlargingLevel;
    [FUManager shareManager].thinningLevel = _demoBar.thinningLevel;
    [FUManager shareManager].enlargingLevel_new = _demoBar.enlargingLevel_new;
    [FUManager shareManager].thinningLevel_new = _demoBar.thinningLevel_new;
    [FUManager shareManager].jewLevel = _demoBar.jewLevel;
    [FUManager shareManager].foreheadLevel = _demoBar.foreheadLevel;
    [FUManager shareManager].noseLevel = _demoBar.noseLevel;
    [FUManager shareManager].mouthLevel = _demoBar.mouthLevel;
    
    [FUManager shareManager].selectedFilter = _demoBar.selectedFilter ;
    [FUManager shareManager].selectedFilterLevel = _demoBar.selectedFilterLevel;
}
```

3、在 `viewDidLoad:` 中将 demoBar 添加到页面上

```C
[self.view addSubview:self.demoBar];
```



### **五**、道具销毁

视频录制结束时需要调用 `[[FUManager shareManager] destoryItems]`  销毁道具。

**快速集成完毕，关于 FaceUnity SDK 的更多详细说明，请参看 [FULiveDemo](https://github.com/Faceunity/FULiveDemo/tree/dev)**