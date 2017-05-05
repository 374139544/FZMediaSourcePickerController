//
//  FZMediaSourceAssetItem.h
//  UIClassFactory
//
//  Created by fengzhao on 2017/4/21.
//  Copyright © 2017年 fengzhao. All rights reserved.
//

#import <Photos/Photos.h>

@class FZMediaSourceAsset;

@interface FZMediaSourceAssetItem : NSObject

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, assign, getter=isSelected) BOOL selected;
@property (nonatomic, assign) BOOL canSelect;

@end
