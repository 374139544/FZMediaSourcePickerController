//
//  FZMediaSourceAssetPickerViewCell.h
//  UIClassFactory
//
//  Created by fengzhao on 2017/4/21.
//  Copyright © 2017年 fengzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FZMediaSourceAssetItem;

@interface FZMediaSourceAssetPickerViewCell : UICollectionViewCell

@property (nonatomic, strong) FZMediaSourceAssetItem *assetItem;
@property (nonatomic, copy) void(^selectButtonClickBlock)(FZMediaSourceAssetPickerViewCell *cell);

@end
