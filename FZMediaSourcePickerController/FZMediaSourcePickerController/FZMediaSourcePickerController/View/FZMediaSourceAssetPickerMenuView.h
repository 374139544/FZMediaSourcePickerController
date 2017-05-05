//
//  FZMediaSourceAssetPickerMenuView.h
//  UIClassFactory
//
//  Created by fengzhao on 2017/5/4.
//  Copyright © 2017年 fengzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZMediaSourceAssetPickerMenuView : UIView

@property (nonatomic, copy) void(^previewButtonClickBlock)(FZMediaSourceAssetPickerMenuView *menuView);
@property (nonatomic, copy) void(^editButtonClickBlock)(FZMediaSourceAssetPickerMenuView *menuView);
@property (nonatomic, copy) void(^decideButtonClickBlock)(FZMediaSourceAssetPickerMenuView *menuView);

- (void)previewEnable:(BOOL)enable;
- (void)editEnable:(BOOL)enable;
- (void)decideEnable:(BOOL)enable count:(NSUInteger )count;

@end
