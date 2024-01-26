//
//  FZMediaSourceAVAssetGeneratorCacheManager.m
//  ninth
//
//  Created by fengzhao on 2017/6/28.
//  Copyright © 2017年 ninth. All rights reserved.
//

#import "FZMediaSourceAVAssetGeneratorCacheManager.h"

#define MaxCacheImageCount              200
#define AdjustCacheImageTime            100

@interface FZMediaSourceAVAssetGeneratorCacheObject : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CMTime time;

@end
@implementation FZMediaSourceAVAssetGeneratorCacheObject
@end

@interface FZMediaSourceAVAssetGeneratorCacheManager ()

@property (nonatomic, strong) NSMutableDictionary <NSString *, NSCache<NSString *, FZMediaSourceAVAssetGeneratorCacheObject *>*>*cacheDict;
@property (nonatomic, strong) dispatch_queue_t cacheManagerQueue;

@end

@implementation FZMediaSourceAVAssetGeneratorCacheManager

SingleModelImplementation

- (void)putImage:(UIImage *)image withImageGenerator:(AVAssetImageGenerator *)imageGenerator atTime:(CMTime)time imageSize:(CGSize)size
{
    dispatch_async(self.cacheManagerQueue, ^{
        NSString *assetKey = [NSString stringWithFormat:@"%p", imageGenerator];
        
        NSCache <NSString *, FZMediaSourceAVAssetGeneratorCacheObject *>*cache = self.cacheDict[assetKey];
        
        if (!cache)
        {
            cache = [[NSCache alloc] init];
            cache.countLimit = MaxCacheImageCount;
            self.cacheDict[assetKey] = cache;
        }
        
        NSString *key = [NSString stringWithFormat:@"%lld/%d_%f*%f", time.value, time.timescale, image.size.width, image.size.height];
        
        FZMediaSourceAVAssetGeneratorCacheObject *obj = [cache objectForKey:key];
        if (!obj)
        {
            obj = [FZMediaSourceAVAssetGeneratorCacheObject new];
            [cache setObject:obj forKey:key];
        }
        obj.image = image;
        obj.size = image.size;
        obj.time = time;
    });
}

- (UIImage *)getImageWithImageGenerator:(AVAssetImageGenerator *)imageGenerator atTime:(CMTime)time imageSize:(CGSize)size
{
    __block UIImage *returnImage = nil;
    dispatch_sync(self.cacheManagerQueue, ^{
        NSString *assetKey = [NSString stringWithFormat:@"%p", imageGenerator];
        NSString *key = [NSString stringWithFormat:@"%lld/%d_%f*%f", time.value, time.timescale, size.width, size.height];
        returnImage = [self.cacheDict[assetKey] objectForKey:key].image;
    });
    
    return returnImage;
}

- (void)clearCacheWithAVAsset:(AVAsset *)asset
{
    dispatch_async(self.cacheManagerQueue, ^{
        NSString *assetKey = [NSString stringWithFormat:@"%p", asset];
        [self.cacheDict removeObjectForKey:assetKey];
    });
}

- (void)clearAllCache
{
    dispatch_async(self.cacheManagerQueue, ^{
        [self.cacheDict removeAllObjects];
    });
}

- (NSMutableDictionary *)cacheDict
{
    if (!_cacheDict)
    {
        _cacheDict = [NSMutableDictionary dictionary];
    }
    return _cacheDict;
}

- (dispatch_queue_t)cacheManagerQueue
{
    if (!_cacheManagerQueue)
    {
        _cacheManagerQueue = dispatch_queue_create("FZMediaSourceAVAssetGeneratorCacheManagerQueue", nil);
    }
    return _cacheManagerQueue;
}

@end
