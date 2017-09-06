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

- (void)fz_setImageWithPHAsset:(PHAsset *)asset imageSize:(CGSize)size
{
    [self fz_setImageWithPHAsset:asset imageSize:size placeholderImage:nil];
}

- (void)fz_setImageWithPHAsset:(PHAsset *)asset imageSize:(CGSize)size placeholderImage:(UIImage *)placeholderImage
{
    self.image = placeholderImage;
    [[PHImageManager defaultManager] cancelImageRequest:self.currentPHImageRequestID];
    
    if (CGSizeEqualToSize(size, CGSizeZero))
    {
        self.currentPHImageRequestID = [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            
            if ([info[PHImageResultIsDegradedKey] boolValue]) return;
            UIImage *image = [UIImage imageWithData:imageData];
            self.image = image;
        }];
    }
    else
    {
        self.currentPHImageRequestID = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            if ([info[PHImageResultIsDegradedKey] boolValue]) return;
            self.image = result;
        }];
    }
}

@end
