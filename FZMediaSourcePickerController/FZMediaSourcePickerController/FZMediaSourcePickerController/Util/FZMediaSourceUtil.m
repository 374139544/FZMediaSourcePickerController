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

+ (NSArray <FZMediaSourceAlbum *>*)fetchSmartAlbumListWithMediaType:(FZMediaSourceType)mediaType
{
    NSMutableArray *mediaTypes = [NSMutableArray array];
    
    for (int  i = 0; i <= PHAssetMediaTypeAudio; i++)
    {
        if (mediaType & 1 << i)
        {
            [mediaTypes addObject:@(i)];
        }
    }
    
    NSMutableArray <FZMediaSourceAlbum *>*resultList = [NSMutableArray array];
    
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    for (int i = 0; i < smartAlbums.count; i++)
    {
        FZMediaSourceAlbum *album = [FZMediaSourceAlbum new];
        
        PHAssetCollection *collection = [smartAlbums objectAtIndex:i];
        album.album = collection;
        
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        options.predicate = [NSPredicate predicateWithFormat:@"mediaType in %@", mediaTypes];
        
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:options];
        album.count = fetchResult.count;
        
        [fetchResult enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            PHAsset *asset = (PHAsset *)obj;
            
            PHImageRequestOptions *opt = [[PHImageRequestOptions alloc] init];
            opt.synchronous = YES;
            
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeAspectFit options:opt resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                
                album.image = result;
            }];
            
            *stop = YES;
        }];
        
        [resultList addObject:album];
    }

    return resultList;
}

+ (NSArray <FZMediaSourceAlbum *>*)fetchUserAlbumListWithMediaType:(FZMediaSourceType)mediaType
{
    NSMutableArray *mediaTypes = [NSMutableArray array];
    
    for (int  i = 0; i <= PHAssetMediaTypeAudio; i++)
    {
        if (mediaType & 1 << i)
        {
            [mediaTypes addObject:@(i)];
        }
    }
    
    NSMutableArray <FZMediaSourceAlbum *>*resultList = [NSMutableArray array];
    
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];

    for (int i = 0; i < userAlbums.count; i++)
    {
        FZMediaSourceAlbum *album = [FZMediaSourceAlbum new];
        
        PHAssetCollection *collection = [userAlbums objectAtIndex:i];
        album.album = collection;
        
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        options.predicate = [NSPredicate predicateWithFormat:@"mediaType in %@", mediaTypes];
        
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:options];
        album.count = fetchResult.count;
        
        [fetchResult enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            PHAsset *asset = (PHAsset *)obj;
            
            PHImageRequestOptions *opt = [[PHImageRequestOptions alloc] init];
            opt.synchronous = YES;
            
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeAspectFit options:opt resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                
                album.image = result;
            }];
            
            *stop = YES;
        }];
        
        [resultList addObject:album];
    }
    return resultList;
}

+ (NSArray <FZMediaSourceAlbum *>*)fetchAllAlbumListWithMediaType:(FZMediaSourceType)mediaType
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
