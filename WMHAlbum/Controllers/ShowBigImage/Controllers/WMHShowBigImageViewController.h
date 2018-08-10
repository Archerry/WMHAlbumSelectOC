//
//  WMHShowBigImageViewController.h
//  WMHAlbum
//
//  Created by 王闽航 on 2018/8/9.
//  Copyright © 2018年 9JIBidding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMHPhotoModel.h"
@interface WMHShowBigImageViewController : UIViewController

//相册属性
@property (nonatomic, strong) PHAssetCollection *assetCollection;
//选中的图片下标
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) NSArray<PHAsset *> *assets;
@property (nonatomic, assign) NSInteger maxSelectCount; //最大选择照片数
@property (nonatomic, assign) BOOL isSelectOriginalPhoto; //是否选择了原图
@property (nonatomic, strong) NSMutableArray<WMHPhotoModel *> *arraySelectPhotos;
@property (nonatomic, copy) void (^onSelectedPhotos)(NSArray<WMHPhotoModel *> *, BOOL isSelectOriginalPhoto); //点击返回按钮的回调

@property (nonatomic, copy) void (^btnDoneBlock)(NSArray<WMHPhotoModel *> *, BOOL isSelectOriginalPhoto); //点击确定按钮回调

@end
