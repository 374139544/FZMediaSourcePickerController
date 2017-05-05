//
//  FZMediaSourceThumbnailImageManager.m
//  UIClassFactory
//
//  Created by fengzhao on 2017/5/4.
//  Copyright © 2017年 fengzhao. All rights reserved.
//

#import "FZMediaSourceThumbnailImageManager.h"

@interface FZMediaSourceThumbnailImageManager ()

@property (nonatomic, strong) NSMutableDictionary <NSString *, UIImage *>*cacheDict;

@end

@implementation FZMediaSourceThumbnailImageManager

SingleModelImplementation

- (void)putThumbnailImage:(UIImage *)image withPHAsset:(PHAsset *)asset
{
    self.cacheDict[asset.localIdentifier] = image;
}

- (UIImage *)getThumbnailImageWithPHAsset:(PHAsset *)asset
{
    return self.cacheDict[asset.localIdentifier];
}

- (void)clearAllCache
{
    [self.cacheDict removeAllObjects];
}

- (NSMutableDictionary *)cacheDict
{
    if (!_cacheDict)
    {
        _cacheDict = [NSMutableDictionary dictionary];
    }
    return _cacheDict;
}

@end
