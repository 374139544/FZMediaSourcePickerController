//
//  FZMediaSourceUtil.m
//  UIClassFactory
//
//  Created by fengzhao on 2017/4/20.
//  Copyright © 2017年 fengzhao. All rights reserved.
//

#import "FZMediaSourceUtil.h"

#import "FZMediaSourceAlbum.h"

@implementation FZMediaSourceUtil

+ (NSArray <PHAssetCollection *>*)fetchSmartAlbumListWithMediaType:(FZMediaSourceType)mediaType
{
    NSMutableArray *mediaTypes = [NSMutableArray array];
    
    for (int  i = 0; i <= PHAssetMediaTypeAudio; i++)
    {
        if (mediaType & 1 << i)
        {
            [mediaTypes addObject:@(i)];
        }
    }
    
    NSMutableArray <PHAssetCollection *>*resultList = [NSMutableArray array];
    
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    for (int i = 0; i < smartAlbums.count; i++)
    {
        [resultList addObject:[smartAlbums objectAtIndex:i]];
    }

    return resultList;
}

+ (NSArray <PHAssetCollection *>*)fetchUserAlbumListWithMediaType:(FZMediaSourceType)mediaType
{
    NSMutableArray *mediaTypes = [NSMutableArray array];
    
    for (int  i = 0; i <= PHAssetMediaTypeAudio; i++)
    {
        if (mediaType & 1 << i)
        {
            [mediaTypes addObject:@(i)];
        }
    }
    
    NSMutableArray <PHAssetCollection *>*resultList = [NSMutableArray array];
    
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];

    for (int i = 0; i < userAlbums.count; i++)
    {
        [resultList addObject:[userAlbums objectAtIndex:i]];
    }
    return resultList;
}

+ (NSArray <PHAssetCollection *>*)fetchAllAlbumListWithMediaType:(FZMediaSourceType)mediaType
{
    NSArray *list1 = [self fetchSmartAlbumListWithMediaType:mediaType];
    NSArray *list2 = [self fetchUserAlbumListWithMediaType:mediaType];

    return [list1 arrayByAddingObjectsFromArray:list2];
}

+ (PHFetchResult *)fetchAssetsFromAlbumWithName:(NSString *)albumName sourcrType:(FZMediaSourceType)type
{
    PHAssetCollection *assetCollection = [self fetchAlbumWithName:albumName];
    
    return [self fetchAssetsFromAlbum:assetCollection sourcrType:type];
}

+ (PHFetchResult *)fetchAssetsFromAlbum:(PHAssetCollection *)album sourcrType:(FZMediaSourceType)type
{
    NSMutableArray *mediaTypes = [NSMutableArray array];
    
    for (int  i = 0; i <= PHAssetMediaTypeAudio; i++)
    {
        if (type & 1 << i)
        {
            [mediaTypes addObject:@(i)];
        }
    }
    
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType in %@", mediaTypes];
    
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:album options:options];
    
    return fetchResult;
}

+ (PHAssetCollection *)fetchAlbumWithName:(NSString *)albumName
{
    PHFetchResult *result = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    for (NSInteger i = 0; i < result.count; i++)
    {
        PHCollection *collection = result[i];
        
        if (![collection isKindOfClass:[PHAssetCollection class]])
        {
            return nil;
        }
        
        PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
        
        if ([assetCollection.localizedTitle isEqualToString:albumName])
        {
            return assetCollection;
        }
    }
    
    return nil;
}

@end
