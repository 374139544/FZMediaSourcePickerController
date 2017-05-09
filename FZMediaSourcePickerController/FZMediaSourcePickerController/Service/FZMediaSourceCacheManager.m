//
//  FZMediaSourceCacheManager.m
//  UIClassFactory
//
//  Created by fengzhao on 2017/5/4.
//  Copyright © 2017年 fengzhao. All rights reserved.
//

#import "FZMediaSourceCacheManager.h"

@interface FZMediaSourceCacheManager ()

@property (nonatomic, strong) NSMutableDictionary <NSString *, UIImage *>*cacheDict;

@end

@implementation FZMediaSourceCacheManager

SingleModelImplementation

- (void)putSourceImage:(UIImage *)image withPHAsset:(PHAsset *)asset
{
    self.cacheDict[asset.localIdentifier] = image;
}

- (UIImage *)getSourceImageWithPHAsset:(PHAsset *)asset
{
    return self.cacheDict[asset.localIdentifier];
}

- (void)putThumbnailImage:(UIImage *)image withPHAsset:(PHAsset *)asset imageSize:(CGSize)size
{
    NSString *key = [NSString stringWithFormat:@"%@_fz_%f*%f", asset.localIdentifier, size.width, size.height];
    
    self.cacheDict[key] = image;
}

- (UIImage *)getThumbnailImageWithPHAsset:(PHAsset *)asset imageSize:(CGSize)size
{
    NSString *key = [NSString stringWithFormat:@"%@_fz_%f*%f", asset.localIdentifier, size.width, size.height];
    return self.cacheDict[key];
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
