//
//  UIButton+PHAsset.h
//  ninth
//
//  Created by fengzhao on 2017/5/19.
//  Copyright © 2017年 ninth. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHAsset;

@interface UIButton (FZPHAsset)

- (void)fz_setImageWithPHAsset:(PHAsset *)asset forState:(UIControlState)state;
- (void)fz_setImageWithPHAsset:(PHAsset *)asset placeholderImage:(UIImage *)placeholderImage forState:(UIControlState)state;

- (void)fz_setThumbnailImageWithPHAsset:(PHAsset *)asset thumbnailImageSize:(CGSize)size forState:(UIControlState)state;
- (void)fz_setThumbnailImageWithPHAsset:(PHAsset *)asset thumbnailImageSize:(CGSize)size placeholderImage:(UIImage *)placeholderImage forState:(UIControlState)state;


- (void)fz_setBackgroundImageWithPHAsset:(PHAsset *)asset forState:(UIControlState)state;
- (void)fz_setBackgroundImageWithPHAsset:(PHAsset *)asset placeholderImage:(UIImage *)placeholderImage forState:(UIControlState)state;

- (void)fz_setBackgroundThumbnailImageWithPHAsset:(PHAsset *)asset thumbnailImageSize:(CGSize)size forState:(UIControlState)state;
- (void)fz_setBackgroundThumbnailImageWithPHAsset:(PHAsset *)asset thumbnailImageSize:(CGSize)size placeholderImage:(UIImage *)placeholderImage forState:(UIControlState)state;

@end
