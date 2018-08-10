//
//  WMHThumbnailViewController.h
//  WMHAlbum
//
//  Created by 王闽航 on 2018/8/9.
//  Copyright © 2018年 9JIBidding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMHPhotoModel.h"
@class WMHAlbumListViewController;

@interface WMHThumbnailViewController : UIViewController

@property(nonatomic, copy) NSString *showTitle;
//相册属性
@property (nonatomic, strong) PHAssetCollection *assetCollection;
//当前已经选择的图片
@property (nonatomic, strong) NSMutableArray<WMHPhotoModel *> *arraySelectPhotos;
//最大选择数
@property (nonatomic, assign) NSInteger maxSelectCount;
//是否选择了原图
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;
//用于回调上级列表，把已选择的图片传回去
@property (nonatomic, weak) WMHAlbumListViewController *sender;
//选择完成后回调
@property (nonatomic, copy) void (^DoneBlock)(NSArray<WMHPhotoModel *> *selPhotoModels, BOOL isSelectOriginalPhoto);
//取消选择后回调
@property (nonatomic, copy) void (^CancelBlock)();
//点击返回按钮的回调
@property (nonatomic, copy) void (^onSelectedPhotos)(NSArray<WMHPhotoModel *> *, BOOL isSelectOriginalPhoto);

@end
