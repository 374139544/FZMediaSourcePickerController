//
//  UIImageView+AVAssetImageGenerator.h
//  FZMediaSourcePickerController
//
//  Created by fengzhao on 2017/9/6.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMedia/CMTime.h>

@class AVAssetImageGenerator;

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (AVAssetImageGenerator)

/**
 从视频中取一帧来设置显示的图片
 @param imageGenerator 通过AVAsset生成的AVAssetImageGenerator，对于同一视频，请用同一个AVAssetImageGenerator对象
 @param time 从该时间获取视频帧
 @param size 需要获取的图片大小，如果是CGSizeZero，则代表原图
 */
- (void)fz_setImageWithImageGenerator:(AVAssetImageGenerator *)imageGenerator atTime:(CMTime)time imageSize:(CGSize)size;

/**
 从视频中取一帧来设置显示的图片
 @param imageGenerator 通过AVAsset生成的AVAssetImageGenerator，对于同一视频，请用同一个AVAssetImageGenerator对象
 @param time 从该时间获取视频帧
 @param size 需要获取的图片大小，如果是CGSizeZero，则代表原图
 @param placeholderImage 在获取到视频帧之前显示的占位图
 */
- (void)fz_setImageWithImageGenerator:(AVAssetImageGenerator *)imageGenerator atTime:(CMTime)time imageSize:(CGSize)size placeholderImage:(nullable UIImage *)placeholderImage;

@end

NS_ASSUME_NONNULL_END
