//
//  FZMediaSourcePickerController.h
//  UIClassFactory
//
//  Created by fengzhao on 2017/4/20.
//  Copyright © 2017年 fengzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FZMediaSourceUtil.h"

#import "FZMediaSourcePickerControllerDelegate.h"

#ifdef __IPHONE_10_0
#endif

@interface FZMediaSourcePickerController : UINavigationController

@property (nonatomic, weak) id<FZMediaSourcePickerControllerDelegate> delegate;

@property (nonatomic, assign) FZMediaSourceType type;
@property (nonatomic, copy)   NSString *defaultAlbumName;

@property (nonatomic, assign) NSUInteger maxSelectedCount;
@property (nonatomic, assign) NSUInteger maxVideoSelectedCount;
@property (nonatomic, assign) NSUInteger maxImageSelectedCount;

@property (nonatomic, strong) NSArray <PHAsset *>*selectedItemsWithPHAsset;

@end
