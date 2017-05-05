//
//  FZMediaSourceThumbnailImageManager.h
//  UIClassFactory
//
//  Created by fengzhao on 2017/5/4.
//  Copyright © 2017年 fengzhao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Photos/Photos.h>

#import "SingleModel.h"

@interface FZMediaSourceThumbnailImageManager : NSObject

SingleModelInterface

- (void)putThumbnailImage:(UIImage *)image withPHAsset:(PHAsset *)asset;
- (UIImage *)getThumbnailImageWithPHAsset:(PHAsset *)asset;

- (void)clearAllCache;

@end
