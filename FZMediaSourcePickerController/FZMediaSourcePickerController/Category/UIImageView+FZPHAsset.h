//
//  UIImageView+PHAsset.h
//  UIClassFactory
//
//  Created by fengzhao on 2017/5/3.
//  Copyright © 2017年 fengzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHAsset;

@interface UIImageView (FZPHAsset)

/**
 从PHAsset中获取图片并显示
 @param size 需要显示的图片的大小，如果是CGSizeZero，则代表原图
 */
- (void)fz_setImageWithPHAsset:(PHAsset *)asset imageSize:(CGSize)size;

/**
 从PHAsset中获取图片并显示
 @param size 需要显示的图片的大小，如果是CGSizeZero，则代表原图
 @param placeholderImage 获取到图片之前显示的占位图
 */
- (void)fz_setImageWithPHAsset:(PHAsset *)asset imageSize:(CGSize)size placeholderImage:(UIImage *)placeholderImage;

@end
