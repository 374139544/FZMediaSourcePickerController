//
//  FZMediaSourceAlbum.h
//  UIClassFactory
//
//  Created by fengzhao on 2017/4/20.
//  Copyright © 2017年 fengzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHAssetCollection;

@interface FZMediaSourceAlbum : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) PHAssetCollection *album;
@property (nonatomic, assign) NSUInteger count;

@end
