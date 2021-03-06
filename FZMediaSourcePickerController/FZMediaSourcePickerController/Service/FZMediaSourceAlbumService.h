//
//  FZMediaSourceAlbumService.h
//  FZMediaSourcePickerController
//
//  Created by fengzhao on 2017/5/9.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FZMediaSourceUtil.h"

@class FZMediaSourceAlbum;

NS_ASSUME_NONNULL_BEGIN

@interface FZMediaSourceAlbumService : NSObject

+ (void)loadAlbumsWithType:(FZMediaSourceType)type thumbnailImageSize:(CGSize)thumbnailImageSize completionHandler:(void(^)(NSArray <FZMediaSourceAlbum *>*))completionHandler;

@end

NS_ASSUME_NONNULL_END
