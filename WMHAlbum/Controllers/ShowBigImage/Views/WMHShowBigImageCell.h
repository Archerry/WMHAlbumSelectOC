//
//  WMHShowBigImageCell.h
//  WMHAlbum
//
//  Created by 王闽航 on 2018/8/9.
//  Copyright © 2018年 9JIBidding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMHShowBigImageCell : UICollectionViewCell

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, copy)   void (^singleTapCallBack)();

@end
