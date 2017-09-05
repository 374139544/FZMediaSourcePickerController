//
//  UIImageView+PHAsset.m
//  UIClassFactory
//
//  Created by fengzhao on 2017/5/3.
//  Copyright © 2017年 fengzhao. All rights reserved.
//

#import "UIImageView+FZPHAsset.h"

#import <objc/runtime.h>
#import <Photos/Photos.h>

#import "FZMediaSourceCacheManager.h"

#define CurrentPHImageRequestIDKey "CurrentPHImageRequestIDKey"

@implementation UIImageView (FZPHAsset)

- (PHImageRequestID)currentPHImageRequestID
{
    return [objc_getAssociatedObject(self, CurrentPHImageRequestIDKey) intValue];
}

- (void)setCurrentPHImageRequestID:(PHImageRequestID)currentPHImageRequestID
{
    objc_setAssociatedObject(self, CurrentPHImageRequestIDKey, @(currentPHImageRequestID), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)fz_setImageWithPHAsset:(PHAsset *)asset
{
    [self fz_setImageWithPHAsset:asset placeholderImage:nil];
}

- (void)fz_setImageWithPHAsset:(PHAsset *)asset placeholderImage:(UIImage *)placeholderImage
{
    UIImage *image = [[FZMediaSourceCacheManager shareInstance] getSourceImageWithPHAsset:asset];
    
    if (image)
    {
        self.image = image;
        return;
    }
    
    self.image = placeholderImage;
    
    [[PHImageManager defaultManager] cancelImageRequest:self.currentPHImageRequestID];

    self.currentPHImageRequestID = [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        
        UIImage *image = [UIImage imageWithData:imageData];
        
        self.image = image;
        [[FZMediaSourceCacheManager shareInstance] putSourceImage:image withPHAsset:asset];
    }];
}

- (void)fz_setThumbnailImageWithPHAsset:(PHAsset *)asset thumbnailImageSize:(CGSize)size
{
    [self fz_setThumbnailImageWithPHAsset:asset thumbnailImageSize:size placeholderImage:nil];
}

- (void)fz_setThumbnailImageWithPHAsset:(PHAsset *)asset thumbnailImageSize:(CGSize)size placeholderImage:(UIImage *)placeholderImage
{
    UIImage *image = [[FZMediaSourceCacheManager shareInstance] getThumbnailImageWithPHAsset:asset imageSize:size];
    
    if (image)
    {
        self.image = image;
        return;
    }
    
    self.image = placeholderImage;
    
    [[PHImageManager defaultManager] cancelImageRequest:self.currentPHImageRequestID];
    
    self.currentPHImageRequestID = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        self.image = result;
        [[FZMediaSourceCacheManager shareInstance] putThumbnailImage:result withPHAsset:asset imageSize:size];
    }];
}

@end
