
//
//  FZMediaSourceAssetService.m
//  UIClassFactory
//
//  Created by fengzhao on 2017/5/3.
//  Copyright © 2017年 fengzhao. All rights reserved.
//

#import "FZMediaSourceAssetService.h"

#import <Photos/Photos.h>

#import "FZMediaSourceAssetItem.h"

@implementation FZMediaSourceAssetService

+ (void)loadAssetsWithAlbum:(PHAssetCollection *)album type:(FZMediaSourceType)type completionHandler:(void(^)(NSArray <FZMediaSourceAssetItem *>*))completionHandler
{
    if (!album)
    {
        completionHandler(nil);
        return;
    }
    
    NSMutableArray *resultList = [NSMutableArray array];

    PHFetchResult *assetList = [FZMediaSourceUtil fetchAssetsFromAlbum:album sourcrType:type];

    if (!assetList || assetList.count <= 0)
    {
        completionHandler(resultList);
        return;
    }
    
    for (int i = 0; i < assetList.count; i ++)
    {
        PHAsset *asset = assetList[i];
        
        FZMediaSourceAssetItem *fzAssetItem = [FZMediaSourceAssetItem new];
        fzAssetItem.asset = asset;
        fzAssetItem.canSelect = YES;
        fzAssetItem.selected = NO;
        
        [resultList addObject:fzAssetItem];
    }
    
    completionHandler(resultList);
}

@end
