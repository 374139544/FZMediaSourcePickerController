//
//  FZMediaSourceAVAssetGeneratorCacheManager.h
//  ninth
//
//  Created by fengzhao on 2017/6/28.
//  Copyright © 2017年 ninth. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SingleModel.h"
#import <CoreMedia/CMTime.h>

@class AVAsset;
@class AVAssetImageGenerator;

NS_ASSUME_NONNULL_BEGIN

@interface FZMediaSourceAVAssetGeneratorCacheManager : NSObject

SingleModelInterface

- (void)putImage:(UIImage *)image withImageGenerator:(AVAssetImageGenerator *)imageGenerator atTime:(CMTime)time imageSize:(CGSize)size;

- (nullable UIImage *)getImageWithImageGenerator:(AVAssetImageGenerator *)imageGenerator atTime:(CMTime)time imageSize:(CGSize)size;

- (void)clearCacheWithAVAsset:(AVAsset *)asset;

- (void)clearAllCache;

@end

NS_ASSUME_NONNULL_END
