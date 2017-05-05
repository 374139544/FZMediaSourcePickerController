//
//  FZMediaSourcePreviewViewController.h
//  UIClassFactory
//
//  Created by fengzhao on 2017/5/4.
//  Copyright © 2017年 fengzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FZMediaSourceAssetItem;

@interface FZMediaSourcePreviewViewController : UIViewController

@property (nonatomic, copy) BOOL(^rightNavigationItemClickBlock)(UIButton *sender, FZMediaSourceAssetItem *currentItem);

- (void)setShowAssetItems:(NSArray <FZMediaSourceAssetItem *>*)assets withIndexPath:(NSIndexPath *)indexPath;

@end
