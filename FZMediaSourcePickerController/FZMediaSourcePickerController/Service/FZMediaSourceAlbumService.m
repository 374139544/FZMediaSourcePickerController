//
//  FZMediaSourceAlbumService.m
//  FZMediaSourcePickerController
//
//  Created by fengzhao on 2017/5/9.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "FZMediaSourceAlbumService.h"

#import "FZMediaSourceUtil.h"

#import "FZMediaSourceAlbum.h"

@implementation FZMediaSourceAlbumService

+ (void)loadAlbumsWithType:(FZMediaSourceType)type thumbnailImageSize:(CGSize)thumbnailImageSize completionHandler:(void (^)(NSArray<FZMediaSourceAlbum *> *))completionHandler
{
    NSMutableArray *mediaTypes = [NSMutableArray array];
    
    for (int  i = 0; i <= PHAssetMediaTypeAudio; i++)
    {
        if (type & 1 << i)
        {
            [mediaTypes addObject:@(i)];
        }
    }
    
    NSArray *albumsList = [FZMediaSourceUtil fetchAllAlbumListWithMediaType:type];
    
    NSMutableArray *resultList = [NSMutableArray array];
    
    for (int i = 0; i < albumsList.count; i++)
    {
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        options.predicate = [NSPredicate predicateWithFormat:@"mediaType in %@", mediaTypes];
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:albumsList[i] options:options];
        
        if (fetchResult.count <= 0)
        {
            continue;
        }
        
        FZMediaSourceAlbum *album = [FZMediaSourceAlbum new];
        album.album = albumsList[i];
        album.count = fetchResult.count;
        
        [fetchResult enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            PHAsset *asset = (PHAsset *)obj;
            
            PHImageRequestOptions *opt = [[PHImageRequestOptions alloc] init];
            opt.synchronous = YES;
            
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:thumbnailImageSize contentMode:PHImageContentModeAspectFit options:opt resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                if ([info[PHImageResultIsDegradedKey] boolValue]) return;
                album.image = result;
            }];
            
            *stop = YES;
        }];
        
        [resultList addObject:album];
    }
    
    completionHandler(resultList);
}

@end
