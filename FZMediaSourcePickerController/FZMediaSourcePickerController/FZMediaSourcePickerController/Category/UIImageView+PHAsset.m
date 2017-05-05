//
//  UIImageView+PHAsset.m
//  UIClassFactory
//
//  Created by fengzhao on 2017/5/3.
//  Copyright © 2017年 fengzhao. All rights reserved.
//

#import "UIImageView+PHAsset.h"

#import <objc/runtime.h>

#import "FZMediaSourceThumbnailImageManager.h"

#define CurrentPHImageRequestIDKey "CurrentPHImageRequestIDKey"

@implementation UIImageView (PHAsset)

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
    UIImage *image = [[FZMediaSourceThumbnailImageManager shareInstance] getThumbnailImageWithPHAsset:asset];
    
    if (image)
    {
        self.image = image;
        return;
    }
    
    self.image = placeholderImage;
    
    [[PHImageManager defaultManager] cancelImageRequest:self.currentPHImageRequestID];

    self.currentPHImageRequestID = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        self.image = result;
        [[FZMediaSourceThumbnailImageManager shareInstance] putThumbnailImage:result withPHAsset:asset];
    }];
}

@end
