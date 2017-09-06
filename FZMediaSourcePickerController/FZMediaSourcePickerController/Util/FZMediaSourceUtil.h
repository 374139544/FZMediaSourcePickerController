//
//  FZMediaSourceUtil.h
//  UIClassFactory
//
//  Created by fengzhao on 2017/4/20.
//  Copyright © 2017年 fengzhao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Photos/Photos.h>

@class FZMediaSourceAlbum;

typedef NS_OPTIONS(NSUInteger, FZMediaSourceType)
{
    FZMediaSourceTypeUnknown = 1 << PHAssetMediaTypeUnknown,
    FZMediaSourceTypeImage   = 1 << PHAssetMediaTypeImage,
    FZMediaSourceTypeVideo   = 1 << PHAssetMediaTypeVideo,
    FZMediaSourceTypeAudio   = 1 << PHAssetMediaTypeAudio,
    FZMediaSourceTypeAll     = 15
};

NS_ASSUME_NONNULL_BEGIN

@interface FZMediaSourceUtil : NSObject

+ (NSArray <PHAssetCollection *>*)fetchSmartAlbumListWithMediaType:(FZMediaSourceType)mediaType;
+ (NSArray <PHAssetCollection *>*)fetchUserAlbumListWithMediaType:(FZMediaSourceType)mediaType;
+ (NSArray <PHAssetCollection *>*)fetchAllAlbumListWithMediaType:(FZMediaSourceType)mediaType;

+ (PHFetchResult *)fetchAssetsFromAlbumWithName:(NSString *)albumName sourcrType:(FZMediaSourceType)type;
+ (PHFetchResult *)fetchAssetsFromAlbum:(PHAssetCollection *)album sourcrType:(FZMediaSourceType)type;

+ (nullable PHAssetCollection *)fetchAlbumWithName:(NSString *)albumName;

@end

NS_ASSUME_NONNULL_END
