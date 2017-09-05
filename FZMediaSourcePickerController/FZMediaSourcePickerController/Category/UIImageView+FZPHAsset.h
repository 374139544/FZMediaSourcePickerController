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

- (void)fz_setImageWithPHAsset:(PHAsset *)asset;

- (void)fz_setImageWithPHAsset:(PHAsset *)asset placeholderImage:(UIImage *)placeholderImage;

- (void)fz_setThumbnailImageWithPHAsset:(PHAsset *)asset thumbnailImageSize:(CGSize)size;

- (void)fz_setThumbnailImageWithPHAsset:(PHAsset *)asset thumbnailImageSize:(CGSize)size placeholderImage:(UIImage *)placeholderImage;

@end
