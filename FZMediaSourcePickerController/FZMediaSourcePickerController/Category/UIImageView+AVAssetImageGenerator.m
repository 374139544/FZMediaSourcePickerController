//
//  UIImageView+AVAssetImageGenerator.m
//  FZMediaSourcePickerController
//
//  Created by fengzhao on 2017/9/6.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "UIImageView+AVAssetImageGenerator.h"

#import "FZMediaSourceAVAssetGeneratorCacheManager.h"

#import <objc/runtime.h>
#import <AVFoundation/AVFoundation.h>

static dispatch_queue_t queue = nil;

@interface UIImageView ()

@property (nonatomic, assign) CMTime currentShowTime;

@end

@implementation UIImageView (AVAsset)

- (dispatch_queue_t)queue
{
    if (!queue)
    {
        queue = dispatch_queue_create("", nil);
    }
    
    return queue;
}

- (void)setCurrentShowTime:(CMTime)currentShowTime
{
    objc_setAssociatedObject(self, "currentShowTime", [NSValue valueWithCMTime:currentShowTime], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CMTime)currentShowTime
{
    id obj = objc_getAssociatedObject(self, "currentShowTime");
    
    if (obj)
    {
        return [obj CMTimeValue];
    }
    else
    {
        return kCMTimeInvalid;
    }
}

- (void)fz_setImageWithImageGenerator:(AVAssetImageGenerator *)imageGenerator atTime:(CMTime)time imageSize:(CGSize)size;
{
    [self fz_setImageWithImageGenerator:imageGenerator atTime:time imageSize:size placeholderImage:nil];
}

- (void)fz_setImageWithImageGenerator:(AVAssetImageGenerator *)imageGenerator atTime:(CMTime)time imageSize:(CGSize)size placeholderImage:(UIImage *)placeholderImage
{
    if (CGSizeEqualToSize(size, CGSizeZero))
    {
        size = [[imageGenerator.asset tracksWithMediaType:AVMediaTypeVideo] lastObject].naturalSize;
    }
    
    UIImage *image = [[FZMediaSourceAVAssetGeneratorCacheManager shareInstance] getImageWithImageGenerator:imageGenerator atTime:time imageSize:size];
    
    if (image)
    {
        self.image = image;
        return;
    }
    
    self.currentShowTime = time;
    
    self.image = placeholderImage;
    
    dispatch_async(self.queue, ^{
        
        CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:nil];
        UIImage *uiImage = [UIImage imageWithCGImage:imageRef];
        CFRelease(imageRef);
        
        UIImage *showImage = [self compressImageWithImage:uiImage size:size];
        
        [[FZMediaSourceAVAssetGeneratorCacheManager shareInstance] putImage:showImage withImageGenerator:imageGenerator atTime:time imageSize:size];
        
        if (CMTimeCompare(self.currentShowTime, kCMTimeInvalid) == 0 || CMTimeCompare(self.currentShowTime, time) == 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = showImage;
            });
        }
    });
}

- (UIImage *)compressImageWithImage:(UIImage *)image size:(CGSize)size
{
    CGFloat imageWidth = 0;
    CGFloat imageHeight = 0;
    
    if ((image.size.width / image.size.height) >= (size.width / size.height))
    {
        imageWidth = size.width;
        imageHeight = imageWidth / (image.size.width / image.size.height);
    }
    else
    {
        imageHeight = size.height;
        imageWidth = size.height * (image.size.width / image.size.height);
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(imageWidth, imageHeight));
    [image drawInRect:CGRectMake(0, 0, imageWidth, imageHeight)];
    UIImage *showImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return showImage;
}

@end
