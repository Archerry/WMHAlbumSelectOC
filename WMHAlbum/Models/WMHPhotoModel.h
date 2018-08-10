//
//  WMHPhotoModel.h
//  WMHAlbum
//
//  Created by 王闽航 on 2018/8/8.
//  Copyright © 2018年 9JIBidding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMHPhotoModel : NSObject

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, copy) NSString *localIdentifier;
@property(nonatomic, copy) NSString *albumId;//相册ID

@end
