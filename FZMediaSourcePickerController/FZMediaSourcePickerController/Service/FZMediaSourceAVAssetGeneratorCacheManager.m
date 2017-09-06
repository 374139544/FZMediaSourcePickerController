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

@property (nonatomic, strong) NSMutableDictionary <NSString *, NSMutableDictionary<NSString *, FZMediaSourceAVAssetGeneratorCacheObject *>*>*cacheDict;
@property (nonatomic, strong) dispatch_queue_t cacheManagerQueue;

@end

@implementation FZMediaSourceAVAssetGeneratorCacheManager

SingleModelImplementation

- (void)putImage:(UIImage *)image withImageGenerator:(AVAssetImageGenerator *)imageGenerator atTime:(CMTime)time imageSize:(CGSize)size
{
    dispatch_async(self.cacheManagerQueue, ^{
        NSString *assetKey = [NSString stringWithFormat:@"%p", imageGenerator];
        
        NSMutableDictionary <NSString *, FZMediaSourceAVAssetGeneratorCacheObject *>*dict = self.cacheDict[assetKey];
        
        if (!dict)
        {
            dict = [NSMutableDictionary dictionary];
            self.cacheDict[assetKey] = dict;
        }
        
        NSString *key = [NSString stringWithFormat:@"%lld/%d_%f*%f", time.value, time.timescale, image.size.width, image.size.height];
        
        if (!dict[key])
        {
            dict[key] = [FZMediaSourceAVAssetGeneratorCacheObject new];
        }
        
        dict[key].image = image;
        dict[key].size = image.size;
        dict[key].time = time;
        
        [self autoClearCacheWithImageGenerator:imageGenerator size:image.size currentTime:time];
    });
}

- (UIImage *)getImageWithImageGenerator:(AVAssetImageGenerator *)imageGenerator atTime:(CMTime)time imageSize:(CGSize)size
{
    __block UIImage *returnImage = nil;
    dispatch_sync(self.cacheManagerQueue, ^{
        NSString *assetKey = [NSString stringWithFormat:@"%p", imageGenerator];
        NSString *key = [NSString stringWithFormat:@"%lld/%d_%f*%f", time.value, time.timescale, size.width, size.height];
        returnImage = self.cacheDict[assetKey][key].image;
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

- (void)autoClearCacheWithImageGenerator:(AVAssetImageGenerator *)imageGenerator size:(CGSize)size currentTime:(CMTime)currentTime
{
    NSString *assetKey = [NSString stringWithFormat:@"%p", imageGenerator];
    NSMutableDictionary *assetDict = self.cacheDict[assetKey];
    
    for (NSString *key in self.cacheDict.allKeys)
    {
        if (![assetKey isEqualToString:key])
        {
            [self.cacheDict removeObjectForKey:key];
        }
    }
    
    if (assetDict.allKeys.count < MaxCacheImageCount)
    {
        return;
    }
    
    for (NSString *key in assetDict.allKeys)
    {
        FZMediaSourceAVAssetGeneratorCacheObject *obj = assetDict[key];
        
        if (!CGSizeEqualToSize(obj.size, size))
        {
            [assetDict removeObjectForKey:key];
        }
    }
    
    if (assetDict.count < MaxCacheImageCount)
    {
        return;
    }
    
    int leftCount = 0;
    int rightCount = 0;
    
    for (int i = 0; i < 5; i ++)
    {
        NSArray *keys = assetDict.allKeys;
        FZMediaSourceAVAssetGeneratorCacheObject *obj = assetDict[keys[i]];
        if (CMTimeGetSeconds(obj.time) < CMTimeGetSeconds(currentTime))
        {
            leftCount ++;
        }
        else
        {
            rightCount ++;
        }
    }
    
    for (NSString *key in assetDict.allKeys)
    {
        FZMediaSourceAVAssetGeneratorCacheObject *obj = assetDict[key];
        
        if (leftCount > rightCount)
        {
            if (CMTimeGetSeconds(obj.time) < CMTimeGetSeconds(currentTime) - AdjustCacheImageTime)
            {
                [assetDict removeObjectForKey:key];
            }
        }
        else
        {
            if (CMTimeGetSeconds(obj.time) > CMTimeGetSeconds(currentTime) + AdjustCacheImageTime)
            {
                [assetDict removeObjectForKey:key];
            }
        }
    }
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
