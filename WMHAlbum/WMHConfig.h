//
//  WMHConfig.h
//  WMHAlbum
//
//  Created by 王闽航 on 2018/8/8.
//  Copyright © 2018年 9JIBidding. All rights reserved.
//

#ifndef WMHConfig_h
#define WMHConfig_h

#import <Photos/Photos.h>
#import "WMHPhotoTool.h"

#define kScreenBounds   ([UIScreen mainScreen].bounds)
#define kScreenWidth    kScreenBounds.size.width
#define kScreenHeight   kScreenBounds.size.height

/**
 * 状态栏高度
 */
#define Height_StatusBar [[UIApplication sharedApplication] statusBarFrame].size.height

/**
 * 导航栏栏高度
 */
#define kNavigationBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height > 20 ? 88 : 64)

/**
 * 底部安全区高度
 */
#define iPhone_X_BottomHeight ([[UIApplication sharedApplication] statusBarFrame].size.height > 20 ? 34.0 : 0.0)

#define CH_RGBColor(r, g, b, i) \
[UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:i]
#define kDefaultColor CH_RGBColor(255, 255, 255, 1)

///////ZLBigImageCell 不建议设置太大，太大的话会导致图片加载过慢
#define kMaxImageWidth 500

#define weakify(var)   __weak typeof(var) weakSelf = var
#define strongify(var) __strong typeof(var) strongSelf = var

static inline CAKeyframeAnimation * GetBtnStatusChangedAnimation() {
    CAKeyframeAnimation *animate = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animate.duration = 0.3;
    animate.removedOnCompletion = YES;
    animate.fillMode = kCAFillModeForwards;
    
    animate.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)],
                       [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)],
                       [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)],
                       [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    return animate;
}

#endif /* WMHConfig_h */
