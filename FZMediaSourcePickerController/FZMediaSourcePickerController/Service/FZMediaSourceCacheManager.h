//
//  FZMediaSourceCacheManager.h
//  UIClassFactory
//
//  Created by fengzhao on 2017/5/4.
//  Copyright © 2017年 fengzhao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Photos/Photos.h>

#import "SingleModel.h"

@interface FZMediaSourceCacheManager : NSObject

SingleModelInterface

- (void)putSourceImage:(UIImage *)image withPHAsset:(PHAsset *)asset;
- (UIImage *)getSourceImageWithPHAsset:(PHAsset *)asset;

- (void)putThumbnailImage:(UIImage *)image withPHAsset:(PHAsset *)asset imageSize:(CGSize)size;
- (UIImage *)getThumbnailImageWithPHAsset:(PHAsset *)asset imageSize:(CGSize)size;

- (void)clearAllCache;

@end