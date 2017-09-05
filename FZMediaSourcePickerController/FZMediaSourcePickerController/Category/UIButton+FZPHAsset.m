//
//  UIButton+PHAsset.m
//  ninth
//
//  Created by fengzhao on 2017/5/19.
//  Copyright © 2017年 ninth. All rights reserved.
//

#import "UIButton+FZPHAsset.h"
#import <objc/runtime.h>
#import <Photos/Photos.h>

#import "FZMediaSourceCacheManager.h"

#define CurrentPHImageRequestIDKey "CurrentPHImageRequestIDKey"

@implementation UIButton (FZPHAsset)

- (PHImageRequestID)currentPHImageRequestID
{
    return [objc_getAssociatedObject(self, CurrentPHImageRequestIDKey) intValue];
}

- (void)setCurrentPHImageRequestID:(PHImageRequestID)currentPHImageRequestID
{
    objc_setAssociatedObject(self, CurrentPHImageRequestIDKey, @(currentPHImageRequestID), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)fz_setImageWithPHAsset:(PHAsset *)asset forState:(UIControlState)state
{
    [self fz_setImageWithPHAsset:asset placeholderImage:nil forState:state];
}

- (void)fz_setImageWithPHAsset:(PHAsset *)asset placeholderImage:(UIImage *)placeholderImage forState:(UIControlState)state
{
    UIImage *image = [[FZMediaSourceCacheManager shareInstance] getSourceImageWithPHAsset:asset];
    
    if (image)
    {
        [self setImage:image forState:state];
        return;
    }
    
    [self setImage:placeholderImage forState:state];
    
    [[PHImageManager defaultManager] cancelImageRequest:self.currentPHImageRequestID];
    
    self.currentPHImageRequestID = [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        
        UIImage *image = [UIImage imageWithData:imageData];
        
        [self setImage:image forState:state];

        [[FZMediaSourceCacheManager shareInstance] putSourceImage:image withPHAsset:asset];
    }];
}

- (void)fz_setThumbnailImageWithPHAsset:(PHAsset *)asset thumbnailImageSize:(CGSize)size forState:(UIControlState)state
{
    [self fz_setThumbnailImageWithPHAsset:asset thumbnailImageSize:size placeholderImage:nil forState:state];
}

- (void)fz_setThumbnailImageWithPHAsset:(PHAsset *)asset thumbnailImageSize:(CGSize)size placeholderImage:(UIImage *)placeholderImage forState:(UIControlState)state
{
    UIImage *image = [[FZMediaSourceCacheManager shareInstance] getThumbnailImageWithPHAsset:asset imageSize:size];
    
    if (image)
    {
        [self setImage:image forState:state];
        return;
    }
    
    [self setImage:placeholderImage forState:state];
    
    [[PHImageManager defaultManager] cancelImageRequest:self.currentPHImageRequestID];
    
    self.currentPHImageRequestID = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        [self setImage:result forState:state];
        [[FZMediaSourceCacheManager shareInstance] putThumbnailImage:result withPHAsset:asset imageSize:size];
    }];
}

- (void)fz_setBackgroundImageWithPHAsset:(PHAsset *)asset forState:(UIControlState)state
{
    [self fz_setBackgroundImageWithPHAsset:asset placeholderImage:nil forState:state];
}

- (void)fz_setBackgroundImageWithPHAsset:(PHAsset *)asset placeholderImage:(UIImage *)placeholderImage forState:(UIControlState)state
{
    UIImage *image = [[FZMediaSourceCacheManager shareInstance] getSourceImageWithPHAsset:asset];
    
    if (image)
    {
        [self setBackgroundImage:image forState:state];
        return;
    }
    
    [self setBackgroundImage:placeholderImage forState:state];
    
    [[PHImageManager defaultManager] cancelImageRequest:self.currentPHImageRequestID];
    
    self.currentPHImageRequestID = [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        
        UIImage *image = [UIImage imageWithData:imageData];
        
        [self setBackgroundImage:image forState:state];
        
        [[FZMediaSourceCacheManager shareInstance] putSourceImage:image withPHAsset:asset];
    }];
}

- (void)fz_setBackgroundThumbnailImageWithPHAsset:(PHAsset *)asset thumbnailImageSize:(CGSize)size forState:(UIControlState)state
{
    [self fz_setBackgroundThumbnailImageWithPHAsset:asset thumbnailImageSize:size placeholderImage:nil forState:state];
}

- (void)fz_setBackgroundThumbnailImageWithPHAsset:(PHAsset *)asset thumbnailImageSize:(CGSize)size placeholderImage:(UIImage *)placeholderImage forState:(UIControlState)state
{
    UIImage *image = [[FZMediaSourceCacheManager shareInstance] getThumbnailImageWithPHAsset:asset imageSize:size];
    
    if (image)
    {
        [self setBackgroundImage:image forState:state];
        return;
    }
    
    [self setBackgroundImage:placeholderImage forState:state];
    
    [[PHImageManager defaultManager] cancelImageRequest:self.currentPHImageRequestID];
    
    self.currentPHImageRequestID = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        [self setBackgroundImage:result forState:state];
        [[FZMediaSourceCacheManager shareInstance] putThumbnailImage:result withPHAsset:asset imageSize:size];
    }];
}

@end
