//
//  FZMediaSourcePickerControllerDelegate.h
//  UIClassFactory
//
//  Created by fengzhao on 2017/5/4.
//  Copyright © 2017年 fengzhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FZMediaSourcePickerController;

@protocol FZMediaSourcePickerControllerDelegate <UINavigationControllerDelegate>

- (void)mediaSourcePickerControllerDidCancle:(FZMediaSourcePickerController *)picker;
- (void)mediaSourcePickerController:(FZMediaSourcePickerController *)picker didFinishPickingAsset:(NSArray <PHAsset *>*)assets;

@end
