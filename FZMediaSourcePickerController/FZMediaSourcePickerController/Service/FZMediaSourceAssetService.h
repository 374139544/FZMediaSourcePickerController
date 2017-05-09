//
//  FZMediaSourceAssetService.h
//  UIClassFactory
//
//  Created by fengzhao on 2017/5/3.
//  Copyright © 2017年 fengzhao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FZMediaSourceUtil.h"

@class FZMediaSourceAssetItem;

@interface FZMediaSourceAssetService : NSObject

+ (void)loadAssetsWithAlbum:(PHAssetCollection *)album type:(FZMediaSourceType)type completionHandler:(void(^)(NSArray <FZMediaSourceAssetItem *>*))completionHandler;

@end
