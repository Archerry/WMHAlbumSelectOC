//
//  WMHAlbumListViewController.h
//  WMHAlbum
//
//  Created by 王闽航 on 2018/8/8.
//  Copyright © 2018年 9JIBidding. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WMHPhotoModel;

@interface WMHAlbumListViewController : UIViewController

//最大选择数
@property (nonatomic, assign) NSInteger maxSelectCount;
//是否选择了原图
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;
//当前已经选择的图片
@property (nonatomic, strong) NSMutableArray<WMHPhotoModel *> *arraySelectPhotos;
//选则完成后回调
@property (nonatomic, copy) void (^DoneBlock)(NSArray<WMHPhotoModel *> *selPhotoModels, BOOL isSelectOriginalPhoto);
//是否直接进入所有图片缩略图界面
@property(nonatomic, assign) BOOL isPushAllPhotoSoon;
//取消选择后回调
@property (nonatomic, copy) void (^CancelBlock)();


@end
